//
//  Heap.swift
//  JLKitDemo
//
//  Created by JL on 2024/10/13.
//  Copyright © 2024 JL. All rights reserved.
//

import Foundation

// 实现一个最小堆（优先级队列）
struct Heap<T: Comparable> {
    var elements: [T] = []
    let priorityFunction: (T, T) -> Bool

    init(priorityFunction: @escaping (T, T) -> Bool) {
        self.priorityFunction = priorityFunction
    }

    // 获取堆顶元素
    func peek() -> T? {
        return elements.first
    }

    // 向堆中插入元素
    mutating func insert(_ element: T) {
        elements.append(element)
        siftUp(from: elements.count - 1)
    }

    // 移除堆顶元素
    mutating func remove() -> T? {
        guard !elements.isEmpty else { return nil }
        elements.swapAt(0, elements.count - 1)
        let removedElement = elements.removeLast()
        siftDown(from: 0)
        return removedElement
    }

    // 上浮操作
    private mutating func siftUp(from index: Int) {
        var childIndex = index
        let child = elements[childIndex]
        var parentIndex = self.parentIndex(of: childIndex)

        while childIndex > 0 && priorityFunction(child, elements[parentIndex]) {
            elements[childIndex] = elements[parentIndex]
            childIndex = parentIndex
            parentIndex = self.parentIndex(of: childIndex)
        }

        elements[childIndex] = child
    }

    // 下沉操作
    private mutating func siftDown(from index: Int) {
        var parentIndex = index
        while true {
            let leftChildIndex = self.leftChildIndex(of: parentIndex)
            let rightChildIndex = self.rightChildIndex(of: parentIndex)
            var optionalParentIndex = parentIndex

            if leftChildIndex < elements.count && priorityFunction(elements[leftChildIndex], elements[optionalParentIndex]) {
                optionalParentIndex = leftChildIndex
            }

            if rightChildIndex < elements.count && priorityFunction(elements[rightChildIndex], elements[optionalParentIndex]) {
                optionalParentIndex = rightChildIndex
            }

            if optionalParentIndex == parentIndex { return }
            elements.swapAt(parentIndex, optionalParentIndex)
            parentIndex = optionalParentIndex
        }
    }

    private func parentIndex(of index: Int) -> Int {
        return (index ) / 2
    }

    private func leftChildIndex(of index: Int) -> Int {
        return (2 * index)
    }

    private func rightChildIndex(of index: Int) -> Int {
        return (2 * index) + 1
    }
}

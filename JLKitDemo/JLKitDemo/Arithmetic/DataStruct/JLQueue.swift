//
//  JLShareStack.swift
//  JLKitDemo
//
//  Created by JL on 2024/10/13.
//  Copyright © 2024 JL. All rights reserved.
//
import Foundation

//如果可以确定队列长度的最大值,用循环队列,否则用链队列
// MARK: 链式存储效率更高

class JLLinkQueue<T: Comparable> {
//    class JLLinkQueueNode: NSObject {
//        var val: T?
//        var next: JLLinkQueueNode?
//        init(val: T? = nil, next: JLLinkQueueNode? = nil) {
//            self.val = val
//            self.next = next
//        }
//    }
    var front: Node<T>
    var rear: Node<T>

    init() {
        let virtualNode = Node<T>(val: nil, next: nil)
        self.front = virtualNode
        self.rear = virtualNode
    }

    func enQueue(_ ele: T) -> StackStatus {
        let node = Node<T>(val: ele, next: nil)
        // 下面两行 处理尾结点的同时,也能处理首次入列的情况
        // 首次入列,此时front rear 共用一个结点
        // 这个操作,会使虚拟节点的next指向首个元素
        rear.next = node
        rear = node
        return .ok
    }

    func deQueue() -> (T?, StackStatus) {
        //首尾相同,也就是空队列
        if front == rear {
            return (nil, .stackEmpty)
        }
        guard let p = front.next else {
            return (nil, .stackEmpty)
        }
        if let n = p.next {
            front.next = n
        }
        //处理 最后一个元素 的情况
        if rear == p {
            rear = front
        }
        return (p.val, .ok)
    }
}

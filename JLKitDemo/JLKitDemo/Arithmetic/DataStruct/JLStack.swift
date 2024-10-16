//
//  JLStack.swift
//  JLKitDemo
//
//  Created by JL on 2024/10/13.
//  Copyright © 2024 JL. All rights reserved.
//

import Foundation

// MARK: 顺序存储

class JLStack<T> {
    /// 栈顶指针
    private var top: Int = -1
    /// 最大容量
    private var maxSize: Int = 5

    /// 顺序存储
    private var elements: [T] = []

    func push(_ ele: T) -> StackStatus {
        if top == maxSize - 1 {
            return .stackFull
        }
        self.elements.append(ele)
        top += 1
        return .ok
    }

    func pop() -> (T?, StackStatus) {
        if top == -1 {
            return (nil, .stackEmpty)
        }
        let ele = elements.last
        elements.removeLast()
        return (ele, .ok)
    }

    func topEle() -> T? {
        if top == -1 {
            return nil
        }
        return elements[top]
    }

    func size() -> Int {
        return elements.count
    }
}


/// 两栈共享空间
class JLShareStack<T> {
    enum StackNumber {
        case ONE
        case TWO
    }
    /// 最大容量
    private var maxSize: Int = 10
    /// 栈顶1号指针
    private var top1: Int = -1
    /// 栈顶2号指针
    private var top2: Int = 9

    /// 顺序存储
    var elements: [T] = []
    func push(_ ele: T, stackNum: StackNumber) -> StackStatus {
        if top1+1 == top2 {
            return .stackFull
        }
        if stackNum == .ONE {
            elements.append(ele)
            top1 += 1
        } else {
            elements.insert(ele, at: top2)
            top2 -= 1
        }
        return .ok
    }

    func pop(_ sNum: StackNumber) -> (T?, StackStatus) {
        if sNum == .ONE {
            if top1 == -1 {
                return (nil, .stackEmpty)
            }
            let ele = elements[top1]
            top1 -= 1
            return (ele, .ok)
        } else {
            if top2 == maxSize - 1 {
                return (nil, .stackEmpty)
            }
            let ele = elements[top2]
            top2 += 1
            return (ele, .ok)
        }
    }

    func topEle(_ sNum: StackNumber) -> T? {
        if sNum == .ONE {
            if top1 >= 0 && top1 <= maxSize-1 {
                return elements[top1]
            }
            return nil
        } else {
            if top2 >= 0 && top2 <= maxSize-1 {
                return elements[top2]
            }
            return nil
        }
    }

    func size() -> Int {
        return elements.count
    }
}

// MARK: 链式存储

class JLLinkStack<T: Comparable> {
//    private class JLLinkStackNode {
        /*
         如果声明 JLLinkStackNode 为 struct
         Value type 'JLLinkStack<T>.JLLinkStackNode' cannot have a stored property that recursively contains it
         */
//        var next: JLLinkStackNode?
//        var val: T?
//        init(next: JLLinkStackNode? = nil, val: T? = nil) {
//            self.next = next
//            self.val = val
//        }
//    }
    private var top: Node<T>?
    /// 最大容量
    private var maxSize: Int = 10
    /// 当前容量
    private var count: Int = 0

    func push(_ ele: T) -> StackStatus {
        let node = Node<T>(val: ele, next: top)
        top = node
        count += 1
        return .ok
    }

    func pop() -> (T?, StackStatus) {
        if count == 0 {
            return (nil, .stackEmpty)
        }
        let curTop = top
        top = top?.next
        count -= 1
        return (curTop?.val, .stackEmpty)
    }

    func topEle() -> T? {
        return top?.val
    }

    func size() -> Int {
        return count
    }
}

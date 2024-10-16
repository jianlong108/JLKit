//
//  JLLinkList.swift
//  JLKitDemo
//
//  Created by JL on 2024/10/13.
//  Copyright © 2024 JL. All rights reserved.
//

import Foundation

class JLLinkList<T: Comparable> {
    var head: Node<T> = Node(val: nil)
    func getEle(idx: Int) -> (T?, LinkStatus) {
        var p = head.next
        var i = 1
        // 工作指针p 后移
        while p != nil, i < idx {
            p = p?.next
            i += 1
        }
        if p == nil || i > idx {
            return (nil, .NoFind)
        }
        return (p?.val, .ok)
    }


    /// 在第 i个结点 前插入一个数据
    func insert(ele: T, i: Int) -> LinkStatus {
        // 0 1 2 3 4
        // 如果 idx == 2,工作指针移到 1 的位置
        var j = 1
        var p = head.next
        while p != nil, j < i {
            p = p?.next
            j += 1
        }
        if j > i || p == nil {
            return .NoFind
        }
        let node = Node(val: ele, next: p?.next)
        p?.next = node
        return .ok
    }

    /// 删除第 i 个结点
    func delete(i: Int) -> (T?, LinkStatus) {
        var j = 0
        var p = head.next
        while p != nil, j < i {
            p = p?.next
            j += 1
        }
        //找到了第 i-1的结点 如果这个结点的next 为空,代表第i个结点为空
        guard let n = p?.next, j <= i else  {
            return (nil, .NoFind)
        }
        p?.next = n.next
        return (n.val, .NoFind)
    }

}

// circular linked list
class JLCirLinkList<T: Comparable> {
    var head: Node<Int> = Node<Int>(val: 0)
//    var rear: Node<T> = Node()
    init() {
        // 空链表: 使 尾结点 指向 头结点
        self.head.next = head
    }
}

// Double linked list
class JLDoLinkList<T: Comparable> {
    var head: DoNode<Int> = DoNode<Int>(val:0, next: nil, prior: nil)
//    var rear: Node<T> = Node()
    init() {
        // 空链表: 使 尾结点 指向 头结点
        self.head.next = head
    }

}

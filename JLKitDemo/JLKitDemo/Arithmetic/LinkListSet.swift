//
//  LinkListSet.swift
//  JLKitDemo
//
//  Created by JL on 2024/10/13.
//  Copyright © 2024 JL. All rights reserved.
//

import Foundation

class LinkListSet<T> {
    /*
     将两个升序链表 合并成一个新的链表
     */
    static func mergeSortLinkList(l1: Node<Int>?, l2: Node<Int>?) -> Node<Int>? {
        /**
         当你需要创造一条新链表的时候，可以使用虚拟头结点简化边界情况的处理。
         比如说，让你把两条有序链表合并成一条新的有序链表，是不是要创造一条新链表？再比你想把一条链表分解成两条链表，是不是也在创造新链表？这些情况都可以使用虚拟头结点简化边界情况的处理。
         */
        let dummpyNode = Node<Int>(val: 0, next: nil)
        var p: Node<Int>? = dummpyNode
        var p1: Node<Int>? = l1
        var p2: Node<Int>? = l2

        while p1 != nil && p2 != nil {
            if p1!.val! > p2!.val! {
                p?.next = p2
                p2 = p2?.next
            } else {
                p?.next = p1
                p1 = p1?.next
            }
            //p指针不断前进
            p = p?.next
        }
        // 如果 p1 或 p2 有剩余节点，直接接到合并后的链表后面
        p?.next = p1 != nil ? p1 : p2

        // 返回合并后的链表（跳过虚拟头结点）
        return dummpyNode.next
    }

    
}


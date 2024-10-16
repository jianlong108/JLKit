//
//  Status.swift
//  JLKitDemo
//
//  Created by JL on 2024/10/13.
//  Copyright © 2024 JL. All rights reserved.
//

import Foundation

enum StackStatus {
    case ok
    case stackFull
    case stackEmpty
}

enum LinkStatus {
    case ok
    case NoFind
}

class Node<T: Comparable> {
    var val: T?
    var next: Node?
    init(val: T?, next: Node? = nil) {
        self.val = val
        self.next = next
    }
    // 如果不继承NSObject 判读 == 时 需要重载运算符==
    static func == (p1: Node, p2: Node) -> Bool {
        //ObjectIdentifier(lhs) == ObjectIdentifier(rhs)：通过 ObjectIdentifier 来获取对象的内存地址，并将这两个地址进行比较
        return ObjectIdentifier(p1) == ObjectIdentifier(p2)
    }
}

class DoNode<T: Comparable>: Node<T> {
    var prior: DoNode?
    init(val: T?, next: DoNode? = nil, prior: DoNode?) {
        super.init(val: val, next: next)
        self.prior = prior
    }
}

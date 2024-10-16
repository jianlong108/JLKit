//
//  ArithmeticSetViewController.swift
//  JLKitDemo
//
//  Created by JL on 2024/10/12.
//  Copyright © 2024 JL. All rights reserved.
//

import UIKit

@objc(JLArithmeticSetViewController)
public class ArithmeticSetViewController: JLBaseViewController {
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        // Must call a designated initializer of the superclass 'JLBaseViewController'
        // super.init()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        var h = Heap<Int>(priorityFunction: { $0 < $1 })

        h.insert(3)
        h.insert(2)
        h.insert(5)
        h.insert(7)
        h.insert(1)
        h.insert(8)
        h.insert(6)
        print(h.elements)
//        Task {
//            ArithmeticSetViewController.test_normal_find()
//            ArithmeticSetViewController.str_normal_find_one()
//        }
        
        DispatchQueue.global().async {
            self.test_normal_find()
            self.str_normal_find_one()
        }

    }
    
}

extension ArithmeticSetViewController {
    nonisolated func test_normal_find() {
        let s = ["","a","b","c","b","a","d"]
        let t = ["","b","a"]
        print(str_normal_find(s: s, sLen: s.count - 1, t: t, tLen: t.count - 1))
        func str_normal_find(s: [String], sLen: Int, t: [String], tLen: Int) -> Int {
            if sLen < tLen {
                return -1
            }
            var i = 1
            var j = 1
            while (i <= sLen && j <= tLen) {
                print("str_normal_find \(s[i]) \(t[j])")
                if s[i] == t[j] {
                    i += 1
                    j += 1
                } else {
                    i = i - j + 2
                    j = 1
                }
                print("str_normal_find \(i) \(j)")
            }
            if j > tLen {
                return i - tLen
            }
            return -1
        }
    }
    nonisolated func str_normal_find_one() {
        let s = ["a","b","a","e","a","d"]
        let t = ["b","a"]
        print(str_normal_find(s: s, sLen: s.count, t: t, tLen: t.count))
        func str_normal_find(s: [String], sLen: Int, t: [String], tLen: Int) -> Int {
            var i = 0
            var j = 0
            while (i < sLen && j < tLen) {
                print("str_normal_find_one \(s[i]) \(t[j])")
                if s[i] == t[j] {
                    i += 1
                    j += 1
                } else {
                    i = i - j + 1
                    j = 0
                }
                print("str_normal_find_one \(i) \(j)")
            }
            if j >= tLen {
                return i - tLen
            }
            return -1
        }
    }
    func get_next(t: [String], tLen: Int)-> [Int] {
        var i = 1
        var j = 0 //游标
        var next: [Int] = []
        next[1] = 0
        while (i < tLen) {
            if t[i] == t[j] {
                i+=1
                j+=1
                next[i] = j
            } else {
                j = next[j]
            }
        }
        return next
    }
}

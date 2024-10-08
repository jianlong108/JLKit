//
//  JLCornerLayer.swift
//  JLKitDemo
//
//  Created by JL on 2024/9/20.
//  Copyright © 2024 JL. All rights reserved.
//

import UIKit

class JLCornerLayer: CAShapeLayer {
    override init() {
        super.init()
    }
    override func layoutSublayers() {
        super.layoutSublayers()
        if self.path == nil {
            let bez = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 6, height: 6))
//            bez.addClip()
            self.path = bez.cgPath
//            self.masksToBounds = true

        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class JLCornerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let layer = self.layer as? JLCornerLayer {
            layer.fillColor = UIColor.blue.withAlphaComponent(0.3).cgColor

        }
        self.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override class var layerClass: AnyClass {
        return JLCornerLayer.self
    }
    
    override var backgroundColor: UIColor? {
        get {
            UIColor.clear
        }
        set {
            if let layer = self.layer as? JLCornerLayer {
                layer.fillColor = newValue?.cgColor
            }
        }
    }
}

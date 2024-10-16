//
//  BlurViewController.swift
//  JLKitDemo
//
//  Created by JL on 2024/9/23.
//  Copyright © 2024 JL. All rights reserved.
//

import UIKit
import SnapKit
import CoreImage


class BlurredView: UIView {
    private var blurLayer: CALayer?
    private var hasBlur: Bool = false
    var blurRadius: CGFloat = 40 {
        didSet {
            blurLayer = nil
            applyGaussianBlur()
        }
    }

    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        bringBlurLayerToFront()
    }

    func setUpBlur() {
        if hasBlur { return }
        applyGaussianBlur()
        bringBlurLayerToFront()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.blurLayer?.frame = self.layer.bounds
    }

    func bringBlurLayerToFront() {
        guard let realLayer = self.blurLayer, let _ = realLayer.superlayer else {
            return
        }
        if let lastLayer = self.layer.sublayers?.last, lastLayer === realLayer {
            return
        }
        realLayer.removeFromSuperlayer()
        self.layer.addSublayer(realLayer)
    }

    private func applyGaussianBlur() {
        if CGRectIsEmpty(bounds) { return }
        let tmpBounds = self.bounds
        let scale = UIScreen.main.scale
        let radious = self.blurRadius

        UIGraphicsBeginImageContextWithOptions(tmpBounds.size, false, 0)
        self.drawHierarchy(in: tmpBounds, afterScreenUpdates: true)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return
        }
        UIGraphicsEndImageContext()

        DispatchQueue.global(qos: .userInitiated).async {
            let ciImage = CIImage(image: image)
            // 创建高斯模糊滤镜
            let blurFilter = CIFilter(name: "CIGaussianBlur")
            blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
            blurFilter?.setValue(radious, forKey: kCIInputRadiusKey)
            guard let outputImage = blurFilter?.outputImage else { return }
            let context = CIContext()
            let outputBounds = ciImage?.extent.insetBy(dx: radious * scale, dy: radious * scale) ?? CGRect.zero
            if let cgImage = context.createCGImage(outputImage, from: outputBounds) {
                DispatchQueue.main.async {
                    if self.blurLayer == nil {
                        let layer = CALayer()
                        layer.backgroundColor = UIColor.systemRed.cgColor
                        layer.frame = tmpBounds
                        layer.contentsGravity = .resizeAspectFill
                        self.layer.addSublayer(layer)
                        layer.contents = cgImage
                        self.hasBlur = true
                        self.blurLayer = layer
                    }
                }
            }
        }


    }
}


class JLVisualEffectView: UIView {
    lazy var visualView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: effect)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(visualView)
        visualView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


@objc(JLBlurViewController)
class BlurViewController: JLBaseViewController {
    //let blurredView = BlurredView(frame: CGRect(x: 0, y: 200, width: 200, height: 200))
    let blurredView = BlurredView()
    let effectiveBlurView = JLVisualEffectView()
    var faceImgView = UIImageView(image: UIImage(named: "face"))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []


        let topImgView = UIImageView(image: UIImage(named: "face"))
//        topImgView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        blurredView.backgroundColor = .red
        view.addSubview(blurredView)
        blurredView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.size.equalTo(CGSizeMake(200, 200))
            make.top.equalToSuperview()
        }
        blurredView.addSubview(topImgView)
        topImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let imgView = UIImageView(image: UIImage(named: "face"))
//        imgView.frame = CGRect(x: 0, y: 400, width: 200, height: 200)
        self.view.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.size.equalTo(CGSizeMake(200, 200))
            make.top.equalTo(topImgView.snp.bottom)
        }

        effectiveBlurView.isHidden = true
        self.view.addSubview(effectiveBlurView)
        effectiveBlurView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.size.equalTo(CGSizeMake(200, 200))
            make.top.equalTo(topImgView.snp.bottom)
        }

        //侦测人脸
//        faceImgView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        self.view.addSubview(faceImgView)
        faceImgView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.size.equalTo(CGSizeMake(200, 200))
        }


        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.orange
        btn.setTitle("高斯模糊", for: .normal)
        btn.addTarget(self, action: #selector(handleBlur(sender:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 100, height: 44))
            make.top.equalTo(faceImgView.snp.bottom).offset(20)
        }

        let addbtn = UIButton(type: .custom)
        addbtn.backgroundColor = UIColor.orange
        addbtn.titleLabel?.adjustsFontSizeToFitWidth = true
        addbtn.setTitle("自定义blur 增加视图", for: .normal)
        addbtn.addTarget(self, action: #selector(handleAddLabel(sender:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(addbtn)
        addbtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 100, height: 44))
            make.top.equalTo(btn.snp.bottom).offset(20)
        }
    }

    func faceDetect() {
        guard let baby = UIImage(named: "face") else {return}
        guard let cgimg = baby.cgImage else {return}
        let scale = 200.0/baby.size.width
        let myimage = CIImage(cgImage: cgimg)
        let context = CIContext(options: nil)
        guard let detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])  else {return}
        let features = detector.features(in: myimage)

        for faceFeature in features {
            var bounds = faceFeature.bounds
            bounds.origin.x *= scale;
            bounds.origin.y = (baby.size.height - bounds.origin.y - bounds.size.height) * scale // 反转 y 坐标
            bounds.size.width *= scale;
            bounds.size.height *= scale;
            let faceView = UIView(frame: bounds)
            faceView.backgroundColor = .clear
            faceView.layer.borderWidth = 1
            faceView.layer.borderColor = UIColor.red.cgColor
            self.faceImgView.addSubview(faceView)
        }
    }
}

extension BlurViewController {
    @objc func handleBlur(sender: UIControl) {
        blurredView.setUpBlur()
        self.faceDetect()
        effectiveBlurView.isHidden = false
    }

    @objc func handleAddLabel(sender: UIControl) {
        let label = UILabel()
        label.backgroundColor = .blue
        label.textColor = .white
        label.text = "8989"
        blurredView.addSubview(label)
        label.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 100))
            make.center.equalToSuperview()
        }

    }
}


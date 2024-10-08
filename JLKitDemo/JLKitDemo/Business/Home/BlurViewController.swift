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
    func setUpBlur() {
        if hasBlur { return }
        applyGaussianBlur()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        applyGaussianBlur()  // 确保在布局时应用模糊
    }
    private func applyGaussianBlur() {
        if CGRectIsEmpty(bounds) { return }
        let tmpBounds = self.bounds
        let scale = UIScreen.main.scale
        let radious = self.blurRadius
        // 截取视图的图像
        UIGraphicsBeginImageContextWithOptions(tmpBounds.size, false, 0)
        self.drawHierarchy(in: tmpBounds, afterScreenUpdates: true)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return
        }
        UIGraphicsEndImageContext()

        // 将图像处理移至后台线程
        DispatchQueue.global(qos: .userInitiated).async {
            // 创建 CIImage
            let ciImage = CIImage(image: image)

            // 创建高斯模糊滤镜
            let blurFilter = CIFilter(name: "CIGaussianBlur")
            blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
            blurFilter?.setValue(radious, forKey: kCIInputRadiusKey)

            // 获取模糊后的图像
            guard let outputImage = blurFilter?.outputImage else { return }

            // 创建 CIContext
            let context = CIContext()

            // 设置输出图像的边界为视图的边界
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


class JLBlurView: UIView {
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
    let blurredView = BlurredView(frame: CGRect(x: 0, y: 200, width: 200, height: 200))
    let blurView = JLBlurView(frame: CGRect(x: 0, y: 400, width: 200, height: 200))
    var faceImgView = UIImageView(image: UIImage(named: "face"))
    override func viewDidLoad() {
        super.viewDidLoad()

        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.orange
        btn.setTitle("高斯模糊", for: .normal)
        btn.addTarget(self, action: #selector(handleBlur(sender:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 100, height: 44))
            make.top.equalToSuperview().offset(164)
        }


        let imgView = UIImageView(image: UIImage(named: "face"))
        imgView.frame = CGRect(x: 0, y: 400, width: 200, height: 200)
        self.view.addSubview(imgView)

        blurView.isHidden = true
        self.view.addSubview(blurView)

        let topImgView = UIImageView(image: UIImage(named: "face"))
        topImgView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        blurredView.addSubview(topImgView)
        blurredView.backgroundColor = .red
        view.addSubview(blurredView)

        //侦测人脸
        faceImgView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        self.view.addSubview(faceImgView)
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
        blurView.isHidden = false
    }
}


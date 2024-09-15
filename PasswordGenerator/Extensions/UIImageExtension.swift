//
//  UIImageExtension.swift
//  PasswordGenerator
//
//  Created by Nicholas Rebello on 2024-08-29.
//

import SwiftUI
import UIKit

struct GIFImageView: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> UIImageView {
        return UIImageView()
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        if let gifData = NSDataAsset(name: gifName)?.data {
            uiView.image = UIImage.animatedImage(withAnimatedGIFData: gifData)
        }
    }
}

extension UIImage {
    class func animatedImage(withAnimatedGIFData data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        var duration: TimeInterval = 0
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
                
                let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as NSDictionary?
                let gifInfo = properties?[kCGImagePropertyGIFDictionary as String] as? NSDictionary
                let delayTime = gifInfo?[kCGImagePropertyGIFUnclampedDelayTime as String] as? NSNumber
                let delay = delayTime?.doubleValue ?? 0.1
                duration += delay
            }
        }
        
        return UIImage.animatedImage(with: images, duration: duration)
    }
}

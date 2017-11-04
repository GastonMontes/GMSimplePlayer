//
//  GMUIImage+Utils.swift
//  GMSimplePlayer
//
//  Created by Gaston Montes on 11/3/17.
//

import Foundation
import UIKit

extension UIImage {
    class func image(name: String) -> UIImage {
        let bundle = Bundle.bundleForPod()
        return UIImage(named: name, in: bundle, compatibleWith: nil)!
    }
    
    class func imageDot(size: Float, color: UIColor) -> UIImage {
        let sizeFloat = CGFloat(size)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: sizeFloat, height: sizeFloat), false, 0)
        
        let graphicsContext = UIGraphicsGetCurrentContext()!
        graphicsContext.saveGState()
        
        let dotRect = CGRect(x: 0, y: 0, width: sizeFloat, height: sizeFloat)
        graphicsContext.setFillColor(color.cgColor)
        graphicsContext.fillEllipse(in: dotRect)
        
        graphicsContext.restoreGState()
        
        let dotImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return dotImage
    }
}

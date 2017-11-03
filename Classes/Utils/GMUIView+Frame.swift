//
//  GMUIView+Frame.swift
//  GMSimplePlayer
//
//  Created by Gaston Montes on 11/3/17.
//

import Foundation
import UIKit

extension UIView {
    // MARK: - Seiz functions.
    func frameHeight() -> CGFloat {
        return self.frame.size.height
    }
    
    func frameWidth() -> CGFloat {
        return self.frame.size.width
    }
    
    func frameSet(height: CGFloat) {
        let newFrame = CGRect(x: self.frameX(), y: self.frameY(), width: self.frameWidth(), height: height)
        self.frame = newFrame
    }
    
    func frameSet(width: CGFloat) {
        let newFrame = CGRect(x: self.frameX(), y: self.frameY(), width: width, height: self.frameHeight())
        self.frame = newFrame
    }
    
    // MARK: - Origin functions.
    func frameX() -> CGFloat {
        return self.frame.origin.x
    }
    
    func frameY() -> CGFloat {
        return self.frame.origin.y
    }
    
    func frameSet(x: CGFloat) {
        let newFrame = CGRect(x: x, y: self.frameY(), width: self.frameWidth(), height: self.frameHeight())
        self.frame = newFrame
    }
    
    func frameSet(y: CGFloat) {
        let newFrame = CGRect(x: self.frameX(), y: y, width: self.frameWidth(), height: self.frameHeight())
        self.frame = newFrame
    }
    
    // MARK: - Combined functions.
    func frameMaxX() -> CGFloat{
        return self.frameX() + self.frameWidth()
    }
    
    func frameMaxY() -> CGFloat {
        return self.frameY() + self.frameHeight()
    }
}

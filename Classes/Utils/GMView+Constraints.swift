//
//  GMView+Constraints.swift
//  GMSimplePlayer
//
//  Created by Gaston Montes on 11/3/17.
//

import Foundation
import UIKit

extension UIView {
    // MARK: - Size constraints.
    func constraintsSizeSameAsSuperview() {
        guard let superview = self.superview else {
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }
    
    func constraintsSize(height: Float) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[self(\(height))]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["self": self]))
    }
    
    func constraintsSize(width: Float) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[self(\(width))]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["self": self]))
    }
    
    // MARK: - Margin constraints.
    func constraintsMarginToSuperView(topMargin: Float, leftMargin: Float, bottomMargin: Float, rightMargin: Float) {
        guard let superview = self.superview else {
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: CGFloat(topMargin)))
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: CGFloat(bottomMargin)))
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1, constant: CGFloat(leftMargin)))
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1, constant: CGFloat(rightMargin)))
    }
    
    func constraintsMarginToSuperView(topMargin: Float) {
        guard let superview = self.superview else {
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: CGFloat(topMargin)))
    }
    
    func constraintsMarginToSuperView(bottomMargin: Float) {
        guard let superview = self.superview else {
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: CGFloat(bottomMargin)))
    }
    
    func constraintsMarginToSuperView(leftMargin: Float) {
        guard let superview = self.superview else {
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1, constant: CGFloat(leftMargin)))
    }
    
    func constraintsMarginToSuperView(rightMargin: Float) {
        guard let superview = self.superview else {
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1, constant: CGFloat(rightMargin)))
    }
    
    // MARK: - Center functions.
    func constraintsCenterXInSuperview()  {
        guard let superview = self.superview else {
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 0))
    }
    
    func constraintsCenterYInSuperview()  {
        guard let superview = self.superview else {
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1, constant: 0))
    }
}

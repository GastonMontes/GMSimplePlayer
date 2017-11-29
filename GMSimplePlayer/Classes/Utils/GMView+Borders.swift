//
//  GMView+Borders.swift
//  GMSimplePlayer
//
//  Created by Gaston Montes on 11/28/17.
//

import Foundation
import UIKit

extension UIView {
    // MARK: - Border functions.
    func borderTop(borderSize: Float, borderColor: UIColor)  {
        let bottomBorderView = UIView(frame: .zero)
        bottomBorderView.backgroundColor = borderColor
        self.addSubview(bottomBorderView)
        
        bottomBorderView.constraintsSize(height: borderSize)
        bottomBorderView.constraintsMarginToSuperView(leftMargin: 0)
        bottomBorderView.constraintsMarginToSuperView(rightMargin: 0)
        bottomBorderView.constraintsMarginToSuperView(topMargin: 0)
    }
    
    func borderBottom(borderSize: Float, borderColor: UIColor)  {
        let bottomBorderView = UIView(frame: .zero)
        bottomBorderView.backgroundColor = borderColor
        self.addSubview(bottomBorderView)
        
        bottomBorderView.constraintsSize(height: borderSize)
        bottomBorderView.constraintsMarginToSuperView(leftMargin: 0)
        bottomBorderView.constraintsMarginToSuperView(rightMargin: 0)
        bottomBorderView.constraintsMarginToSuperView(bottomMargin: 0)
    }
    
    func borderLeft(borderSize: Float, borderColor: UIColor)  {
        let bottomBorderView = UIView(frame: .zero)
        bottomBorderView.backgroundColor = borderColor
        self.addSubview(bottomBorderView)
        
        bottomBorderView.constraintsSize(width: borderSize)
        bottomBorderView.constraintsMarginToSuperView(leftMargin: 0)
        bottomBorderView.constraintsMarginToSuperView(topMargin: 0)
        bottomBorderView.constraintsMarginToSuperView(bottomMargin: 0)
    }
    
    func borderRight(borderSize: Float, borderColor: UIColor)  {
        let bottomBorderView = UIView(frame: .zero)
        bottomBorderView.backgroundColor = borderColor
        self.addSubview(bottomBorderView)
        
        bottomBorderView.constraintsSize(width: borderSize)
        bottomBorderView.constraintsMarginToSuperView(rightMargin: 0)
        bottomBorderView.constraintsMarginToSuperView(topMargin: 0)
        bottomBorderView.constraintsMarginToSuperView(bottomMargin: 0)
    }
    
    func border(withRadius cornerRadius: Float, borderWidth: Float, borderColor: UIColor) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.borderColor = borderColor.cgColor
    }
}

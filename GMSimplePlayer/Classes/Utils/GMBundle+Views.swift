//
//  GMBundle+Views.swift
//  GMSimplePlayer
//
//  Created by Gaston Montes on 11/3/17.
//

import Foundation
import UIKit

extension Bundle {
    class func bundleForPod() -> Bundle {
        return Bundle(for: GMPlayer.self)
    }
    
    func bundleLoadViewFromNib(nibName: String, nibOwner: AnyObject) -> UIView {
        let nib = UINib(nibName: nibName, bundle: self)
        let view = nib.instantiate(withOwner: nibOwner, options: nil).first as! UIView
        return view
    }
}

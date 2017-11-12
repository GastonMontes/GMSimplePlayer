//
//  GMImageView+Utils.swift
//  GMSimplePlayer
//
//  Created by Gaston Montes on 11/12/17.
//

import Foundation
import UIKit

typealias ImageSuccessBlock = (UIImage) -> Void
typealias ImageFailBlock = (Error) -> Void

extension UIImageView {
    func setImage(fromPathOrURL imageNameOrURL: String, success: ImageSuccessBlock?, fail: ImageFailBlock?) {
        if let image = UIImage(named: imageNameOrURL) {
            self.image = image
            success?(image)
        } else {
            self.kf.setImage(with: URL(string: imageNameOrURL),
                                              completionHandler: { (image, error, cacheType, url) in
                                                if error == nil {
                                                    success?(image!)
                                                } else {
                                                    fail?(error!)
                                                }
            })
        }
    }
}

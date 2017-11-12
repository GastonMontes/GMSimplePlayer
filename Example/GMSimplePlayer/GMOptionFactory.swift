//
//  GMOptionFactory.swift
//  GMSimplePlayer_Example
//
//  Created by Gaston Montes on 11/12/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

private let kOptionTypeKey = "OptionType"
private let kOptionTypeVideoURL = "URLVideo"

class GMOptionFactory {
    class func option(dictionary: Dictionary<String, String>) -> GMOption {
        let optionType = dictionary[kOptionTypeKey]!
        
        switch optionType {
        case kOptionTypeVideoURL:
            return GMOptionVideoURL(dictionary: dictionary)
        default:
            return GMOption(dictionary: dictionary)
        }
    }
}

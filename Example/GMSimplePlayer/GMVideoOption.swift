//
//  GMVideoOption.swift
//  GMSimplePlayer_Example
//
//  Created by Gaston Montes on 11/3/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

private let kOptionNameKey = "OptionName"
private let kOptionURLKey = "OptionURL"

class GMVideoOption {
    private(set) var optionName: String
    private(set) var optionURL: String
    
    init(dictionary: Dictionary<String, String>) {
        optionName = dictionary[kOptionNameKey]!
        optionURL = dictionary[kOptionURLKey]!
    }
}

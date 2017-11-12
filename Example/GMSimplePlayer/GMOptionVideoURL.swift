//
//  GMOptionVideoURL.swift
//  GMSimplePlayer_Example
//
//  Created by Gaston Montes on 11/12/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import GMSimplePlayer
import Foundation

private let kOptionURLKey = "OptionURL"

class GMOptionVideoURL: GMOption, GMPlayerItemVideo {    
    // MARK: - Vars.
    private var optionVideoURL: String
    
    // MARK: - Initialization.
    override init(dictionary: Dictionary<String, String>) {
        optionVideoURL = dictionary[kOptionURLKey]!
        
        super.init(dictionary: dictionary)
    }
    
    // MARK: - GMPlayerItemProtocol implementation.
    override func playerItemURL() -> URL {
        return URL(string: self.optionVideoURL)!
    }
}

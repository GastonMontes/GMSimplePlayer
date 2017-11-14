//
//  GMOptionVideoResource.swift
//  GMSimplePlayer_Example
//
//  Created by Gaston Montes on 14/11/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import GMSimplePlayer
import Foundation

private let kVideoNameKey = "OptionFileName"
private let kVideoExtensionKey = "OptionFileExtension"

class GMOptionVideoResource: GMOption, GMPlayerItemVideo {
    // MARK: - Vars.
    private var optionVideoName: String
    private var optionVideoExtension: String
    
    override init(dictionary: Dictionary<String, String>) {
        optionVideoName = dictionary[kVideoNameKey]!
        optionVideoExtension = dictionary[kVideoExtensionKey]!
        
        super.init(dictionary: dictionary)
    }
    
    // MARK: - GMPlayerItemProtocol implementation.
    override func playerItemURL() -> URL {
        let videoPath = Bundle.main.path(forResource: self.optionVideoName, ofType: self.optionVideoExtension)
        return URL(fileURLWithPath: videoPath!)
    }
}

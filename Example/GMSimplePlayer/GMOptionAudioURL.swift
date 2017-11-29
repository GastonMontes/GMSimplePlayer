//
//  GMOptionAudioURL.swift
//  GMSimplePlayer_Example
//
//  Created by Gaston Montes on 11/12/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import GMSimplePlayer
import Foundation

private let kOptionURLKey = "OptionURL"
private let kOptionImageKey = "OptionImage"

class GMOptionAudioURL: GMOption, GMPlayerItemAudio {
    // MARK: - Vars.
    private var optionAudioURL: String
    private var optionAudioImage: String?
    
    // MARK: - Initialization.
    override init(dictionary: Dictionary<String, String>) {
        optionAudioURL = dictionary[kOptionURLKey]!
        optionAudioImage = dictionary[kOptionImageKey]
        
        super.init(dictionary: dictionary)
    }
    
    // MARK: - GMPlayerItemAudio implementation.
    func playerItemImage() -> String? {
        return self.optionAudioImage
    }
    
    func playerTitle() -> String? {
        return "Audio Example"
    }
    
    override func playerItemURL() -> URL {
        return URL(string: self.optionAudioURL)!
    }
}

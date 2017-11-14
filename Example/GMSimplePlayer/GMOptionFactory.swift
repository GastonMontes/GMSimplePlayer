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
private let kOptionTypeAudioURL = "URLAudio"
private let kOptionTypeResourceVideo = "ResourceVideo"

class GMOptionFactory {
    class func option(dictionary: Dictionary<String, String>) -> GMOption {
        let optionType = dictionary[kOptionTypeKey]!
        
        switch optionType {
        case kOptionTypeVideoURL:
            return GMOptionVideoURL(dictionary: dictionary)
        case kOptionTypeAudioURL:
            return GMOptionAudioURL(dictionary: dictionary)
        case kOptionTypeResourceVideo:
            return GMOptionVideoResource(dictionary: dictionary)
        default:
            return GMOption(dictionary: dictionary)
        }
    }
}

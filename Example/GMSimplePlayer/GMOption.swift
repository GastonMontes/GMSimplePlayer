//
//  GMOption.swift
//  GMSimplePlayer_Example
//
//  Created by Gaston Montes on 11/11/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import GMSimplePlayer
import Foundation

private let kOptionNameKey = "OptionName"
private let kOptionAuthorKey = "OptionAuthor"

private let kOptionVideoURL = "URLVideo"
private let kOptionVideoResource = "ResourceVideo"
private let kOptionAudioURL = "URLAudio"
private let kOptionAudioResource = "ResourceAudio"

enum GMOptionType {
    case videoURL
    case videoResource
    case audioURL
    case audioResource
    case unknown
    
    init(option: String!) {
        switch option.lowercased() {
        case kOptionVideoURL:  self = .videoURL
        case kOptionVideoResource:  self = .videoResource
        case kOptionAudioURL:  self = .audioURL
        case kOptionAudioResource:  self = .audioResource
        default:  self = .unknown
        }
    }
}

class GMOption: GMPlayerItemProtocol {
    private var optionName: String
    private var optionAuthor: String
    
    init(dictionary: Dictionary<String, String>) {
        optionName = dictionary[kOptionNameKey]!
        optionAuthor = dictionary[kOptionAuthorKey]!
    }
    
    // MARK: - GMPlayerItemProtocol implementation.
    func playerItemTitle() -> String? {
        return self.optionName
    }
    
    func playerItemAuthor() -> String? {
        return self.optionAuthor
    }
    
    func playerItemURL() -> URL {
        fatalError("Function playerItemURL not implemented in subclass")
    }
}

//
//  GMOption.swift
//  GMSimplePlayer_Example
//
//  Created by Gaston Montes on 11/11/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

private let kOptionNameKey = "OptionName"
private let kOptionAuthorKey = "OptionAuthor"
private let kOptionURLKey = "OptionURL"
private let kOptionTypeKey = "OptionType"

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

class GMOption {
    private(set) var optionName: String
    private(set) var optionAuthor: String
    private(set) var optionURL: String
    private(set) var optionType: GMOptionType
    
    init(dictionary: Dictionary<String, String>) {
        optionName = dictionary[kOptionNameKey]!
        optionAuthor = dictionary[kOptionAuthorKey]!
        optionURL = dictionary[kOptionURLKey]!
        optionType = GMOptionType(option: dictionary[kOptionTypeKey]!)
    }
}

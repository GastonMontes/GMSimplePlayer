//
//  GMPlayerItemProtocols.swift
//  GMSimplePlayer
//
//  Created by Gaston Montes on 11/11/17.
//

import Foundation

public protocol GMPlayerItemProtocol {
    func playerItemTitle() -> String?
    func playerItemAuthor() -> String?
    func playerItemURL() -> URL
}

public protocol GMPlayerItemVideo: GMPlayerItemProtocol {}

public protocol GMPlayerItemAudio: GMPlayerItemProtocol {
    func playerItemImage() -> String?
}

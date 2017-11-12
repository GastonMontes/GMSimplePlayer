//
//  GMPlayerItem.swift
//  GMSimplePlayer
//
//  Created by Gaston Montes on 11/11/17.
//

import Foundation

protocol GMPlayerItem {
    func playerItemURL() -> String
}

protocol GMPlayerItemDescription: GMPlayerItem {
    func playerItemName() -> String
}

protocol GMPlayerItemImage: GMPlayerItem {
    func playerItemImage() -> UIImage?
    func playerItemImageURL() -> String?
}

//
//  GMInt+Random.swift
//  GMSimplePlayer
//
//  Created by Gaston Montes on 11/29/17.
//

import Foundation

extension Int {
    static func random(range: Range<Int>) -> Int {
        var offset = 0
        
        // allow negative ranges
        if range.lowerBound < 0 {
            offset = abs(range.lowerBound)
        }
        
        let mini = UInt32(range.lowerBound + offset)
        let maxi = UInt32(range.upperBound   + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}

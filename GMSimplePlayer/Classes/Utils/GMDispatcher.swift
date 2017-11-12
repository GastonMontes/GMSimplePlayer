//
//  GMDispatcher.swift
//  GMSimplePlayer
//
//  Created by Gaston Montes on 11/3/17.
//

import Foundation

typealias GMDispatchClosure = () -> Void

class GMDispatcher {
    // MARK: - Vars.
    private let dispatchQueue = DispatchQueue.main
    private var dispatchItem: DispatchWorkItem?
    private let dispatchClosure: GMDispatchClosure
    
    // MARK: - Initialization.
    init(closure: @escaping GMDispatchClosure) {
        self.dispatchClosure = closure
    }
    
    // MAK: - Dispatch actions functions.
    func dispatcherDispatch(after: Double) {
        self.dispatchItem = DispatchWorkItem(qos: .default, flags: .inheritQoS, block: { [unowned self] in
            if self.dispatchItem != nil {
                self.dispatchClosure()
            }
        })
        
        self.dispatchQueue.asyncAfter(deadline: .now() + after, execute: self.dispatchItem!)
    }
    
    func dispatcherStop() {
        if self.dispatchItem != nil {
            self.dispatchItem!.cancel()
            self.dispatchItem = nil
        }
    }
}

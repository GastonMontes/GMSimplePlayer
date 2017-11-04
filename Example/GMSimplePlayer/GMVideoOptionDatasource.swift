//
//  GMVideoOptionDatasource.swift
//  GMSimplePlayer_Example
//
//  Created by Gaston Montes on 11/3/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
private let kConfigurationFileNameKey = "GMVideoOptionList"
private let kConfigurationFileExtensionKey = "plist"

class GMVideoOptionDatasource {
    // MARK: - Vars.
    private(set) var datasourceOptions = Array<GMVideoOption>()
    
    // MARK: - Initialization.
    init() {
        fetchDatasourceOptions()
    }
    
    // MARK: - Data fetching.
    private func fetchDatasourceOptions() {
        if let configurationpList = Bundle.main.path(forResource: kConfigurationFileNameKey, ofType: kConfigurationFileExtensionKey) {
            let configurationList = NSArray(contentsOfFile: configurationpList) as! Array<Dictionary<String, String>>
            for dictionary in configurationList {
                self.datasourceOptions.append(GMVideoOption(dictionary: dictionary))
            }
        }
    }
}

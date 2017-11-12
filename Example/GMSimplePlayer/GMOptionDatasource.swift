//
//  GMVideoOptionDatasource.swift
//  GMSimplePlayer_Example
//
//  Created by Gaston Montes on 11/3/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

private let kConfigurationFileNameKey = "GMOptionList"
private let kConfigurationFileExtensionKey = "plist"

class GMOptionDatasource {
    // MARK: - Vars.
    private var datasourceOptions = Array<GMOption>()
    
    // MARK: - Initialization.
    init() {
        fetchDatasourceOptions()
    }
    
    // MARK: - Data fetching.
    private func fetchDatasourceOptions() {
        if let configurationpList = Bundle.main.path(forResource: kConfigurationFileNameKey, ofType: kConfigurationFileExtensionKey) {
            let configurationList = NSArray(contentsOfFile: configurationpList) as! Array<Dictionary<String, String>>
            for dictionary in configurationList {
                self.datasourceOptions.append(GMOptionFactory.option(dictionary: dictionary))
            }
        }
    }
    
    // MARK: Data functions.
    func option(forRow row: Int) -> GMOption {
        return self.datasourceOptions[row]
    }
    
    func optionCount() -> Int {
        return self.datasourceOptions.count
    }
}

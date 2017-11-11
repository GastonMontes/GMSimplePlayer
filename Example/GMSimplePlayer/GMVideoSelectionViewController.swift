//
//  GMVideoSelectionViewController.swift
//  GMSimplePlayer_Example
//
//  Created by Gaston Montes on 11/3/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class GMVideoSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Vars.
    @IBOutlet weak var configurationTableView: UITableView?
    
    private var configurationDatasource: GMVideoOptionDatasource?
    
    // MARk: - View life cycle.
    override func viewDidLoad() {
        self.configurationDatasource = GMVideoOptionDatasource()
    }
    
    // MARK: - UITableViewDataSource implementation.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.configurationDatasource!.datasourceOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
        cell.textLabel?.text = self.configurationDatasource!.datasourceOptions[indexPath.row].optionName
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

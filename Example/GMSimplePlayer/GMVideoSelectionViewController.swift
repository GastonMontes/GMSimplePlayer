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
    
    private var configurationDatasource: GMOptionDatasource?
    
    // MARk: - View life cycle.
    override func viewDidLoad() {
        self.configurationDatasource = GMOptionDatasource()
    }
    
    // MARK: - UITableViewDataSource implementation.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.configurationDatasource!.optionCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = self.configurationDatasource?.option(forRow: indexPath.row)
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
        cell.textLabel?.text = option!.playerItemName()!
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = self.configurationDatasource?.option(forRow: indexPath.row)
        let playerController = GMPlayerViewController(option: selectedOption!)
        self.navigationController?.pushViewController(playerController, animated: true)
    }
}

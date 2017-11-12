//
//  GMPlayerViewController.swift
//  GMSimplePlayer_Example
//
//  Created by Gaston Montes on 11/3/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import GMSimplePlayer
import UIKit

class GMPlayerViewController: UIViewController {
    // MARK: - Vars.
    var playerItemURL: String?
    
    // MARK: - IBOutlets.
    @IBOutlet private var playerView: GMPlayer?
    
    // MARK: - View life cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.playerView?.playerPlay(withURLString: self.playerItemURL!)
    }
}

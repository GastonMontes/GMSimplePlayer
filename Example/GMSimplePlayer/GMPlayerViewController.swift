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
    var playerItem: GMOption
    
    // MARK: - IBOutlets.
    @IBOutlet private var playerView: GMPlayer?
    
    // MARK: - Initialize.
    init(option: GMOption) {
        self.playerItem = option
        
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.playerView?.playerPlay(item: self.playerItem)
    }
}

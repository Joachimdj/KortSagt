//
//  SettingsViewController.swift
//  Alamofire
//
//  Created by Joachim Dittman on 02/05/15.
//  Copyright (c) 2015 Alamofire. All rights reserved.
//

import UIKit



class SettingsViewController: UIViewController {
    @IBOutlet weak var notficationTab: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        
       notficationTab.setOn(true, animated: true)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

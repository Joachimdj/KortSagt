//
//  SettingViewController.swift
//  KortSagt
//
//  Created by Joachim Dittman on 02/05/15.
//  Copyright (c) 2015 Joachim Dittman. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class SettingViewController: UIViewController {
    
    @IBOutlet weak var KortSagtdescription: UITextView!
  
     override func viewDidLoad() {
        super.viewDidLoad()
        
           let defaults = NSUserDefaults.standardUserDefaults()
        let parameters : [ String : String] = [
            "access_token": "535078339963418|0cad57a5c0680b105fdb6a3bb6f71a72"
        ]
        let url = "https://graph.facebook.com/v2.3/kortsagt.nu"
        
        Alamofire.request(.GET, url,encoding: .URLEncodedInURL, parameters:parameters).responseJSON { response in
            
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
       
          
                let about = json["mission"].string
                let description = json["description"].string
                let desc  = "\(about!)\n\n\(description!)"
             
                defaults.setObject(desc, forKey: "description")
             
            self.KortSagtdescription.text = desc
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                
        
            }
        }
        if let description = defaults.stringForKey("description"){
       self.KortSagtdescription.text = description
            }
        
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    @IBAction func button(sender: AnyObject) {
        var url : NSURL
        url = NSURL(string: "http://facebook.dk/kortsagt.nu")!
        UIApplication.sharedApplication().openURL(url)
    }
   
}

//
//  ItemViewController.swift
//  KortSagt
//
//  Created by Joachim on 20/03/15.
//  Copyright (c) 2015 Joachim Dittman. All rights reserved.
//

import UIKit
import Alamofire
import Social

class ItemViewController: UIViewController {

    var isPresented = true
    @IBOutlet weak var TextArea: UITextView!
     
    @IBOutlet weak var webView: UIWebView!
    var videoId = imageId[selectedVideo]
   
    override func viewDidLoad() {
        Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/videos?id=\(videoId)&key=AIzaSyA0T0fCHDyQzKCH0z0xs-i8Vh6DeSMcUuQ&part=snippet", parameters:nil)
            
            .responseJSON { (req, res, dataFromNetworking, error) in
                let json = JSON(dataFromNetworking!)
        
               self.TextArea.text = json["items"][0]["snippet"]["description"].string
                
                
        }

        
        super.viewDidLoad()
        
       var  url1 = NSURL(string: "https://www.youtube.com/embed/\(videoId)?rel=0&autoplay=1&modestbranding=1&autohide=1&showinfo=0&controls=0")
        var request = NSURLRequest(URL: url1!)
        webView.scrollView.bounces = false
        webView.loadRequest(request)
      
        
    }
 
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning() 
    }
    
    @IBAction func close(sender: AnyObject) {
         self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil);
        
    }
    
   
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

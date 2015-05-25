//
//  ItemViewController.swift
//  KortSagt
//
//  Created by Joachim on 20/03/15.
//  Copyright (c) 2015 Joachim Dittman. All rights reserved.
//

import UIKit
import Alamofire

class ItemViewController: UIViewController {
    
    @IBOutlet weak var TextArea: UITextView!
    @IBOutlet weak var webView: UIWebView!
    var videoId = ""
    var animator : ARNModalTransitonAnimator?

   
    override func viewDidLoad() {
        isPresented = true
        if(is_searching == true){  videoId = filteredVideos[selectedVideo].id}
        else
        {   videoId = videos[selectedVideo].id}
        
        Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/videos?id=\(videoId)&key=AIzaSyA0T0fCHDyQzKCH0z0xs-i8Vh6DeSMcUuQ&part=snippet", parameters:nil)
            
            .responseJSON { (req, res, dataFromNetworking, error) in
                let json = JSON(dataFromNetworking!)
                self.TextArea.text =  json["items"][0]["snippet"]["description"].string
            
               self.webView.mediaPlaybackRequiresUserAction = false
                
        }

        
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Luk", style: .Plain, target: self, action: "tapCloseButton")
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
       var  url1 = NSURL(string: "https://www.youtube.com/embed/\(videoId)?autoplay=1&modestbranding=1&autohide=1&showinfo=0&controls=0")
  
       
        var request = NSURLRequest(URL: url1!)
 
     
             let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        if (UIDevice.currentDevice().model.rangeOfString("iPad") != nil) {
            var webViewIpad: UIWebView
            
            webViewIpad = UIWebView(frame: CGRectMake(0.5, 40, screenHeight,screenWidth))
        self.view.addSubview(webViewIpad)
           webViewIpad.loadRequest(request)
        }
        else
        {
            self.view.addSubview(webView)
           webView.loadRequest(request)}
        
        
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning() 
    }
    func tapCloseButton() {
          isPresented = false
        
        if(isPresented == false){
            self.dismissViewControllerAnimated(true, completion: nil)}
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

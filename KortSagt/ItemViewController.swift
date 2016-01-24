
        //
        //  ItemViewController.swift
        //  KortSagt
        //
        //  Created by Joachim on 20/03/15.
        //  Copyright (c) 2015 Joachim Dittman. All rights reserved.
        //
        
        import UIKit
        import Alamofire
        import SwiftyJSON
        
        class ItemViewController: UIViewController {
            
            @IBOutlet weak var TextArea: UITextView!
            @IBOutlet weak var webView: UIWebView!
            var videoId = ""
            
            
            override func viewDidLoad() {
                isPresented = true
                if(is_searching == true){  videoId = filteredVideos[selectedVideo].id}
                else
                {   videoId = videos[selectedVideo].id}
                
                
                let url = "https://www.googleapis.com/youtube/v3/videos?id=\(videoId)&key=AIzaSyA0T0fCHDyQzKCH0z0xs-i8Vh6DeSMcUuQ&part=snippet"

                
                Alamofire.request(.GET, url,encoding: .URLEncodedInURL).responseJSON { response in
                    
                    switch response.result {
                    case .Success(let data):
                        let json = JSON(data)
                        self.TextArea.text =  json["items"][0]["snippet"]["description"].string
                        print(json["items"][0]["snippet"]["description"].string)
                        self.webView.mediaPlaybackRequiresUserAction = false
                        
                        
                    case .Failure(let error):
                        print("Request failed with error: \(error)")
                        
                    }
                    
                    
                    
                    super.viewDidLoad()
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Luk", style: .Plain, target: self, action: "tapCloseButton")
                    self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
                    let  url1 = NSURL(string: "https://www.youtube.com/embed/\(self.videoId)?autoplay=1&modestbranding=1&autohide=1&showinfo=0&controls=0")
                    
                    
                    let request = NSURLRequest(URL: url1!)
                    
                    
                    let screenSize: CGRect = UIScreen.mainScreen().bounds
                    let screenWidth = screenSize.width
                    let screenHeight = screenSize.height
                    
                    if (UIDevice.currentDevice().model.rangeOfString("iPad") != nil) {
                        var webViewIpad: UIWebView
                        
                        webViewIpad = UIWebView(frame: CGRectMake(0.5, 40, screenHeight,screenWidth))
                        self.view.addSubview(webViewIpad)
                        webViewIpad.loadRequest(request)
                            webViewIpad.alpha = 0.0
                        UIView.animateWithDuration(0.5, animations: {
                            webViewIpad.alpha = 1.0
                        })
                    }
                    else
                    {
                        self.webView.alpha = 0.0
                       
                        self.view.addSubview(self.webView)
                        self.webView.loadRequest(request)
                        UIView.animateWithDuration(0.5, animations: {
                            self.webView.alpha = 1.0
                        })
                    }
                }
                
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
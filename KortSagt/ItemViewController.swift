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
    var id = dataVideo[selectedVideo]["id"] as! NSDictionary
    
     var snippet = dataVideo[selectedVideo]["snippet"] as! NSDictionary
    var    desc = "";
    override func viewDidLoad() {
        var videoId = id["videoId"] as! NSString
        super.viewDidLoad()
        
        Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/videos?id=\(videoId)&key=AIzaSyA0T0fCHDyQzKCH0z0xs-i8Vh6DeSMcUuQ&part=snippet", parameters:nil)
            
            .responseJSON { (req, res, dataFromNetworking, error) in
                let json = JSON(dataFromNetworking!)
                self.desc   =    json["items"][0]["snippet"]["localized"]["description"].string!
           
                println(self.desc)
                self.TextArea.text = "\(self.desc)"
        }
    
        // Do any additional setup after loading the view.
        
        
  
        
       
        var url1 = NSURL(string: "https://www.youtube.com/embed/\(videoId)?rel=0&autoplay=1&modestbranding=1&autohide=1&showinfo=0&controls=0")
        var request = NSURLRequest(URL: url1!)
        webView.scrollView.bounces = false
        webView.loadRequest(request)
      
        
    }
    @IBAction func playVideo(sender: AnyObject) {
        
        var url1 = NSURL(string: "https://www.youtube.com/embed/CBKiPMeXit0?start=1")
        var request = NSURLRequest(URL: url1!)
         webView.loadRequest(request)
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(sender: AnyObject) {
         self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil);
        
    }
     
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

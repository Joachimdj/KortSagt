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
    var videoId = imageId[selectedVideo]
   // var desc = imageDesc[selectedVideo]
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
     
       // self.TextArea.text = "\(self.desc)"
       
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

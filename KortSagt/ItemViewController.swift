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

 
    @IBOutlet weak var TextArea: UITextView!
     
    @IBOutlet weak var webView: UIWebView!
    var videoId = imageId[selectedVideo]
    var url1 =  NSURL(string: "")
   // var desc = imageDesc[selectedVideo]
    
    override func viewDidLoad() {
        Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/videos?id=\(videoId)&key=AIzaSyA0T0fCHDyQzKCH0z0xs-i8Vh6DeSMcUuQ&part=snippet", parameters:nil)
            
            .responseJSON { (req, res, dataFromNetworking, error) in
                let json = JSON(dataFromNetworking!)
        
               self.TextArea.text = json["items"][0]["snippet"]["description"].string
                
                
        }

        
        super.viewDidLoad()
     
      
       
        // Do any additional setup after loading the view.
        
        
         url1 = NSURL(string: "https://www.youtube.com/embed/\(videoId)?rel=0&autoplay=1&modestbranding=1&autohide=1&showinfo=0&controls=0")
        var request = NSURLRequest(URL: url1!)
        webView.scrollView.bounces = false
        webView.loadRequest(request)
      
        
    }
 
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(sender: AnyObject) {
         self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil);
        
    }
    @IBAction func share(sender: AnyObject) {
        let data = "https://www.youtube.com/watch?v=\(videoId)"
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            var facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("Endnu en fed Kort sagt talk. Se den her \(data) eller i vores iPhone app i App store")
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Facebook konto", message: "Log venligst ind på Facebook, via din enhed.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
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

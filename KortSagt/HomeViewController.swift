//
//  HomeViewController.swift
//  KortSagt
//
//  Created by Joachim on 20/03/15.
//  Copyright (c) 2015 Joachim Dittman. All rights reserved.
//

import UIKit
import Alamofire
var nextPageToken = "";
var prevPageToken = "";

class HomeViewController: UIViewController {
var isPresented = false
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var place: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageId.removeAll(keepCapacity: true)
        loadNewVideo()
        let parameters : [ String : String] = [
            "access_token": "535078339963418|0cad57a5c0680b105fdb6a3bb6f71a72",
            "fields": "cover,start_time,name,place"
        ]
        Alamofire.request(.GET, "https://graph.facebook.com/v2.3/kortsagt.nu/events", parameters:parameters)
            
            .responseJSON { (req, res, dataFromNetworking, error) in
           
                let json = JSON(dataFromNetworking!)
                
                let imageString = json["data"][0]["cover"]["source"].string
                 var place = json["data"][0]["place"]["name"].string
                 var date1 = json["data"][0]["start_time"].string
                if(date1 != nil){
                    var df = NSDateFormatter()
                    //Wed Dec 01 17:08:03 +0000 2010
                    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
                    var date = df.dateFromString(date1!)
                    df.dateFormat = "dd-MM-yyyy HH:mm"
                    var dateStr = df.stringFromDate(date!)
                    var dateNext = "Næste event"
                    var dateString1 = "\(dateNext) \(dateStr)"
                    
                
                    // Fade out to set the text
                    UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                        self.place.alpha = 0.0
                        self.date.alpha = 0.0
                        }, completion: {
                            (finished: Bool) -> Void in
                            
                            //Once the label is completely invisible, set the text and fade it back in
                            self.place.text = place
                            self.date.text = dateString1
                            
                            // Fade in
                            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                                self.place.alpha = 1.0
                                self.date.alpha = 1.0
                                }, completion: nil)
                    })
                
               // self.place.text = place
               
           
               
                var imageView1 = UIImageView()
                if(imageString != nil){
                ImageLoader.sharedLoader.imageForUrl(imageString!, completionHandler:{(image: UIImage?, url: String) in
                    imageView1.image =   Toucan(image: image!).resize(CGSize(width: 640, height: 360), fitMode: Toucan.Resize.FitMode.Crop).image
                    // Do any additional setup after loading the view.
                })
                }
                }
                
                
        }
       
              //  headerTalkimage.addSubview(imageView1)
     
    }
    
    func loadNewVideo(){
  
        var url = "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=UCBBSZunZagb4bDBi3PSqd7Q&order=date&key=AIzaSyA0T0fCHDyQzKCH0z0xs-i8Vh6DeSMcUuQ&maxResults=50&part=snippet,contentDetails&pageToken=\(nextPageToken)"
        
        Alamofire.request(.GET, url, parameters:nil)
            
            .responseJSON { (req, res, dataFromNetworking, error) in
                if(error != nil) {
                    NSLog("GET Error: \(error)")
                 
                }
                let json = JSON(dataFromNetworking!)
                
                var reponse = json["items"]
                var count = json["items"].count;
                for var i = 0; i <= count; i++
                {   
                    if(json["items"][i]["id"]["videoId"] != nil){
                        imageId.append(json["items"][i]["id"]["videoId"].string!)
                         }  
                     println(" \(i) = \(count)")
                }
                
                //   imageLinks.append(dataVideo)
                if(json["prevPageToken"] != nil){prevPageToken =   json["prevPageToken"].string!  }
                if(json["nextPageToken"] != nil){ nextPageToken = json["nextPageToken"].string!  }
                
                if(json["nextPageToken"].string != nil) {
                    
                    self.loadNewVideo()
               
                   
                } 
        }
        
        
    }

    @IBAction func SupriceMe(sender: AnyObject) {
       
         let random =  randomInt(0,max: imageId.count)
        selectedVideo = random
        let controller = storyboard?.instantiateViewControllerWithIdentifier("item") as! ItemViewController
        presentViewController(controller, animated: true, completion: nil)
    }
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
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

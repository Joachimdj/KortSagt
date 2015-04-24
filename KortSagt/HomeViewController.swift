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

    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var place: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageId.removeAll(keepCapacity: true)
        loadNewVideo()
        Alamofire.request(.GET, "https://graph.facebook.com/v2.3/KortSagt.nu/events?fields=cover,start_time,name,place&access_token=CAACEdEose0cBAA6z5MM802pRA1kOvyIOLsShBhMhCor7d7P0puvlzGJg1V2ha2njMEnkUQvFLoNflR5ptJfmDrFrsmJz79ZCqpZBOKiGuC0AkjZAZCu2SaZAqZBC2mHgzdRO6sJWUxfiyHr8jcfHsWeF8AO2IZB2A56ZCjHJZADZB8rVer4EcMEDZCDpBa60Hk16wUH05ZAFoxTwt0o5TKGv5u3TZBDFHYwUX3AkZD", parameters:nil)
            
            .responseJSON { (req, res, dataFromNetworking, error) in
                let json = JSON(dataFromNetworking!)
                
                let imageString = json["data"][0]["cover"]["source"].string
                 var place = json["data"][0]["place"]["name"].string
                 var date1 = json["data"][0]["start_time"].string
               
                var dateNext = "Næste event"
                self.place.text = place
               
                var df = NSDateFormatter()
                //Wed Dec 01 17:08:03 +0000 2010
                df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
                var date = df.dateFromString(date1!)
                df.dateFormat = "dd-MM-yyyy HH:mm"
                var dateStr = df.stringFromDate(date!)
                
                var dateString1 = "\(dateNext) \(dateStr)"
                self.date.text = dateString1
               
                var imageView1 = UIImageView()
                if(imageString != nil){
                ImageLoader.sharedLoader.imageForUrl(imageString!, completionHandler:{(image: UIImage?, url: String) in
                    imageView1.image =   Toucan(image: image!).resize(CGSize(width: 640, height: 360), fitMode: Toucan.Resize.FitMode.Crop).image
                    // Do any additional setup after loading the view.
                })
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
                    println(res)
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

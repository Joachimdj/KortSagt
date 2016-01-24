//
//  HomeViewController.swift
//  KortSagt
//
//  Created by Joachim on 20/03/15.
//  Copyright (c) 2015 Joachim Dittman. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

var nextPageToken = "";
var prevPageToken = "";
var isPresented = false
class HomeViewController: UIViewController {
 
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var place: UILabel!
    override func viewDidLoad() {
     
        super.viewDidLoad()
        videos.removeAll(keepCapacity: true)
        loadNewVideo()
        let parameters : [ String : String] = [
            "access_token": "535078339963418|0cad57a5c0680b105fdb6a3bb6f71a72",
            "fields": "cover,start_time,name,place"
        ]
        let url = "https://graph.facebook.com/v2.3/kortsagt.nu/events"
        
        Alamofire.request(.GET, url,encoding: .URLEncodedInURL,parameters:parameters).responseJSON { response in
            
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
      
                let imageString = json["data"][0]["cover"]["source"].string
                 let place = json["data"][0]["place"]["name"].string
                 let date1 = json["data"][0]["start_time"].string
                if(date1 != nil){
                    let df = NSDateFormatter()
                    //Wed Dec 01 17:08:03 +0000 2010
                    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
                    let date = df.dateFromString(date1!)
                    df.dateFormat = "dd-MM-yyyy HH:mm"
                    let dateStr = df.stringFromDate(date!)
                    let dateNext = "Næste event"
                    let dateString1 = "\(dateNext) \(dateStr)"
                    let dateNow = NSDate()
                    print(dateNow)
                    print(date)
                    print(date!.compare(dateNow).rawValue)
                    if(date!.compare(dateNow).rawValue == 1){
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
                }
               // self.place.text = place
               
                }
               
                let imageView1 = UIImageView()
                if(imageString != nil){
                ImageLoader.sharedLoader.imageForUrl(imageString!, completionHandler:{(image: UIImage?, url: String) in
                    imageView1.image =   Toucan(image: image!).resize(CGSize(width: 640, height: 360), fitMode: Toucan.Resize.FitMode.Crop).image
                    // Do any additional setup after loading the view.
                })
                }
            case .Failure(let error):
                print("Request failed with error: \(error)")
                
            
                }
                }
                
        }
       
              //  headerTalkimage.addSubview(imageView1)
     
    
    
    func loadNewVideo(){
  
        let url = "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=UCBBSZunZagb4bDBi3PSqd7Q&order=date&key=AIzaSyA0T0fCHDyQzKCH0z0xs-i8Vh6DeSMcUuQ&maxResults=50&part=snippet,contentDetails&pageToken=\(nextPageToken)"
        
        Alamofire.request(.GET, url,encoding: .URLEncodedInURL,parameters:nil).responseJSON { response in
            
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
                    _ = json["items"]
                    let count = json["items"].count;
                    for var i = 0; i <= count; i++
                    {
                        if(json["items"][i]["id"]["videoId"] != nil){
                            videos.append(Video(id:json["items"][i]["id"]["videoId"].string! ,
                                name:json["items"][i]["snippet"]["title"].string!,
                                desc:json["items"][i]["snippet"]["description"].string!))
                        }
                        print(" \(i) = \(count)")
                    }
                    
                    
                    if(json["prevPageToken"] != nil){prevPageToken =   json["prevPageToken"].string!  }
                    if(json["nextPageToken"] != nil){ nextPageToken = json["nextPageToken"].string!  }
                    
                    if(json["nextPageToken"].string != nil) {
                        
                       self.loadNewVideo()
                        
                   
                }
            case .Failure(let error):
                print("Request failed with error: \(error)")
                
                
            
                
        }
        }
        
    }

    func SupriceMe(sender: AnyObject) {
       is_searching = false
        if(videos.count>0){
         let random =  randomInt(0,max: videos.count)
        selectedVideo = random
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let modalVC: ItemViewController = storyboard.instantiateViewControllerWithIdentifier("item") as! ItemViewController
        let navController = UINavigationController(rootViewController: modalVC)
         
        self.presentViewController(navController, animated: true, completion: nil)
        }
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
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> Int {
        
            return Int(UIInterfaceOrientationMask.Portrait.rawValue);
        
        
    }
}

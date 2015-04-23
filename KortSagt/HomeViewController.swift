//
//  HomeViewController.swift
//  KortSagt
//
//  Created by Joachim on 20/03/15.
//  Copyright (c) 2015 Joachim Dittman. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableViewController().loadNewVideo()
        Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/videos?id=AWyGgKc02GA&key=AIzaSyA0T0fCHDyQzKCH0z0xs-i8Vh6DeSMcUuQ&part=snippet", parameters:nil)
            
            .responseJSON { (req, res, dataFromNetworking, error) in
                let json = JSON(dataFromNetworking!)
                let imageString = json["items"][0]["snippet"]["thumbnails"]["high"]["url"].string
                   // println(imageString)
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

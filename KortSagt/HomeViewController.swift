//
//  HomeViewController.swift
//  KortSagt
//
//  Created by Joachim on 20/03/15.
//  Copyright (c) 2015 Joachim Dittman. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
       /* var image = dataVideo[0]["thumbnail"] as NSDictionary
        var imageView1 = UIImageView()
        var imageString = image["hqDefault"] as String
        var url = NSURL(string: imageString)
        ImageLoader.sharedLoader.imageForUrl(imageString, completionHandler:{(image: UIImage?, url: String) in
            imageView1.image =   Toucan(image: image!).resize(CGSize(width: 640, height: 360), fitMode: Toucan.Resize.FitMode.Crop).image
        // Do any additional setup after loading the view.
    })*/
      //  headerTalkimage.addSubview(imageView1)
         
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

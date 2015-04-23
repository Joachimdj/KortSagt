 

import UIKit
import Alamofire
var  dataVideo  = []
 var selectedVideo = 0;
 var imageLinks = [""]
 var imageId = [""]
class TableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    var loading = LoadingView();
    
    
    var refreshCtrl = UIRefreshControl()
    var loadingStatus = false
 
   var nextPageToken = "";
    var prevPageToken = "";
    
   
    @IBOutlet var table: UITableView!
    
   
    
    func loadNewVideo(){
        
     if(self.table != nil){    self.view.addSubview(loading)
        loading.startLoading()
        loading.addStartingOpacity(3.5)}
        var url = "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=UCBBSZunZagb4bDBi3PSqd7Q&order=date&key=AIzaSyA0T0fCHDyQzKCH0z0xs-i8Vh6DeSMcUuQ&maxResults=50&part=snippet,contentDetails&pageToken=\(self.nextPageToken)"
        println(url)
        Alamofire.request(.GET, url, parameters:nil)
            
            .responseJSON { (req, res, dataFromNetworking, error) in
                if(error != nil) {
                    NSLog("GET Error: \(error)")
                    println(res)
                }
                let json = JSON(dataFromNetworking!)
                
                 var reponse = json["items"]
              /*var response = JSON as! NSDictionary
                
               dataVideo = response["items"] as! NSArray
                var snippet = dataVideo["snippet"] as! NSDictionary
               
                var image = snippet["thumbnails"] as! NSDictionary
                var image1 = image["high"] as! NSDictionary
                var image2 = image1["url"] as! NSString
 */
                for var i = 0; i < json["items"].count; i++
                {   if(json["items"][i]["snippet"]["thumbnails"]["high"]["url"] != nil){
                    imageLinks.append(json["items"][i]["snippet"]["thumbnails"]["high"]["url"].string!)}
                    if(json["items"][i]["id"]["videoId"] != nil){
                    imageId.append(json["items"][i]["id"]["videoId"].string!)
                    println(json["items"][i]["id"]["videoId"].string!)}
                    
                }
                
             //   imageLinks.append(dataVideo)
                if(json["prevPageToken"] != nil){ self.prevPageToken =   json["prevPageToken"].string!  }
                if(json["nextPageToken"] != nil){ self.nextPageToken = json["nextPageToken"].string!  }
                
                
                
                if(self.table != nil){ self.table.reloadData()}
                self.loading.removeFromSuperview()
                self.refreshCtrl.endRefreshing()
                
                
                self.loadingStatus == false
               if(json["nextPageToken"].string != nil) {
                   println("loadmore")
                     self.loadNewVideo()
                
                }
  
                println(imageLinks.count)
        }
        
        
     
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
         loading.showAtCenterPointWithSize(CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds)/2), size: 16.0)
        self.view.addSubview(loading)
        loading.startLoading()
        loading.addStartingOpacity(3.5)
        loadNewVideo()
        refreshCtrl.addTarget(self, action: "loadNewVideo", forControlEvents: .ValueChanged)
        tableView?.addSubview(refreshCtrl)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return imageLinks.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! UITableViewCell //1
        
        var imageString = "\(imageLinks[indexPath.row])"
        println("\(imageString)")
     
       
        if(imageString != ""){
        var imageView = UIImageView(frame: CGRectMake(0, -1, cell.frame.width, cell.frame.height))
        println(imageString)
        var url = NSURL(string: imageString)
        ImageLoader.sharedLoader.imageForUrl(imageString, completionHandler:{(image: UIImage?, url: String) in
            imageView.image =   Toucan(image: image!).resize(CGSize(width: 640, height: 360), fitMode: Toucan.Resize.FitMode.Crop).image
            
        })
       // imageView.hnk_setImageFromURL(url!)
        cell.backgroundView = imageView;

        }
     
        return cell
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Hej");
         selectedVideo = indexPath.row
         let controller = storyboard?.instantiateViewControllerWithIdentifier("item") as! ItemViewController
        presentViewController(controller, animated: true, completion: nil)
        
    }
    

}


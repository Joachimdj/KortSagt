
import UIKit
import Alamofire
var  dataVideo  = []
var selectedVideo = 0;
var imageLinks = [""]
var imageId = [""]
class TableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
  
    
    
    var refreshCtrl = UIRefreshControl()
    var loadingStatus = false
    
    var nextPageToken = "";
    var prevPageToken = "";
    var alreadyRunned = false
    var isPresented = false
    
    @IBOutlet var table: UITableView!
    
    
    
    func loadNewVideo1(){
        var imageId = [""]
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
                
              
                if(json["prevPageToken"] != nil){self.prevPageToken =   json["prevPageToken"].string!  }
                if(json["nextPageToken"] != nil){ self.nextPageToken = json["nextPageToken"].string!  }
                
                if(json["nextPageToken"].string != nil) {
                    
                    self.loadNewVideo1()
                    
                    
                }
                if(self.table != nil){self.refreshCtrl.endRefreshing()
                    self.table.reloadData()
                    self.nextPageToken = ""
                }
        }
        
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.refreshCtrl.endRefreshing()
        refreshCtrl.addTarget(self, action: "loadNewVideo1", forControlEvents: .ValueChanged)
        tableView?.addSubview(refreshCtrl)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
          } 
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        return imageId.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! UITableViewCell //1
        
         var idString = "https://i.ytimg.com/vi/\(imageId[indexPath.row])/hqdefault.jpg"
         if(idString != ""){
            var imageView = UIImageView(frame: CGRectMake(0, -1, cell.frame.width, cell.frame.height))
      
            var url = NSURL(string: idString)
            ImageLoader.sharedLoader.imageForUrl(idString, completionHandler:{(image: UIImage?, url: String) in
                imageView.image =   Toucan(image: image!).resize(CGSize(width: 640, height: 360), fitMode: Toucan.Resize.FitMode.Crop).image
                
            }) 
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

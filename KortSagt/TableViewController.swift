 

import UIKit
import Alamofire
var  dataVideo  = []
 var selectedVideo = 0;
class TableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    var loading = LoadingView();
    
    
    var refreshCtrl = UIRefreshControl()
    var loadingStatus = false
    
    @IBOutlet var table: UITableView!
    func loadNewVideo(){
        self.view.addSubview(loading)
        loading.startLoading()
        loading.addStartingOpacity(3.5)
        
        Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=UCBBSZunZagb4bDBi3PSqd7Q&order=date&key=AIzaSyA0T0fCHDyQzKCH0z0xs-i8Vh6DeSMcUuQ&callback=items&maxResults=50", parameters:nil)
            
            .responseJSON { (req, res, JSON, error) in
                if(error != nil) {
                    NSLog("GET Error: \(error)")
                    println(res)
                }
                println(JSON)
               /* var response = JSON as! NSDictionary
               
                var response1 = response["data"] as! NSDictionary
                 dataVideo = response1["items"] as! NSArray
                println(dataVideo[0])
                  var description1 = dataVideo[0]["description"]
                
                self.table.reloadData()
                self.loading.removeFromSuperview()
                self.refreshCtrl.endRefreshing()
                self.loadingStatus == false */
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
        return dataVideo.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! UITableViewCell //1
    
        var image = dataVideo[indexPath.row]["thumbnail"]as! NSDictionary
        
        var imageString = image["hqDefault"] as! String
        
        
        
        var imageView = UIImageView(frame: CGRectMake(0, -1, cell.frame.width, cell.frame.height))
        println(imageString)
        var url = NSURL(string: imageString)
        ImageLoader.sharedLoader.imageForUrl(imageString, completionHandler:{(image: UIImage?, url: String) in
            imageView.image =   Toucan(image: image!).resize(CGSize(width: 640, height: 360), fitMode: Toucan.Resize.FitMode.Crop).image
            
        })
       // imageView.hnk_setImageFromURL(url!)
        cell.backgroundView = imageView;
      
      
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



import UIKit
import Alamofire 
var selectedVideo = 0;
var videos = [Video]()
// filtered search results
var filteredVideos = [Video]()
 var is_searching:Bool!

class TableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
  
    var animator : ARNModalTransitonAnimator?
    var refreshCtrl = UIRefreshControl()
    var loadingStatus = false
    
    var nextPageToken = "";
    var prevPageToken = "";
    var alreadyRunned = false
   
    
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet var table: UITableView!
    
    
    
    func loadNewVideo1(){
        if(nextPageToken == ""){
            videos.removeAll()
            filteredVideos.removeAll()
        }
        var url = "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=UCBBSZunZagb4bDBi3PSqd7Q&order=date&key=AIzaSyA0T0fCHDyQzKCH0z0xs-i8Vh6DeSMcUuQ&maxResults=50&part=snippet,contentDetails&pageToken=\(nextPageToken)"
        
        Alamofire.request(.GET, url, parameters:nil)
            
            .responseJSON { (req, res, dataFromNetworking, error) in
                if(error != nil) {
                    NSLog("GET Error: \(error)")
                    println(res)
                }
                if(dataFromNetworking != nil){
                let json = JSON(dataFromNetworking!)
                
                var reponse = json["items"]
                var count = json["items"].count;
                for var i = 0; i <= count; i++
                {
                    if(json["items"][i]["id"]["videoId"] != nil){
                      videos.append(Video(id:json["items"][i]["id"]["videoId"].string! ,
                            name:json["items"][i]["snippet"]["title"].string!,
                            desc:json["items"][i]["snippet"]["description"].string!))
                        
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
                    is_searching = false
                    self.searchBarSearchButtonClicked(self.search)
                }
        }
        
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var text = self.search.text
        is_searching = false
        isPresented = false
         
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
 
        if is_searching == true{
            return filteredVideos.count
        }else{
            return videos.count  //Currently Giving default Value
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! UITableViewCell //1
        var idString = "" 
         
        if is_searching == true{
         idString = "https://i.ytimg.com/vi/\(filteredVideos[indexPath.row].id)/hqdefault.jpg"
        }
        else
        {idString = "https://i.ytimg.com/vi/\(videos[indexPath.row].id)/hqdefault.jpg"
        }
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
        selectedVideo = indexPath.row
        var storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var modalVC: ItemViewController = storyboard.instantiateViewControllerWithIdentifier("item") as! ItemViewController
        var navController = UINavigationController(rootViewController: modalVC)
        
        //  self.animator = ARNModalTransitonAnimator(modalViewController: navController)
       //
       //   self.animator!.transitionDuration = 0.7
        //  self.animator!.direction = .Bottom
        
        
      //  navController.transitioningDelegate = self.animator!
        self.presentViewController(navController, animated: true, completion: nil)
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar.text.isEmpty{
            is_searching = false
            tableView.reloadData()
        } else {
            println("search text %@ ",searchBar.text as NSString)
            is_searching = true
            filteredVideos.removeAll()
            for var index = 0; index < videos.count; index++
            {
                var currentString = "\(videos[index].name) \(videos[index].desc)"
                if currentString.lowercaseString.rangeOfString(searchText.lowercaseString)  != nil {
                    println(videos[index].name)
                    filteredVideos.append(videos[index])
                    
                }
                
            }
            tableView.reloadData()
        }
    }
   
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        NSLog("The default search bar keyboard search button was tapped: \(searchBar.text).")
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        NSLog("The default search bar cancel button was tapped.")
        searchBar.resignFirstResponder()
    }
   
}

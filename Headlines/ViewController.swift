
import UIKit
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    struct HEADLINES {
        var headlines: [String] = [];
        var type : [String] = []
        var headlineURL : [String] = []
        var headlineDate:[String] = []
    }
    var headlines = HEADLINES()
    var refreshControl = UIRefreshControl()
    let RSS_TO_JSON = "https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q="
    
    // sources is  [imageName,SourceURL]
    let newsSources = [
        "Huffington Post":"http://www.huffingtonpost.com/feeds/news.xml",
        "nytimes":"http://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml",
        "CNN":"http://rss.cnn.com/rss/cnn_topstories.rss",
        "reddit":"http://www.reddit.com/r/news/.rss",
        "Fox News":"http://feeds.foxnews.com/foxnews/latest",
        "APnews":"http://hosted2.ap.org/atom/APDEFAULT/3d281c11a96b4ad082fe88aa0db04305",
        "tmz":"http://www.tmz.com/rss.xml"
        
    ]
    @IBOutlet weak var tableViewObject: UITableView!
   
    @IBAction func settingsButton(sender: AnyObject) {
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("StoryController") as! StoryController
        var next: Void = self.navigationController!.pushViewController(viewController, animated: true)
    }
    
    func getHeadLines(url: String) -> JSON{
        let url = url
        var data = Just.get(RSS_TO_JSON+url)
        if(data.ok){
            return JSON(data.json!)
        }else{
            return JSON("")
        }
    }
    
    func reloadData(newsSource:String,image:String){
        
        var json = getHeadLines(newsSource)
        var currentHeadlines = json["responseData"]["feed"]["entries"]
        var array: [String] = []
        
        for (key, subJson) in currentHeadlines {
            if let title = subJson["title"].string {
                let link = subJson["link"].string
                let date = subJson["publishedDate"].string
                array.append(title)
                 headlines.headlineDate.append(date!)
                headlines.type.append(image)
                headlines.headlineURL.append(link!)
            }
        }
        headlines.headlines += array
    }
    func loadTable(){
        headlines = HEADLINES()
        for (key, subJson) in newsSources {
             reloadData(subJson,image:key)
             //println(key)
        }

        self.refreshControl.endRefreshing()
        self.removeAllOverlays()
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        var viewController = self.storyboard!.instantiateViewControllerWithIdentifier("StoryController") as! StoryController
        var next: Void = self.navigationController!.pushViewController(viewController, animated: true)
        selectedCell.textLabel?.textColor = UIColor(red: 0.7569, green: 0.7569, blue: 0.7569, alpha: 1.0)
        selectedCell.contentView.backgroundColor = UIColor.whiteColor()
        viewController.URL = headlines.headlineURL[indexPath.row]
    }

    @IBAction func reloadButton(sender: AnyObject) {
        let text = "Reloading"
        self.showWaitOverlayWithText(text)
        loadTable()
        tableViewObject.reloadData()
    }
   
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return  headlines.headlines.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "mycell")
        var image : UIImage = UIImage(named:  headlines.type[indexPath.row] )!
        let date =  headlines.headlineDate[indexPath.row]
        var new_date = NSDate(fromString: date, format: .RSS)
        var timeAgo = timeAgoSinceDate(new_date, true)
        
        cell.textLabel!.font = UIFont(name: "Helvetica", size: 14.0)
        cell.textLabel!.adjustsFontSizeToFitWidth = true
        cell.textLabel!.numberOfLines = 3;
        cell.textLabel!.text =  headlines.headlines[indexPath.row]
        cell.imageView!.image = image
        cell.detailTextLabel?.text = timeAgo
        cell.detailTextLabel?.textColor = UIColor(red: 0.7569, green: 0.7569, blue: 0.7569, alpha: 1.0)
        
        return cell
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadTable()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "reloadButton:", forControlEvents: UIControlEvents.ValueChanged)
        tableViewObject.addSubview(refreshControl)
    }
    
    override func viewDidAppear(animated: Bool) {
        var nav = self.navigationController?.navigationBar
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let image = UIImage(named: "newspaper-icon")
        
        nav?.barStyle = UIBarStyle.Black
        nav?.tintColor = UIColor.whiteColor()
        nav?.barTintColor = UIColor(hue: 0/360, saturation: 100/100, brightness: 56/100, alpha: 1.0)
        imageView.contentMode = .ScaleAspectFit
        imageView.image = image
        navigationItem.titleView = imageView
    }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}
extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}

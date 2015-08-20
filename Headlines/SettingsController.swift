

import UIKit
import WebKit
class SettingsController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet var containerView : UIView! = nil
    
    @IBOutlet weak var limitTextCounter: UITextField!
    @IBOutlet weak var webView: UIWebView!
    
    @IBAction func limitCount(sender: UISlider) {
         var currentValue = String(stringInterpolationSegment: round(sender.value / 1))
        limitTextCounter.text = currentValue
    }
    var URL:String!
    override func loadView() {
        super.loadView()
        self.navigationController?.navigationBar.topItem!.title = "Settings"
        //self.webView = WKWebView()
       // webView.delegate = self
       // self.view = self.webView!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       /* URL = "http://www.google.com"
        var url = NSURL(string:URL)
        var req = NSURLRequest(URL:url!)
        self.webView!.loadRequest(req)
*/
        
        
    }
    /*
    func webViewDidStartLoad(webView: UIWebView) {
        println("started load")
        
        self.showWaitOverlay()
        self.navigationController?.navigationBar.topItem!.title = "Loading Article"
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.navigationController?.navigationBar.topItem!.title = ""
        self.removeAllOverlays()
    }
*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


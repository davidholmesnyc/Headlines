

import UIKit
import WebKit
class StoryController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet var containerView : UIView! = nil
   
    @IBOutlet weak var webView: UIWebView!
    
    var URL:String!
    override func loadView() {
        super.loadView()
        
        //self.webView = WKWebView()
        webView.delegate = self
        self.view = self.webView!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = NSURL(string:URL)
        var req = NSURLRequest(URL:url!)
        self.webView!.loadRequest(req)
        
    
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        println("started load")
        
        self.showWaitOverlay()
        //self.navigationController?.navigationBar.topItem!.title = "Loading Article"
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.navigationController?.navigationBar.topItem!.title = ""
         self.removeAllOverlays()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


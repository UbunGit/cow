//
//  WebViewController.swift
//  Cow
//
//  Created by admin on 2021/8/11.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    lazy var webView: WKWebView = {
        let webview = WKWebView()
        return webview
    }()
   
    var url:String = ""{
        didSet{
            reload()
        }
    }
    
    var request:NSURLRequest?{
        guard let turl = URL(string: url) else{
            view.error("URL is nil")
            return nil
        }
        return NSURLRequest.init(url: turl)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.navigationDelegate = self
        webView.uiDelegate = self
    }
    func reload()  {
        guard let trequest = request as URLRequest? else{
            view.error("request is nil")
            return
        }
        webView.load(trequest)
  

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.snp.makeConstraints { snp in
            snp.edges.equalToSuperview()
        }
    }
}
extension WebViewController:WKUIDelegate,WKNavigationDelegate{
    
}

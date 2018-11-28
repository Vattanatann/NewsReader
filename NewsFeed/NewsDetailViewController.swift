//
//  NewsDetailViewController.swift
//  NewsFeed
//
//  Created by Vattana Tann on 11/17/18.
//  Copyright © 2018 Vattana Tann. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    var news: News!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = news.title
        print(news.link)
        let newsUrl = URL(string: news.link.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)
        let myRequest = URLRequest(url: newsUrl!)
        webView.load(myRequest)
        
    }
    

}

//
//  NewsTableViewController.swift
//  NewsFeed
//
//  Created by Vattana Tann on 11/17/18.
//  Copyright © 2018 Vattana Tann. All rights reserved.
//

import UIKit
import SDWebImage

class NewsTableViewController: UITableViewController, XMLParserDelegate {

    var newsList = [News]()
    var xmlElement = ""
    var newsTitle = ""
    var newsAuthor = ""
    var newsUrl = ""
    var newsThumbnailUrl = ""
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load and Register tableView
        let customTableViewNib = UINib(nibName: "NewsTableViewCell", bundle: nil)
        tableView.register(customTableViewNib, forCellReuseIdentifier: "cellReuse")
        
        //XML Parser News Data from URL
        let url = URL(string: "http://km.rfi.fr/general/rss")!
        let parser = XMLParser(contentsOf: url)
        parser?.delegate = self
        parser?.parse()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //Prepare segue to NewsDetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! NewsDetailViewController
        let news = newsList[selectedIndex]
        destinationVC.news = news
    }
    
    //MARK: Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "newsDetailSegue", sender: nil)
    }
    
    //MARK: Table View DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection: ", newsList.count)
        return newsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuse") as! NewsTableViewCell
        
        //Put data into cell
        let newsEvent = newsList[indexPath.row]
        cell.newsTitleLabel.text = newsEvent.title
        cell.newsAuthorLabel.text = newsEvent.author
        cell.newsImageView.sd_setImage(with: URL(string: newsEvent.thumbnail), placeholderImage: UIImage(named: "default"))
        
        return cell
    }
    
    //XML Delegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        print("---didStartElement")
        xmlElement = elementName
        if xmlElement == "item" {
            newsTitle = ""
            newsUrl = ""
            newsAuthor = ""
        }
        if xmlElement == "thumbnail" {
            newsThumbnailUrl = attributeDict["url"]!
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        print("+++foundCharacter")
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if data.count != 0 {
            switch xmlElement {
            case "title": newsTitle += data
            case "link": newsUrl += data
            case "author": newsAuthor += data
                
            default: break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        print("___didEndElement", elementName)
        if elementName == "item" {
            var myNews = News()
            myNews.title = newsTitle
            myNews.thumbnail = newsThumbnailUrl
            myNews.link = newsUrl
            myNews.author = newsAuthor
            
            newsList.append(myNews)
        }
        
    }

}

//
//  HomeViewController.swift
//  Twitter
//
//  Created by Animesh Agrawal on 1/31/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tweetTable: UITableView!
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTable.delegate = self
        tweetTable.dataSource = self
        loadTweets()
        
        
        refreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        self.tweetTable.refreshControl = refreshControl
        
        self.tweetTable.reloadData()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTweets()
    }
    @objc func loadTweets(){
        numberOfTweets = 20
        let timelineURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let timelineParams = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: timelineURL, parameters: timelineParams, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tweetTable.reloadData()
            self.refreshControl.endRefreshing()
        }, failure: { (Error) in
            print("could not get tweets")
        })
    }
    
    
    func loadMoreTweets() {
        let timelineURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets += 20
        let timelinePrams = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: timelineURL, parameters: timelinePrams, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tweetTable.reloadData()
        }, failure: { (Error) in
            print("could not get tweets")
        })
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    
    
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "logedIn")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tweetTable.dequeueReusableCell(withIdentifier: "tweetTableViewCell", for: indexPath) as! tweetTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.userName.text = (user["screen_name"] as! String)
        cell.userTweet.text = tweetArray[indexPath.row]["text"] as? String
        
        let imageURL = URL(string: (user["profile_image_url_https"] as! String))!
        
        cell.userImage.af_setImage(withURL: imageURL)
        
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.setRetweet(tweetArray[indexPath.row]["retweeted"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        let likes = String(describing: tweetArray[indexPath.row]["favorite_count"] as! intmax_t)
        cell.likeCount.text = likes
        
        let retweet = String(describing: tweetArray[indexPath.row]["retweet_count"] as! intmax_t)
        cell.retweetCount.text = retweet
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  tweetTableViewCell.swift
//  Twitter
//
//  Created by Animesh Agrawal on 1/31/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class tweetTableViewCell: UITableViewCell {

    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var userTweet: UILabel!
    @IBOutlet weak var like: UIButton!
    @IBOutlet weak var retweet: UIButton!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    var favorited:Bool = false
    var tweetId:Int = -1
    var retweeted:Bool = false
    
    @IBAction func onRetweet(_ sender: Any) {
        if(!retweeted)
        {
            TwitterAPICaller.client?.retweetTweet(tweetId: tweetId, success: {
            self.setRetweet(true)
        }, failure: { (Error) in
            print("error occored \(Error)")
        })
        }
        else{

            TwitterAPICaller.client?.unretweetTweet(tweetId: tweetId, success: {
                self.setRetweet(false)
            }, failure: { (Error) in
                print("Error occored \(Error)")
            })
        }
    }
    @IBAction func onLike(_ sender: Any) {
        print(tweetId)
        if(favorited){
            //goiung to unfavorite
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(false)
            }, failure: { (Error) in
                print("Error occored \(Error)")
            })
        }
        else{
            //going to favorite
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(true)
            }, failure: { (Error) in
                print("Error occored \(Error)")
            })
        }
    }
    
    func setRetweet(_ isRetweeted:Bool){
        retweeted = isRetweeted
        if(retweeted){
            retweet.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
        }
        else{
            retweet.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
        }
    }
    
    func setFavorite(_ isFavorited:Bool){
        favorited = isFavorited
        if(favorited){
            like.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
        else{
            like.setImage(UIImage(named: "favor-icon-grey"), for: UIControl.State.normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

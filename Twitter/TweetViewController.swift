//
//  TweetViewController.swift
//  Twitter
//
//  Created by Animesh Agrawal on 2/3/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var CharCount: UILabel!
    @IBOutlet weak var UserProfileImage: UIImageView!
    @IBOutlet weak var TweetTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        TweetTextView.delegate = self
        UserProfileImage.layer.masksToBounds = false
        UserProfileImage.layer.cornerRadius = UserProfileImage.frame.height/2
        UserProfileImage.clipsToBounds = true
        TweetTextView.becomeFirstResponder()
        let url = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: [:], success: { (userInfo: [NSDictionary]) in
            let user = userInfo[0]["user"] as! [String:Any]
            let profileImage = URL(string: user["profile_image_url_https"] as! String)
            self.UserProfileImage.af_setImage(withURL: profileImage!)
            
        }, failure: { (Error) in
            print("could not get userInfo")
        })
        // Do any additional setup after loading the view.
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       // Set the max character limit
       let characterLimit = 140

       // Construct what the new text would be if we allowed the user's latest edit
       let newText = NSString(string: TweetTextView.text!).replacingCharacters(in: range, with: text)
    
       // TODO: Update Character Count Label
        var c = characterLimit
        c = c - newText.count
        self.CharCount.text = "\(String(describing: c))"
       // The new text should be allowed? True/False
       return newText.count < characterLimit
    }
    
    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SendTweet(_ sender: Any) {
        if (!TweetTextView.text.isEmpty){
            TwitterAPICaller.client?.postTweet(tweetString: TweetTextView.text, success: {
                print("tweeted")
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print("error posting tweet \(error)")
                self.dismiss(animated: true, completion: nil)
            })
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
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

//
//  ViewController.swift
//  AMXSDK
//
//  Created by Pranjal on 04/30/2021.
//  Copyright (c) 2021 Pranjal. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageLabel.text = "View Loaded \n"
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayFCMToken(notification:)),
                                                   name: Notification.Name("FCMToken"), object: nil)
        
        let token = Messaging.messaging().fcmToken
            print("FCM token: \(token ?? "")")
            // [END log_fcm_reg_token]
            self.messageLabel.text  = self.messageLabel.text!+"Logged FCM token: \(token ?? "") \n"

            // [START log_iid_reg_token]
            Messaging.messaging().token { (token, error) in
              if let error = error {
                print("Error fetching remote FCM registration token: \(error)")
              } else if let token = token {
                print("Remote instance ID token: \(token)")
                self.messageLabel.text  = self.messageLabel.text!+"Remote FCM registration token: \(token) \n"
                Messaging.messaging().subscribe(toTopic: "weather") { error in
                      print("Subscribed to weather topic")
                    self.messageLabel.text  = self.messageLabel.text!+"Subscribed to weather topic"
                }
              }
            }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @objc func displayFCMToken(notification: NSNotification){
        guard let userInfo = notification.userInfo else {return}
        if let fcmToken = userInfo["token"] as? String {
          self.messageLabel.text = self.messageLabel.text!+"Received FCM token: \(fcmToken) \n"
        }
      }
}


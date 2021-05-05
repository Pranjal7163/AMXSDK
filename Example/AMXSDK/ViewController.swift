//
//  ViewController.swift
//  AMXSDK
//
//  Created by Pranjal on 04/30/2021.
//  Copyright (c) 2021 Pranjal. All rights reserved.
//

import UIKit
import Firebase
import AMXSDK

class ViewController: UIViewController {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageLabel.text = "View Loaded \n"
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onSubmitClicked(_ sender: Any) {
        if textField.text != ""{
            let payload = ["Text" : textField.text!]
            let event = Event.init(eventName: "Submit Event Button Clicked", payload: payload)
            AMX.setEvent(event: event)
        }else{
            let alert = UIAlertController(title: "Enter Text", message: "", preferredStyle: .alert)
            self.present(alert, animated: false, completion: {
                let seconds = 4.0
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    alert.dismiss(animated: false, completion: nil)
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @objc func displayFCMToken(notification: NSNotification){
        guard let userInfo = notification.userInfo else {return}
//        if let fcmToken = userInfo["token"] as? String {
//          self.messageLabel.text = self.messageLabel.text!+"Received FCM token: \(fcmToken) \n"
//        }
      }
}



import UIKit
import FirebaseMessaging
import FirebaseDatabase


var stringAMX : String? = nil

public class AMX{
            
    static private  var apiKey : String? = nil
    
    private  var appDelegate : UIApplication? = nil
    
    private var messaging : Messaging?
    
    static private var batteryStatus = "Battery Level: Unknown"
    
    var batteryState: UIDevice.BatteryState {
       return UIDevice.current.batteryState
    }
    
    public init(appDelegate : UIApplication){
        self.appDelegate = appDelegate
        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        updateBatteryStateLabel()
    }
    
    @objc func batteryLevelDidChange() {
       updateBatteryStateLabel()
    }
    func updateBatteryStateLabel() {
       var status = "Unknown"
       switch batteryState {
          case .charging:
          status = "Charging"
          case .unknown:
          status = "Unknown"
          case .unplugged:
          status = "Unplugged"
          case .full:
          status = "Full"
       }
       DispatchQueue.main.async {
            let batteryLevel = UIDevice.current.batteryLevel
            if batteryLevel < 0.0 {
                print(" -1.0 means battery state is UIDeviceBatteryStateUnknown")
                return
            }
        if batteryLevel > 0{
            AMX.batteryStatus = "Battery Level: \(batteryLevel*100) %"
        }else{
            AMX.batteryStatus = "Battery Level: Unknown"
        }
       }
    }
    
    public init(){
        
    }
    
    static public func setTracking(){
        let token = Messaging.messaging().fcmToken
            print("FCM token: \(token ?? "")")
            // [END log_fcm_reg_token]
//            self.messageLabel.text  = self.messageLabel.text!+"Logged FCM token: \(token ?? "") \n"

            // [START log_iid_reg_token]
            Messaging.messaging().token { (token, error) in
              if let error = error {
                print("Error fetching remote FCM registration token: \(error)")
              } else if let token = token {
                print("Remote instance ID token: \(token)")
                Messaging.messaging().subscribe(toTopic: "amx") { error in
                      print("Subscribed to amx topic")
                }
              }
            }
    }
    
    public  func setKey(apiKey : String){
        AMX.apiKey = apiKey
        UserDefaults.standard.set(apiKey, forKey: "apiKey")
        var ref: DatabaseReference!
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        ref = Database.database().reference()
        ref.child("users").child(uuid).observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
          let value = snapshot.value as? NSDictionary
            let isActive = value?["isActive"] as? Bool ?? false
          let events = value?["event"] as? NSArray
          var count = value?["launches"] as? Int ?? 0
            count = count+1
            ref.child("users").child(uuid).setValue(["isActive": isActive , "launches" : count, "battery" : AMX.batteryStatus, "events" : events as Any]) {
              (error:Error?, ref:DatabaseReference) in
              if let error = error {
                print("Data could not be saved: \(error).")
              } else {
                print("Data saved successfully!")
              }
            }

          // ...
          }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    static public func setEvent(event : Event){
        var ref: DatabaseReference!
        let eventList = NSMutableArray()
        ref = Database.database().reference()
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        ref.child("users").child(uuid).observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
          let value = snapshot.value as? NSDictionary
          let events = value?["event"] as? NSArray
            if events != nil{
                for object in (events! as NSArray as! [NSDictionary]){
                    eventList.add(object)
                }
                
            }
            let eventDict = NSMutableDictionary()
            eventDict.setValue(event.eventName, forKey: "eventName")
            eventDict.setValue(event.payload, forKey: "payload")
            eventList.add(eventDict)
            
            ref.child("users/\(uuid)/event").setValue(eventList)
        })
        
        
    }
    
    static public func setNotifier(userInfo: [AnyHashable: Any]){
        print("NOTIFIER NOTIFIED")
        
        
        var ref: DatabaseReference!
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        ref = Database.database().reference()
        ref.child("users").child(uuid).observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
          let value = snapshot.value as? NSDictionary
          var isActive = value?["isActive"] as? Bool ?? false
            let count = value?["launches"] as? Int ?? 0
            isActive = true
            let events = value?["event"] as? NSArray
            ref.child("users").child(uuid).setValue(["isActive": isActive , "launches" : count, "battery" : self.batteryStatus,"events" : events as Any]) {
              (error:Error?, ref:DatabaseReference) in
              if let error = error {
                print("Data could not be saved: \(error).")
              } else {
                print("Data saved successfully!")
              }
            }

          // ...
          }) { (error) in
            print(error.localizedDescription)
        }
//        UserDefaults.standard.set(count+1, forKey: "count")
        if let pingURL = userInfo["ping_url"] as? String{
            UserDefaults.standard.set(pingURL, forKey: "PING")
        }
    }
}

public class Event{
    
    public var eventName : String? = nil
    public var payload : [String : Any]? = nil
    
    public init(eventName : String, payload : [String : Any]) {
        self.eventName = eventName
        self.payload = payload
    }
}

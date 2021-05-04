
import UIKit
import FirebaseCore


var stringAMX : String? = nil

public class AMX{
            
    private  var apiKey : String? = nil
    
    private  var appDelegate : UIApplication? = nil
    
    public init(appDelegate : UIApplication){
        self.appDelegate = appDelegate
    }
    
    public init(){
        
    }
    
    public  func setKey(apiKey : String){
        self.apiKey = apiKey
    }
    
    static public func setNotifier(userInfo: [AnyHashable: Any]){
        print("NOTIFIER NOTIFIED")
        var count = UserDefaults.standard.integer(forKey: "count")
        if count == nil{
            count = 0
        }
        UserDefaults.standard.set(count+1, forKey: "count")
    }
}

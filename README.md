# AMXSDK

[![CI Status](https://img.shields.io/travis/Pranjal/AMXSDK.svg?style=flat)](https://travis-ci.org/Pranjal/AMXSDK)
[![Version](https://img.shields.io/cocoapods/v/AMXSDK.svg?style=flat)](https://cocoapods.org/pods/AMXSDK)
[![License](https://img.shields.io/cocoapods/l/AMXSDK.svg?style=flat)](https://cocoapods.org/pods/AMXSDK)
[![Platform](https://img.shields.io/cocoapods/p/AMXSDK.svg?style=flat)](https://cocoapods.org/pods/AMXSDK)

AMX SDK is a SDK provided to track user activities and user life cycle.

 - Note  : You need to share your firebase server key with us
 - Note : Firebase is included in this project 

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

AMXSDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AMXSDK'
```
## Usage 
Get an api key from us using the [link](https://google.com)

Import the following in `AppDelegate`
```swift
import AMXSDK
import Firebase
import UserNotifications
```


For `didFinishLaunchingWithOptions` method for `AppDelegate`
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    AMX(appDelegate: application).setKey(apiKey: "YOUR_API_KEY_HERE")
    Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
        }
        
        let token = Messaging.messaging().fcmToken
        
        if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self
          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        AMX.setTracking()
}
```

For Firebase methods add these extensions to existing Firebase code if present
```swift
// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    AMX.setNotifier(userInfo: userInfo)
    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.alert, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    AMX.setNotifier(userInfo: userInfo)
    print(userInfo)

    completionHandler()
  }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
  // [START refresh_token]
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")
    
    let dataDict:[String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
  }
  // [END refresh_token]
}
```


For Event Tracking : 
```swift 
let payload = ["ANY KEY" : anyValue]
let event = Event.init(eventName: "EVENT_NAME", payload: payload)
AMX.setEvent(event: event)
```

## Author

Pranjal, pranjal.3vyas@gmail.com

## License

AMXSDK is available under the MIT license. See the LICENSE file for more info.

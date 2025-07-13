import Foundation
import UserNotifications

class NotificationManager {
    
    init() {
        let options: UNAuthorizationOptions = [
            .alert,
            .badge,
            .sound,
            .carPlay,
            .criticalAlert,
            .providesAppNotificationSettings,
            .provisional,
        ]
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: options) { result, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if result {
                    print("Notification access granted")
                } else {
                    print("Notification access denied")
                }
            }
    }
    
    func sendNotification(forMinutes minutes: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Timer Done"
        content.body = "Your \(minutes) minutes are up!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 1,
            repeats: false
        )
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func testNotification() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let content = UNMutableNotificationContent()
            content.title = "Timer Done"
            content.body = "Your 1 minute is up!"
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: 1,
                repeats: false
            )
            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request)
        }
    }
}

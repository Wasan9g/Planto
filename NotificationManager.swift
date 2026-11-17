
import Foundation
import UserNotifications

class NotificationManager {

    static let shared = NotificationManager()

    func scheduleReminder(
        id: String,
        plantName: String,
        wateringDays: String
    ) {

        let days: Int

        switch wateringDays {
        case "Every 2 days":
            days = 2
        case "Every 3 days":
            days = 3
        case "Once a week", "Every week":
            days = 7
        case "Every 10 days":
            days = 10
        case "Every 2 weeks":
            days = 14
        default:
            days = 1
        }

        let content = UNMutableNotificationContent()

        content.title = "Planto 🌱"
        content.body = "Hey! Let's water \(plantName) 💧"
        content.sound = .default

        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: Double(days) * 24 * 60 * 60,
            repeats: true
        

        )

        let request = UNNotificationRequest(
            identifier: "watering-\(id)",
            content: content,
            trigger: trigger
        )

        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(
            options: [.alert, .sound]
        ) { granted, error in

            guard granted else {
                print("Notification permission not granted")
                return
            }

            center.add(request) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }

    func cancelReminder(id: String) {

        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: ["watering-\(id)"]
            )
    }
}

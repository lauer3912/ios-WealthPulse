import UserNotifications

final class NotificationService {
    static let shared = NotificationService()

    private let center = UNUserNotificationCenter.current()

    private init() {}

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    func checkAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }

    func scheduleBudgetAlert(for budget: Budget, message: String) {
        let content = UNMutableNotificationContent()
        content.title = "Budget Alert"
        content.body = "\(budget.category.rawValue): \(message)"
        content.sound = .default
        content.categoryIdentifier = "BUDGET_ALERT"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "budget-\(budget.id.uuidString)", content: content, trigger: trigger)

        center.add(request)
    }

    func scheduleGoalReminder(goal: Goal, message: String) {
        let content = UNMutableNotificationContent()
        content.title = "Goal Progress"
        content.body = "\(goal.name): \(message)"
        content.sound = .default
        content.categoryIdentifier = "GOAL_REMINDER"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "goal-\(goal.id.uuidString)", content: content, trigger: trigger)

        center.add(request)
    }

    func scheduleSubscriptionReminder(expirationDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Subscription Expiring"
        content.body = "Your WealthPulse subscription expires on \(expirationDate.formatted())."
        content.sound = .default
        content.categoryIdentifier = "SUBSCRIPTION_REMINDER"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "subscription-expiry", content: content, trigger: trigger)

        center.add(request)
    }

    func cancelNotification(identifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    func cancelAllNotifications() {
        center.removeAllPendingNotificationRequests()
    }

    func registerCategories() {
        let viewAction = UNNotificationAction(identifier: "VIEW_ACTION", title: "View", options: .foreground)
        let dismissAction = UNNotificationAction(identifier: "DISMISS_ACTION", title: "Dismiss", options: .destructive)

        let budgetCategory = UNNotificationCategory(identifier: "BUDGET_ALERT", actions: [viewAction, dismissAction], intentIdentifiers: [])
        let goalCategory = UNNotificationCategory(identifier: "GOAL_REMINDER", actions: [viewAction, dismissAction], intentIdentifiers: [])
        let subscriptionCategory = UNNotificationCategory(identifier: "SUBSCRIPTION_REMINDER", actions: [viewAction, dismissAction], intentIdentifiers: [])

        center.setNotificationCategories([budgetCategory, goalCategory, subscriptionCategory])
    }
}

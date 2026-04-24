import Foundation
import Combine

final class SettingsViewModel: ObservableObject {
    @Published var settings: AppSettings = AppSettings()
    @Published var subscription: Subscription?
    @Published var isPremium: Bool = false
    @Published var biometricType: String = ""
    @Published var isBiometricAvailable: Bool = false
    @Published var accounts: [Account] = []
    @Published var transactionsCount: Int = 0
    @Published var goalsCount: Int = 0
    @Published var investmentsCount: Int = 0

    private let dataService = DataService.shared
    private let themeService = ThemeService.shared
    private let biometricService = BiometricService.shared

    init() {
        loadData()
    }

    func loadData() {
        settings = dataService.getSettings()
        subscription = WealthData.shared.subscription
        isPremium = SubscriptionService.shared.isPremium
        biometricType = biometricService.biometricTypeString
        isBiometricAvailable = biometricService.isBiometricAvailable
        accounts = dataService.getAccounts()
        transactionsCount = dataService.getTransactions().count
        goalsCount = dataService.getGoals().count
        investmentsCount = dataService.getInvestments().count
    }

    func setTheme(_ theme: AppSettings.AppTheme) {
        themeService.setTheme(theme)
        loadData()
    }

    func setCurrency(_ currency: String, symbol: String) {
        settings.currency = currency
        settings.currencySymbol = symbol
        dataService.updateSettings(settings)
        loadData()
    }

    func toggleBiometric(_ enabled: Bool) {
        if enabled && isBiometricAvailable {
            biometricService.authenticate { [weak self] success, _ in
                if success {
                    self?.settings.biometricEnabled = true
                    self?.dataService.updateSettings(self!.settings)
                    self?.loadData()
                }
            }
        } else {
            settings.biometricEnabled = enabled
            dataService.updateSettings(settings)
            loadData()
        }
    }

    func togglePrivacyMode(_ enabled: Bool) {
        settings.privacyModeEnabled = enabled
        dataService.updateSettings(settings)
        loadData()
    }

    func toggleNotifications(_ enabled: Bool) {
        if enabled {
            NotificationService.shared.requestAuthorization { [weak self] granted in
                if granted {
                    self?.settings.notificationsEnabled = true
                    self?.dataService.updateSettings(self!.settings)
                    self?.loadData()
                }
            }
        } else {
            settings.notificationsEnabled = enabled
            dataService.updateSettings(settings)
            loadData()
        }
    }

    func clearAllData() {
        WealthData.shared.accounts = []
        WealthData.shared.transactions = []
        WealthData.shared.budgets = []
        WealthData.shared.goals = []
        WealthData.shared.investments = []
        WealthData.shared.taxInfos = []
        WealthData.shared.subscription = nil
        WealthData.shared.save()
        loadData()
    }

    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "v\(version) (\(build))"
    }

    var privacyPolicyURL: URL? {
        return URL(string: "https://github.com/lauer3912/ios-WealthPulse/blob/main/docs/PrivacyPolicy.md")
    }

    var termsOfServiceURL: URL? {
        return URL(string: "https://github.com/lauer3912/ios-WealthPulse/blob/main/docs/TermsOfService.md")
    }

    static let supportedCurrencies: [(code: String, symbol: String, name: String)] = [
        ("USD", "$", "US Dollar"),
        ("EUR", "€", "Euro"),
        ("GBP", "£", "British Pound"),
        ("JPY", "¥", "Japanese Yen"),
        ("CAD", "C$", "Canadian Dollar"),
        ("AUD", "A$", "Australian Dollar")
    ]
}

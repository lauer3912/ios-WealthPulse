import UIKit

final class ThemeService {
    static let shared = ThemeService()

    private init() {}

    func applyTheme() {
        let theme = WealthData.shared.settings.theme
        switch theme {
        case .system:
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .forEach { $0.overrideUserInterfaceStyle = .unspecified }
        case .light:
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .forEach { $0.overrideUserInterfaceStyle = .light }
        case .dark:
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .forEach { $0.overrideUserInterfaceStyle = .dark }
        }
    }

    func setTheme(_ theme: AppSettings.AppTheme) {
        WealthData.shared.settings.theme = theme
        WealthData.shared.save()
        applyTheme()
    }
}

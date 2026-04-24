import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        ThemeService.shared.applyTheme()
        NotificationService.shared.registerCategories()

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = createMainTabBarController()
        window?.makeKeyAndVisible()

        if WealthData.shared.settings.biometricEnabled {
            authenticateWithBiometrics()
        }
    }

    private func createMainTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()

        let dashboardVC = DashboardViewController()
        dashboardVC.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "chart.pie"), selectedImage: UIImage(systemName: "chart.pie.fill"))
        let dashboardNav = UINavigationController(rootViewController: dashboardVC)

        let transactionsVC = TransactionsViewController()
        transactionsVC.tabBarItem = UITabBarItem(title: "Transactions", image: UIImage(systemName: "list.bullet.rectangle"), selectedImage: UIImage(systemName: "list.bullet.rectangle.fill"))
        let transactionsNav = UINavigationController(rootViewController: transactionsVC)

        let budgetVC = BudgetViewController()
        budgetVC.tabBarItem = UITabBarItem(title: "Budget", image: UIImage(systemName: "creditcard"), selectedImage: UIImage(systemName: "creditcard.fill"))
        let budgetNav = UINavigationController(rootViewController: budgetVC)

        let goalsVC = GoalsViewController()
        goalsVC.tabBarItem = UITabBarItem(title: "Goals", image: UIImage(systemName: "target"), selectedImage: UIImage(systemName: "target"))
        let goalsNav = UINavigationController(rootViewController: goalsVC)

        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        let settingsNav = UINavigationController(rootViewController: settingsVC)

        tabBarController.viewControllers = [dashboardNav, transactionsNav, budgetNav, goalsNav, settingsNav]

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .systemBackground

        tabBarController.tabBar.standardAppearance = tabBarAppearance
        tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance
        tabBarController.tabBar.tintColor = .primaryGreen

        return tabBarController
    }

    private func authenticateWithBiometrics() {
        BiometricService.shared.authenticate { [weak self] success, error in
            if !success {
                self?.showAuthenticationFailedAlert()
            }
        }
    }

    private func showAuthenticationFailedAlert() {
        let alert = UIAlertController(
            title: "Authentication Required",
            message: "Please authenticate to access WealthPulse",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Try Again", style: .default) { [weak self] _ in
            self?.authenticateWithBiometrics()
        })
        alert.addAction(UIAlertAction(title: "Disable", style: .destructive) { [weak self] _ in
            WealthData.shared.settings.biometricEnabled = false
            WealthData.shared.save()
        })
        window?.rootViewController?.present(alert, animated: true)
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

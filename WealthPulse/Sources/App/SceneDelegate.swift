import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        // MARK: - Tab Bar Setup
        let tabBarController = UITabBarController()

        // Dashboard Tab
        let dashboardVC = DashboardViewController()
        dashboardVC.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "chart.pie"), selectedImage: UIImage(systemName: "chart.pie.fill"))
        let dashboardNav = UINavigationController(rootViewController: dashboardVC)

        // Transactions Tab
        let transactionsVC = TransactionsViewController()
        transactionsVC.tabBarItem = UITabBarItem(title: "Transactions", image: UIImage(systemName: "list.bullet.rectangle"), selectedImage: UIImage(systemName: "list.bullet.rectangle.fill"))
        let transactionsNav = UINavigationController(rootViewController: transactionsVC)

        // Budget Tab
        let budgetVC = BudgetViewController()
        budgetVC.tabBarItem = UITabBarItem(title: "Budget", image: UIImage(systemName: "creditcard"), selectedImage: UIImage(systemName: "creditcard.fill"))
        let budgetNav = UINavigationController(rootViewController: budgetVC)

        // Goals Tab
        let goalsVC = GoalsViewController()
        goalsVC.tabBarItem = UITabBarItem(title: "Goals", image: UIImage(systemName: "target"), selectedImage: UIImage(systemName: "target"))
        let goalsNav = UINavigationController(rootViewController: goalsVC)

        // Settings Tab
        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        let settingsNav = UINavigationController(rootViewController: settingsVC)

        tabBarController.viewControllers = [dashboardNav, transactionsNav, budgetNav, goalsNav, settingsNav]

        // MARK: - Tab Bar Appearance (Light Mode)
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.systemBackground
        tabBarController.tabBar.standardAppearance = tabBarAppearance
        tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance
        tabBarController.tabBar.tintColor = UIColor.systemBlue

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

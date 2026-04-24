import UIKit
import StoreKit

final class SettingsViewController: UIViewController {
    private let viewModel = SettingsViewModel()

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    private enum Section: Int, CaseIterable {
        case account
        case preferences
        case subscription
        case data
        case about
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
        tableView.reloadData()
    }

    private func setupNavigationBar() {
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupUI() {
        view.backgroundColor = .secondaryBackground

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(SwitchCell.self, forCellReuseIdentifier: "SwitchCell")
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .account: return 2
        case .preferences: return 3
        case .subscription: return viewModel.isPremium ? 1 : 2
        case .data: return 3
        case .about: return 2
        case .none: return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section) {
        case .account: return "Account"
        case .preferences: return "Preferences"
        case .subscription: return "Subscription"
        case .data: return "Data"
        case .about: return "About"
        case .none: return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section) {
        case .account:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.textLabel?.text = "Profile"
                cell.accessoryType = .disclosureIndicator
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
                cell.configure(title: viewModel.biometricType, isOn: viewModel.settings.biometricEnabled, icon: viewModel.biometricService.biometricIcon) { [weak self] isOn in
                    self?.viewModel.toggleBiometric(isOn)
                }
                return cell
            }

        case .preferences:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.textLabel?.text = "Theme"
                cell.detailTextLabel?.text = viewModel.settings.theme.rawValue
                cell.accessoryType = .disclosureIndicator
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.textLabel?.text = "Currency"
                cell.detailTextLabel?.text = "\(viewModel.settings.currencySymbol) \(viewModel.settings.currency)"
                cell.accessoryType = .disclosureIndicator
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
                cell.configure(title: "Notifications", isOn: viewModel.settings.notificationsEnabled, icon: "bell") { [weak self] isOn in
                    self?.viewModel.toggleNotifications(isOn)
                }
                return cell
            }

        case .subscription:
            if !viewModel.isPremium && indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.textLabel?.text = "Upgrade to Premium"
                cell.textLabel?.textColor = .primaryGreen
                cell.accessoryType = .disclosureIndicator
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                if let sub = viewModel.subscription {
                    cell.textLabel?.text = "\(sub.tier.displayName) Plan"
                    cell.detailTextLabel?.text = sub.isExpired ? "Expired" : "Active until \(sub.expirationDate.formatted())"
                } else {
                    cell.textLabel?.text = "Free Plan"
                    cell.detailTextLabel?.text = "Basic features"
                }
                cell.accessoryType = .none
                return cell
            }

        case .data:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Export Data"
                cell.accessoryType = .disclosureIndicator
            case 1:
                cell.textLabel?.text = "Clear All Data"
                cell.textLabel?.textColor = .expenseRed
                cell.accessoryType = .none
            case 2:
                cell.textLabel?.text = "Statistics"
                cell.detailTextLabel?.text = "\(viewModel.transactionsCount) transactions, \(viewModel.accounts.count) accounts"
                cell.accessoryType = .none
            default:
                break
            }
            return cell

        case .about:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            if indexPath.row == 0 {
                cell.textLabel?.text = "Version"
                cell.detailTextLabel?.text = viewModel.appVersion
                cell.accessoryType = .none
            } else {
                cell.textLabel?.text = "Privacy Policy"
                cell.accessoryType = .disclosureIndicator
            }
            return cell

        case .none:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch Section(rawValue: indexPath.section) {
        case .account:
            if indexPath.row == 0 {
                showProfile()
            }

        case .preferences:
            if indexPath.row == 0 {
                showThemeSelector()
            } else if indexPath.row == 1 {
                showCurrencySelector()
            }

        case .subscription:
            if !viewModel.isPremium && indexPath.row == 0 {
                showSubscriptionOptions()
            }

        case .data:
            if indexPath.row == 0 {
                exportData()
            } else if indexPath.row == 1 {
                confirmClearData()
            }

        case .about:
            if indexPath.row == 1 {
                openPrivacyPolicy()
            }

        case .none:
            break
        }
    }

    private func showProfile() {
        let alert = UIAlertController(title: "Profile", message: "Profile settings coming soon", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func showThemeSelector() {
        let alert = UIAlertController(title: "Select Theme", message: nil, preferredStyle: .actionSheet)
        for theme in AppSettings.AppTheme.allCases {
            alert.addAction(UIAlertAction(title: theme.rawValue, style: .default) { [weak self] _ in
                self?.viewModel.setTheme(theme)
                self?.tableView.reloadData()
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func showCurrencySelector() {
        let alert = UIAlertController(title: "Select Currency", message: nil, preferredStyle: .actionSheet)
        for currency in SettingsViewModel.supportedCurrencies {
            alert.addAction(UIAlertAction(title: "\(currency.symbol) \(currency.code) - \(currency.name)", style: .default) { [weak self] _ in
                self?.viewModel.setCurrency(currency.code, symbol: currency.symbol)
                self?.tableView.reloadData()
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func showSubscriptionOptions() {
        let alert = UIAlertController(title: "Upgrade to Premium", message: "Unlock all features:\n\n- Investment Tracker\n- Tax Center\n- Unlimited Accounts\n- PDF Export\n\n$2.99/month or $19.99/year", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Monthly - $2.99", style: .default) { [weak self] _ in
            self?.purchaseSubscription(.monthly)
        })
        alert.addAction(UIAlertAction(title: "Yearly - $19.99 (Save 44%)", style: .default) { [weak self] _ in
            self?.purchaseSubscription(.yearly)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func purchaseSubscription(_ period: SubscriptionPeriod) {
        let productId = period == .monthly ? "wealthpulse_premium_monthly" : "wealthpulse_premium_yearly"

        Task {
            if let product = SubscriptionService.shared.getProduct(productId) {
                do {
                    _ = try await SubscriptionService.shared.purchase(product)
                    viewModel.loadData()
                    tableView.reloadData()
                } catch {
                    showAlert("Purchase Failed", message: error.localizedDescription)
                }
            } else {
                showAlert("Error", message: "Product not available")
            }
        }
    }

    private func exportData() {
        showAlert("Export Data", message: "Data export feature coming soon")
    }

    private func confirmClearData() {
        let alert = UIAlertController(title: "Clear All Data", message: "This will permanently delete all your accounts, transactions, budgets, and goals. This action cannot be undone.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Clear All", style: .destructive) { [weak self] _ in
            self?.viewModel.clearAllData()
            self?.tableView.reloadData()
            self?.showAlert("Data Cleared", message: "All data has been deleted")
        })
        present(alert, animated: true)
    }

    private func openPrivacyPolicy() {
        if let url = viewModel.privacyPolicyURL {
            UIApplication.shared.open(url)
        }
    }

    private func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

final class SwitchCell: UITableViewCell {
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let switchControl = UISwitch()
    private var onToggle: ((Bool) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        selectionStyle = .none

        iconView.tintColor = .primaryBlue
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconView)

        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = .primaryText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        switchControl.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        switchControl.onTintColor = .primaryGreen
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(switchControl)

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            switchControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    func configure(title: String, isOn: Bool, icon: String, onToggle: @escaping (Bool) -> Void) {
        titleLabel.text = title
        switchControl.isOn = isOn
        iconView.image = UIImage(systemName: icon)
        self.onToggle = onToggle
    }

    @objc private func switchChanged() {
        onToggle?(switchControl.isOn)
    }
}

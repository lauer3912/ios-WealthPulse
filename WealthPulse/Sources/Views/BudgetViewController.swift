import UIKit

final class BudgetViewController: UIViewController {
    private let viewModel = BudgetViewModel()

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let ruleCard = UIView()
    private let needsBar = UIView()
    private let wantsBar = UIView()
    private let savingsBar = UIView()
    private let needsLabel = UILabel()
    private let wantsLabel = UILabel()
    private let savingsLabel = UILabel()

    private let budgetHeaderLabel = UILabel()
    private let tableView = UITableView()
    private let emptyStateLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
        updateUI()
    }

    private func setupNavigationBar() {
        title = "Budget"
        navigationController?.navigationBar.prefersLargeTitles = true

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBudgetTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    private func setupUI() {
        view.backgroundColor = .secondaryBackground

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        setupRuleCard()
        setupBudgetList()

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }

    private func setupRuleCard() {
        ruleCard.backgroundColor = .cardBackground
        ruleCard.layer.cornerRadius = 16
        ruleCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ruleCard)

        let titleLabel = UILabel()
        titleLabel.text = "50/30/20 Rule"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .primaryText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        ruleCard.addSubview(titleLabel)

        let subtitleLabel = UILabel()
        subtitleLabel.text = "Income: \(viewModel.monthlyIncome.currencyFormatted)"
        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.textColor = .secondaryText
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        ruleCard.addSubview(subtitleLabel)

        let barContainer = UIView()
        barContainer.backgroundColor = .tertiaryBackground
        barContainer.layer.cornerRadius = 8
        barContainer.clipsToBounds = true
        barContainer.translatesAutoresizingMaskIntoConstraints = false
        ruleCard.addSubview(barContainer)

        needsBar.backgroundColor = UIColor(hex: "#007AFF")
        needsBar.layer.cornerRadius = 8
        needsBar.translatesAutoresizingMaskIntoConstraints = false
        barContainer.addSubview(needsBar)

        wantsBar.backgroundColor = UIColor(hex: "#FF9500")
        wantsBar.layer.cornerRadius = 8
        wantsBar.translatesAutoresizingMaskIntoConstraints = false
        barContainer.addSubview(wantsBar)

        savingsBar.backgroundColor = UIColor(hex: "#34C759")
        savingsBar.layer.cornerRadius = 8
        savingsBar.translatesAutoresizingMaskIntoConstraints = false
        barContainer.addSubview(savingsBar)

        needsLabel.text = "Needs 50%"
        needsLabel.font = .systemFont(ofSize: 11, weight: .medium)
        needsLabel.textColor = .secondaryText
        needsLabel.translatesAutoresizingMaskIntoConstraints = false
        ruleCard.addSubview(needsLabel)

        wantsLabel.text = "Wants 30%"
        wantsLabel.font = .systemFont(ofSize: 11, weight: .medium)
        wantsLabel.textColor = .secondaryText
        wantsLabel.textAlignment = .center
        wantsLabel.translatesAutoresizingMaskIntoConstraints = false
        ruleCard.addSubview(wantsLabel)

        savingsLabel.text = "Savings 20%"
        savingsLabel.font = .systemFont(ofSize: 11, weight: .medium)
        savingsLabel.textColor = .secondaryText
        savingsLabel.textAlignment = .right
        savingsLabel.translatesAutoresizingMaskIntoConstraints = false
        ruleCard.addSubview(savingsLabel)

        let needsAmountLabel = UILabel()
        needsAmountLabel.text = viewModel.needsSpent.currencyFormatted
        needsAmountLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        needsAmountLabel.textColor = UIColor(hex: "#007AFF")
        needsAmountLabel.tag = 201
        needsAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        ruleCard.addSubview(needsAmountLabel)

        let wantsAmountLabel = UILabel()
        wantsAmountLabel.text = viewModel.wantsSpent.currencyFormatted
        wantsAmountLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        wantsAmountLabel.textColor = UIColor(hex: "#FF9500")
        wantsAmountLabel.tag = 202
        wantsAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        ruleCard.addSubview(wantsAmountLabel)

        let savingsAmountLabel = UILabel()
        savingsAmountLabel.text = viewModel.savingsActual.currencyFormatted
        savingsAmountLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        savingsAmountLabel.textColor = UIColor(hex: "#34C759")
        savingsAmountLabel.tag = 203
        savingsAmountLabel.textAlignment = .right
        savingsAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        ruleCard.addSubview(savingsAmountLabel)

        NSLayoutConstraint.activate([
            ruleCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            ruleCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ruleCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ruleCard.heightAnchor.constraint(equalToConstant: 180),

            titleLabel.topAnchor.constraint(equalTo: ruleCard.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: ruleCard.leadingAnchor, constant: 16),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: ruleCard.leadingAnchor, constant: 16),

            barContainer.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            barContainer.leadingAnchor.constraint(equalTo: ruleCard.leadingAnchor, constant: 16),
            barContainer.trailingAnchor.constraint(equalTo: ruleCard.trailingAnchor, constant: -16),
            barContainer.heightAnchor.constraint(equalToConstant: 16),

            needsBar.topAnchor.constraint(equalTo: barContainer.topAnchor),
            needsBar.leadingAnchor.constraint(equalTo: barContainer.leadingAnchor),
            needsBar.bottomAnchor.constraint(equalTo: barContainer.bottomAnchor),
            needsBar.widthAnchor.constraint(equalTo: barContainer.widthAnchor, multiplier: 0.5),

            wantsBar.topAnchor.constraint(equalTo: barContainer.topAnchor),
            wantsBar.leadingAnchor.constraint(equalTo: needsBar.trailingAnchor),
            wantsBar.bottomAnchor.constraint(equalTo: barContainer.bottomAnchor),
            wantsBar.widthAnchor.constraint(equalTo: barContainer.widthAnchor, multiplier: 0.3),

            savingsBar.topAnchor.constraint(equalTo: barContainer.topAnchor),
            savingsBar.leadingAnchor.constraint(equalTo: wantsBar.trailingAnchor),
            savingsBar.bottomAnchor.constraint(equalTo: barContainer.bottomAnchor),

            needsLabel.topAnchor.constraint(equalTo: barContainer.bottomAnchor, constant: 8),
            needsLabel.leadingAnchor.constraint(equalTo: ruleCard.leadingAnchor, constant: 16),

            wantsLabel.topAnchor.constraint(equalTo: barContainer.bottomAnchor, constant: 8),
            wantsLabel.centerXAnchor.constraint(equalTo: ruleCard.centerXAnchor),

            savingsLabel.topAnchor.constraint(equalTo: barContainer.bottomAnchor, constant: 8),
            savingsLabel.trailingAnchor.constraint(equalTo: ruleCard.trailingAnchor, constant: -16),

            needsAmountLabel.topAnchor.constraint(equalTo: needsLabel.bottomAnchor, constant: 4),
            needsAmountLabel.leadingAnchor.constraint(equalTo: ruleCard.leadingAnchor, constant: 16),

            wantsAmountLabel.topAnchor.constraint(equalTo: wantsLabel.bottomAnchor, constant: 4),
            wantsAmountLabel.centerXAnchor.constraint(equalTo: ruleCard.centerXAnchor),

            savingsAmountLabel.topAnchor.constraint(equalTo: savingsLabel.bottomAnchor, constant: 4),
            savingsAmountLabel.trailingAnchor.constraint(equalTo: ruleCard.trailingAnchor, constant: -16),
        ])
    }

    private func setupBudgetList() {
        budgetHeaderLabel.text = "Category Budgets"
        budgetHeaderLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        budgetHeaderLabel.textColor = .primaryText
        budgetHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(budgetHeaderLabel)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BudgetCell.self, forCellReuseIdentifier: BudgetCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tableView)

        emptyStateLabel.text = "No budgets set.\nTap + to create a budget."
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.font = .systemFont(ofSize: 16)
        emptyStateLabel.textColor = .secondaryText
        emptyStateLabel.isHidden = true
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emptyStateLabel)

        NSLayoutConstraint.activate([
            budgetHeaderLabel.topAnchor.constraint(equalTo: ruleCard.bottomAnchor, constant: 24),
            budgetHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            tableView.topAnchor.constraint(equalTo: budgetHeaderLabel.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 400),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100),

            emptyStateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
        ])
    }

    private func updateUI() {
        tableView.reloadData()

        let isEmpty = viewModel.budgets.isEmpty
        emptyStateLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty

        if let needsAmountLabel = ruleCard.viewWithTag(201) as? UILabel {
            needsAmountLabel.text = viewModel.needsSpent.currencyFormatted
        }
        if let wantsAmountLabel = ruleCard.viewWithTag(202) as? UILabel {
            wantsAmountLabel.text = viewModel.wantsSpent.currencyFormatted
        }
        if let savingsAmountLabel = ruleCard.viewWithTag(203) as? UILabel {
            savingsAmountLabel.text = viewModel.savingsActual.currencyFormatted
        }
    }

    @objc private func addBudgetTapped() {
        let alert = UIAlertController(title: "Add Budget", message: "Select a category", preferredStyle: .actionSheet)

        let expenseCategories: [TransactionCategory] = [.food, .transport, .shopping, .entertainment, .bills, .health, .housing, .education, .travel, .subscription, .otherExpense]
        for category in expenseCategories {
            if !viewModel.budgets.contains(where: { $0.category == category }) {
                alert.addAction(UIAlertAction(title: "\(category.icon) \(category.rawValue)", style: .default) { [weak self] _ in
                    self?.showAmountAlert(for: category)
                })
            }
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func showAmountAlert(for category: TransactionCategory) {
        let alert = UIAlertController(title: "Monthly Limit for \(category.rawValue)", message: "Enter your monthly budget limit", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Amount"
            textField.keyboardType = .decimalPad
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let text = alert.textFields?.first?.text, let amount = Double(text) else { return }
            self?.viewModel.addBudget(category: category, monthlyLimit: amount)
            self?.updateUI()
        })
        present(alert, animated: true)
    }
}

extension BudgetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.budgets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BudgetCell.identifier, for: indexPath) as! BudgetCell
        let budget = viewModel.budgets[indexPath.row]
        cell.configure(with: budget)
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            guard let self = self else { return }
            let budget = self.viewModel.budgets[indexPath.row]
            self.viewModel.deleteBudget(budget)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.updateUI()
            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
}

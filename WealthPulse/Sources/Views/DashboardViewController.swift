import UIKit

final class DashboardViewController: UIViewController {
    private let viewModel = DashboardViewModel()

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let wealthScoreCard = UIView()
    private let scoreLabel = UILabel()
    private let scoreMessageLabel = UILabel()
    private let progressRing = CAShapeLayer()

    private let netWorthCard = UIView()
    private let netWorthTitleLabel = UILabel()
    private let netWorthValueLabel = UILabel()

    private let statsStackView = UIStackView()
    private let incomeCard = UIView()
    private let expenseCard = UIView()
    private let savingsCard = UIView()

    private let recentTransactionsLabel = UILabel()
    private let seeAllButton = UIButton(type: .system)
    private let transactionsStackView = UIStackView()

    private let addButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refresh()
        updateUI()
    }

    private func setupNavigationBar() {
        title = "Dashboard"
        navigationController?.navigationBar.prefersLargeTitles = true

        let profileButton = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(profileTapped))
        navigationItem.rightBarButtonItem = profileButton
    }

    private func setupUI() {
        view.backgroundColor = .secondaryBackground

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        setupWealthScoreCard()
        setupStatsCards()
        setupRecentTransactions()

        addButton.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)), for: .normal)
        addButton.backgroundColor = .primaryGreen
        addButton.tintColor = .white
        addButton.layer.cornerRadius = 28
        addButton.addTarget(self, action: #selector(addTransactionTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)

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

            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.widthAnchor.constraint(equalToConstant: 56),
            addButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }

    private func setupWealthScoreCard() {
        wealthScoreCard.backgroundColor = .cardBackground
        wealthScoreCard.layer.cornerRadius = 16
        wealthScoreCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(wealthScoreCard)

        let titleLabel = UILabel()
        titleLabel.text = "Wealth Health Score"
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .secondaryText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        wealthScoreCard.addSubview(titleLabel)

        scoreLabel.font = .systemFont(ofSize: 48, weight: .bold)
        scoreLabel.textColor = .primaryGreen
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        wealthScoreCard.addSubview(scoreLabel)

        scoreMessageLabel.font = .systemFont(ofSize: 16, weight: .medium)
        scoreMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        wealthScoreCard.addSubview(scoreMessageLabel)

        let scoreRingContainer = UIView()
        scoreRingContainer.translatesAutoresizingMaskIntoConstraints = false
        wealthScoreCard.addSubview(scoreRingContainer)

        let circularPath = UIBezierPath(arcCenter: CGPoint(x: 40, y: 40), radius: 35, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)
        progressRing.path = circularPath.cgPath
        progressRing.strokeColor = UIColor.primaryGreen.cgColor
        progressRing.fillColor = UIColor.clear.cgColor
        progressRing.lineWidth = 6
        progressRing.lineCap = .round
        progressRing.strokeEnd = 0
        scoreRingContainer.layer.addSublayer(progressRing)

        NSLayoutConstraint.activate([
            wealthScoreCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            wealthScoreCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            wealthScoreCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            wealthScoreCard.heightAnchor.constraint(equalToConstant: 140),

            titleLabel.topAnchor.constraint(equalTo: wealthScoreCard.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: wealthScoreCard.leadingAnchor, constant: 16),

            scoreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            scoreLabel.leadingAnchor.constraint(equalTo: wealthScoreCard.leadingAnchor, constant: 16),

            scoreMessageLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 4),
            scoreMessageLabel.leadingAnchor.constraint(equalTo: wealthScoreCard.leadingAnchor, constant: 16),

            scoreRingContainer.trailingAnchor.constraint(equalTo: wealthScoreCard.trailingAnchor, constant: -16),
            scoreRingContainer.centerYAnchor.constraint(equalTo: wealthScoreCard.centerYAnchor),
            scoreRingContainer.widthAnchor.constraint(equalToConstant: 80),
            scoreRingContainer.heightAnchor.constraint(equalToConstant: 80),
        ])
    }

    private func setupStatsCards() {
        statsStackView.axis = .horizontal
        statsStackView.distribution = .fillEqually
        statsStackView.spacing = 12
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statsStackView)

        incomeCard.backgroundColor = .cardBackground
        incomeCard.layer.cornerRadius = 12
        incomeCard = createStatCard(title: "Income", value: "+\(viewModel.monthlyIncome.currencyFormatted)", color: .incomeGreen)

        expenseCard.backgroundColor = .cardBackground
        expenseCard.layer.cornerRadius = 12
        expenseCard = createStatCard(title: "Expenses", value: "-\(viewModel.monthlyExpenses.currencyFormatted)", color: .expenseRed)

        savingsCard.backgroundColor = .cardBackground
        savingsCard.layer.cornerRadius = 12
        savingsCard = createStatCard(title: "Savings", value: viewModel.monthlySavings.currencyFormatted, color: .primaryBlue)

        statsStackView.addArrangedSubview(incomeCard)
        statsStackView.addArrangedSubview(expenseCard)
        statsStackView.addArrangedSubview(savingsCard)

        NSLayoutConstraint.activate([
            statsStackView.topAnchor.constraint(equalTo: wealthScoreCard.bottomAnchor, constant: 12),
            statsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            statsStackView.heightAnchor.constraint(equalToConstant: 90),
        ])
    }

    private func createStatCard(title: String, value: String, color: UIColor) -> UIView {
        let card = UIView()
        card.backgroundColor = .cardBackground
        card.layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .secondaryText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 16, weight: .bold)
        valueLabel.textColor = color
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),

            valueLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
            valueLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            valueLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
        ])

        return card
    }

    private func setupRecentTransactions() {
        recentTransactionsLabel.text = "Recent Transactions"
        recentTransactionsLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        recentTransactionsLabel.textColor = .primaryText
        recentTransactionsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(recentTransactionsLabel)

        seeAllButton.setTitle("See All", for: .normal)
        seeAllButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        seeAllButton.addTarget(self, action: #selector(seeAllTransactionsTapped), for: .touchUpInside)
        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(seeAllButton)

        transactionsStackView.axis = .vertical
        transactionsStackView.spacing = 8
        transactionsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(transactionsStackView)

        NSLayoutConstraint.activate([
            recentTransactionsLabel.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: 24),
            recentTransactionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            seeAllButton.centerYAnchor.constraint(equalTo: recentTransactionsLabel.centerYAnchor),
            seeAllButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            transactionsStackView.topAnchor.constraint(equalTo: recentTransactionsLabel.bottomAnchor, constant: 12),
            transactionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            transactionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            transactionsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100),
        ])
    }

    private func updateUI() {
        scoreLabel.text = "\(viewModel.wealthScore)"
        scoreMessageLabel.text = viewModel.wealthScoreMessage
        scoreMessageLabel.textColor = UIColor(hex: viewModel.wealthScoreColor)
        progressRing.strokeColor = UIColor(hex: viewModel.wealthScoreColor).cgColor

        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        progressRing.strokeEnd = CGFloat(viewModel.wealthScore) / 100.0
        CATransaction.commit()

        updateStatCard(incomeCard, title: "Income", value: "+\(viewModel.monthlyIncome.currencyFormatted)", color: .incomeGreen)
        updateStatCard(expenseCard, title: "Expenses", value: "-\(viewModel.monthlyExpenses.currencyFormatted)", color: .expenseRed)
        updateStatCard(savingsCard, title: "Savings", value: viewModel.monthlySavings.currencyFormatted, color: viewModel.monthlySavings >= 0 ? .primaryBlue : .expenseRed)

        transactionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if viewModel.recentTransactions.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "No transactions yet"
            emptyLabel.font = .systemFont(ofSize: 14)
            emptyLabel.textColor = .secondaryText
            emptyLabel.textAlignment = .center
            transactionsStackView.addArrangedSubview(emptyLabel)
        } else {
            for transaction in viewModel.recentTransactions {
                let transactionView = createTransactionRow(transaction)
                transactionsStackView.addArrangedSubview(transactionView)
            }
        }
    }

    private func updateStatCard(_ card: UIView, title: String, value: String, color: UIColor) {
        card.subviews.forEach { if $0 is UILabel && $0.tag != 100 { $0.removeFromSuperview() } }

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .secondaryText
        titleLabel.tag = 101
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 16, weight: .bold)
        valueLabel.textColor = color
        valueLabel.tag = 102
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),

            valueLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
            valueLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            valueLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
        ])
    }

    private func createTransactionRow(_ transaction: Transaction) -> UIView {
        let container = UIView()
        container.backgroundColor = .cardBackground
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false

        let iconLabel = UILabel()
        iconLabel.text = transaction.category.icon
        iconLabel.font = .systemFont(ofSize: 16)
        iconLabel.textColor = UIColor(hex: transaction.category.color)
        iconLabel.backgroundColor = UIColor(hex: transaction.category.color).withAlphaComponent(0.15)
        iconLabel.layer.cornerRadius = 18
        iconLabel.clipsToBounds = true
        iconLabel.textAlignment = .center
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(iconLabel)

        let categoryLabel = UILabel()
        categoryLabel.text = transaction.category.rawValue
        categoryLabel.font = .systemFont(ofSize: 14, weight: .medium)
        categoryLabel.textColor = .primaryText
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(categoryLabel)

        let dateLabel = UILabel()
        dateLabel.text = transaction.date.isToday ? "Today" : transaction.date.formatted()
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .secondaryText
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(dateLabel)

        let amountLabel = UILabel()
        if transaction.type == .income {
            amountLabel.text = "+\(transaction.amount.currencyFormatted)"
            amountLabel.textColor = .incomeGreen
        } else {
            amountLabel.text = "-\(transaction.amount.currencyFormatted)"
            amountLabel.textColor = .expenseRed
        }
        amountLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        amountLabel.textAlignment = .right
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(amountLabel)

        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 60),

            iconLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            iconLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconLabel.widthAnchor.constraint(equalToConstant: 36),
            iconLabel.heightAnchor.constraint(equalToConstant: 36),

            categoryLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            categoryLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 12),

            dateLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 2),
            dateLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 12),

            amountLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
        ])

        return container
    }

    @objc private func addTransactionTapped() {
        let addVC = AddTransactionViewController()
        let nav = UINavigationController(rootViewController: addVC)
        present(nav, animated: true)
    }

    @objc private func profileTapped() {
        tabBarController?.selectedIndex = 4
    }

    @objc private func seeAllTransactionsTapped() {
        tabBarController?.selectedIndex = 1
    }
}

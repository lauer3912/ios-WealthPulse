import UIKit

final class TransactionsViewController: UIViewController {
    private let viewModel = TransactionsViewModel()

    private let segmentedControl = UISegmentedControl(items: ["All", "Income", "Expense"])
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let emptyStateLabel = UILabel()
    private let summaryView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
        tableView.reloadData()
        updateUI()
    }

    private func setupNavigationBar() {
        title = "Transactions"
        navigationController?.navigationBar.prefersLargeTitles = true

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTransactionTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    private func setupUI() {
        view.backgroundColor = .secondaryBackground

        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)

        searchBar.placeholder = "Search transactions..."
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)

        summaryView.backgroundColor = .cardBackground
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(summaryView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        emptyStateLabel.text = "No transactions yet.\nTap + to add your first transaction."
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.font = .systemFont(ofSize: 16)
        emptyStateLabel.textColor = .secondaryText
        emptyStateLabel.isHidden = true
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyStateLabel)

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            searchBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            summaryView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            summaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            summaryView.heightAnchor.constraint(equalToConstant: 60),

            tableView.topAnchor.constraint(equalTo: summaryView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyStateLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
        ])
    }

    private func updateUI() {
        summaryView.subviews.forEach { $0.removeFromSuperview() }

        let incomeLabel = UILabel()
        incomeLabel.text = "Income: \(viewModel.totalIncome.currencyFormatted)"
        incomeLabel.font = .systemFont(ofSize: 13, weight: .medium)
        incomeLabel.textColor = .incomeGreen
        incomeLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryView.addSubview(incomeLabel)

        let expenseLabel = UILabel()
        expenseLabel.text = "Expense: \(viewModel.totalExpense.currencyFormatted)"
        expenseLabel.font = .systemFont(ofSize: 13, weight: .medium)
        expenseLabel.textColor = .expenseRed
        expenseLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryView.addSubview(expenseLabel)

        let netLabel = UILabel()
        netLabel.text = "Net: \(viewModel.netAmount.currencyFormatted)"
        netLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        netLabel.textColor = viewModel.netAmount >= 0 ? .incomeGreen : .expenseRed
        netLabel.textAlignment = .right
        netLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryView.addSubview(netLabel)

        NSLayoutConstraint.activate([
            incomeLabel.centerYAnchor.constraint(equalTo: summaryView.centerYAnchor),
            incomeLabel.leadingAnchor.constraint(equalTo: summaryView.leadingAnchor, constant: 16),

            expenseLabel.centerYAnchor.constraint(equalTo: summaryView.centerYAnchor),
            expenseLabel.leadingAnchor.constraint(equalTo: incomeLabel.trailingAnchor, constant: 20),

            netLabel.centerYAnchor.constraint(equalTo: summaryView.centerYAnchor),
            netLabel.trailingAnchor.constraint(equalTo: summaryView.trailingAnchor, constant: -16),
        ])

        let isEmpty = viewModel.groupedTransactions.isEmpty
        emptyStateLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }

    @objc private func filterChanged() {
        let filters: [TransactionFilter] = [.all, .income, .expense]
        viewModel.selectedFilter = filters[segmentedControl.selectedSegmentIndex]
        viewModel.applyFilter()
        tableView.reloadData()
        updateUI()
    }

    @objc private func addTransactionTapped() {
        let addVC = AddTransactionViewController()
        let nav = UINavigationController(rootViewController: addVC)
        present(nav, animated: true)
    }
}

extension TransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.groupedTransactions.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groupedTransactions[section].transactions.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = viewModel.groupedTransactions[section].date
        if date.isToday {
            return "Today"
        } else if date.isYesterday {
            return "Yesterday"
        } else {
            return date.formatted()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.identifier, for: indexPath) as! TransactionCell
        let transaction = viewModel.groupedTransactions[indexPath.section].transactions[indexPath.row]
        cell.configure(with: transaction)
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.viewModel.deleteTransaction(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self?.updateUI()
            completion(true)
        }
        deleteAction.backgroundColor = .expenseRed

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
}

extension TransactionsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
        viewModel.applyFilter()
        tableView.reloadData()
        updateUI()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

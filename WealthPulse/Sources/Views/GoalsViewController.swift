import UIKit

final class GoalsViewController: UIViewController {
    private let viewModel = GoalsViewModel()

    private let collectionView: UICollectionView
    private let summaryView = UIView()
    private let emptyStateLabel = UILabel()

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
        collectionView.reloadData()
        updateUI()
    }

    private func setupNavigationBar() {
        title = "Goals"
        navigationController?.navigationBar.prefersLargeTitles = true

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGoalTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    private func setupUI() {
        view.backgroundColor = .secondaryBackground

        setupSummaryView()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GoalCell.self, forCellWithReuseIdentifier: GoalCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 100, right: 16)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        emptyStateLabel.text = "No goals yet.\nTap + to start saving for something!"
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.font = .systemFont(ofSize: 16)
        emptyStateLabel.textColor = .secondaryText
        emptyStateLabel.isHidden = true
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyStateLabel)

        NSLayoutConstraint.activate([
            summaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            summaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            summaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            summaryView.heightAnchor.constraint(equalToConstant: 80),

            collectionView.topAnchor.constraint(equalTo: summaryView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyStateLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
        ])
    }

    private func setupSummaryView() {
        summaryView.backgroundColor = .cardBackground
        summaryView.layer.cornerRadius = 16
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(summaryView)

        let totalLabel = UILabel()
        totalLabel.text = "Total Savings"
        totalLabel.font = .systemFont(ofSize: 12, weight: .medium)
        totalLabel.textColor = .secondaryText
        totalLabel.tag = 101
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryView.addSubview(totalLabel)

        let totalAmountLabel = UILabel()
        totalAmountLabel.text = viewModel.totalCurrentAmount.currencyFormatted
        totalAmountLabel.font = .systemFont(ofSize: 24, weight: .bold)
        totalAmountLabel.textColor = .primaryGreen
        totalAmountLabel.tag = 102
        totalAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryView.addSubview(totalAmountLabel)

        let targetLabel = UILabel()
        targetLabel.text = "of \(viewModel.totalTargetAmount.currencyFormatted)"
        targetLabel.font = .systemFont(ofSize: 12)
        targetLabel.textColor = .secondaryText
        targetLabel.tag = 103
        targetLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryView.addSubview(targetLabel)

        let progressLabel = UILabel()
        progressLabel.text = "\(Int(viewModel.overallProgress * 100))% Complete"
        progressLabel.font = .systemFont(ofSize: 12, weight: .medium)
        progressLabel.textColor = .primaryBlue
        progressLabel.textAlignment = .right
        progressLabel.tag = 104
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryView.addSubview(progressLabel)

        let completedLabel = UILabel()
        completedLabel.text = "\(viewModel.completedGoalsCount) completed, \(viewModel.activeGoalsCount) active"
        completedLabel.font = .systemFont(ofSize: 11)
        completedLabel.textColor = .secondaryText
        completedLabel.textAlignment = .right
        completedLabel.tag = 105
        completedLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryView.addSubview(completedLabel)

        NSLayoutConstraint.activate([
            totalLabel.topAnchor.constraint(equalTo: summaryView.topAnchor, constant: 16),
            totalLabel.leadingAnchor.constraint(equalTo: summaryView.leadingAnchor, constant: 16),

            totalAmountLabel.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 4),
            totalAmountLabel.leadingAnchor.constraint(equalTo: summaryView.leadingAnchor, constant: 16),

            targetLabel.topAnchor.constraint(equalTo: totalAmountLabel.bottomAnchor, constant: 2),
            targetLabel.leadingAnchor.constraint(equalTo: summaryView.leadingAnchor, constant: 16),

            progressLabel.topAnchor.constraint(equalTo: summaryView.topAnchor, constant: 16),
            progressLabel.trailingAnchor.constraint(equalTo: summaryView.trailingAnchor, constant: -16),

            completedLabel.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 4),
            completedLabel.trailingAnchor.constraint(equalTo: summaryView.trailingAnchor, constant: -16),
        ])
    }

    private func updateUI() {
        collectionView.reloadData()

        let isEmpty = viewModel.goals.isEmpty
        emptyStateLabel.isHidden = !isEmpty
        collectionView.isHidden = isEmpty

        if let totalLabel = summaryView.viewWithTag(102) as? UILabel {
            totalLabel.text = viewModel.totalCurrentAmount.currencyFormatted
        }
        if let targetLabel = summaryView.viewWithTag(103) as? UILabel {
            targetLabel.text = "of \(viewModel.totalTargetAmount.currencyFormatted)"
        }
        if let progressLabel = summaryView.viewWithTag(104) as? UILabel {
            progressLabel.text = "\(Int(viewModel.overallProgress * 100))% Complete"
        }
        if let completedLabel = summaryView.viewWithTag(105) as? UILabel {
            completedLabel.text = "\(viewModel.completedGoalsCount) completed, \(viewModel.activeGoalsCount) active"
        }
    }

    @objc private func addGoalTapped() {
        let addVC = AddGoalViewController()
        let nav = UINavigationController(rootViewController: addVC)
        present(nav, animated: true)
    }
}

extension GoalsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.goals.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalCell.identifier, for: indexPath) as! GoalCell
        let goal = viewModel.goals[indexPath.item]
        cell.configure(with: goal)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 44) / 2
        return CGSize(width: width, height: 160)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let goal = viewModel.goals[indexPath.item]
        showGoalDetail(goal)
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let goal = viewModel.goals[indexPath.item]

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            let contributeAction = UIAction(title: "Contribute", image: UIImage(systemName: "plus.circle")) { _ in
                self?.showContributeAlert(for: goal)
            }

            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self?.viewModel.deleteGoal(goal)
                self?.updateUI()
            }

            return UIMenu(title: "", children: [contributeAction, deleteAction])
        }
    }

    private func showGoalDetail(_ goal: Goal) {
        let alert = UIAlertController(title: goal.name, message: "Current: \(goal.currentAmount.currencyFormatted)\nTarget: \(goal.targetAmount.currencyFormatted)\nProgress: \(Int(goal.progress * 100))%", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Contribute", style: .default) { [weak self] _ in
            self?.showContributeAlert(for: goal)
        })

        alert.addAction(UIAlertAction(title: "Delete Goal", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteGoal(goal)
            self?.updateUI()
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func showContributeAlert(for goal: Goal) {
        let alert = UIAlertController(title: "Contribute to \(goal.name)", message: "Enter amount to add", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Amount"
            textField.keyboardType = .decimalPad
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let text = alert.textFields?.first?.text, let amount = Double(text) else { return }
            self?.viewModel.contributeToGoal(goal.id, amount: amount)
            self?.updateUI()
        })
        present(alert, animated: true)
    }
}

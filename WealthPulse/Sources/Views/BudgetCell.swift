import UIKit

final class BudgetCell: UITableViewCell {
    static let identifier = "BudgetCell"

    private let containerView = UIView()
    private let iconLabel = UILabel()
    private let categoryLabel = UILabel()
    private let progressBar = UIProgressView()
    private let amountLabel = UILabel()
    private let percentLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.backgroundColor = .cardBackground
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false

        iconLabel.font = .systemFont(ofSize: 20)
        iconLabel.textAlignment = .center
        iconLabel.layer.cornerRadius = 18
        iconLabel.clipsToBounds = true
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconLabel)

        categoryLabel.font = .systemFont(ofSize: 16, weight: .medium)
        categoryLabel.textColor = .primaryText
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(categoryLabel)

        progressBar.layer.cornerRadius = 4
        progressBar.clipsToBounds = true
        progressBar.trackTintColor = .tertiaryBackground
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(progressBar)

        amountLabel.font = .systemFont(ofSize: 14, weight: .medium)
        amountLabel.textColor = .primaryText
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(amountLabel)

        percentLabel.font = .systemFont(ofSize: 12)
        percentLabel.textColor = .secondaryText
        percentLabel.textAlignment = .right
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(percentLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

            iconLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            iconLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconLabel.widthAnchor.constraint(equalToConstant: 36),
            iconLabel.heightAnchor.constraint(equalToConstant: 36),

            categoryLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            categoryLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 12),
            categoryLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountLabel.leadingAnchor, constant: -8),

            progressBar.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            progressBar.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 12),
            progressBar.trailingAnchor.constraint(equalTo: percentLabel.leadingAnchor, constant: -12),
            progressBar.heightAnchor.constraint(equalToConstant: 8),

            percentLabel.centerYAnchor.constraint(equalTo: progressBar.centerYAnchor),
            percentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            percentLabel.widthAnchor.constraint(equalToConstant: 50),

            amountLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            amountLabel.trailingAnchor.constraint(equalTo: percentLabel.leadingAnchor, constant: -8),
        ])
    }

    func configure(with budget: Budget) {
        categoryLabel.text = budget.category.rawValue
        iconLabel.text = budget.category.icon
        iconLabel.backgroundColor = UIColor(hex: budget.category.color).withAlphaComponent(0.15)
        iconLabel.textColor = UIColor(hex: budget.category.color)

        amountLabel.text = "\(budget.spent.currencyFormatted) / \(budget.monthlyLimit.currencyFormatted)"

        let progress = Float(budget.percentUsed)
        progressBar.setProgress(progress, animated: false)

        if budget.isOverBudget {
            progressBar.progressTintColor = .expenseRed
            percentLabel.text = "\(Int(budget.percentUsed * 100))%"
            percentLabel.textColor = .expenseRed
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.expenseRed.withAlphaComponent(0.3).cgColor
        } else if budget.percentUsed > 0.8 {
            progressBar.progressTintColor = .warningOrange
            percentLabel.text = "\(Int(budget.percentUsed * 100))%"
            percentLabel.textColor = .warningOrange
            containerView.layer.borderWidth = 0
        } else {
            progressBar.progressTintColor = UIColor(hex: budget.category.color)
            percentLabel.text = "\(Int(budget.percentUsed * 100))%"
            percentLabel.textColor = .secondaryText
            containerView.layer.borderWidth = 0
        }
    }
}

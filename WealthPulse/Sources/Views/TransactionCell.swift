import UIKit

final class TransactionCell: UITableViewCell {
    static let identifier = "TransactionCell"

    private let containerView = UIView()
    private let iconContainerView = UIView()
    private let iconLabel = UILabel()
    private let categoryLabel = UILabel()
    private let noteLabel = UILabel()
    private let amountLabel = UILabel()
    private let dateLabel = UILabel()

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

        iconContainerView.layer.cornerRadius = 20
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconContainerView)

        iconLabel.font = .systemFont(ofSize: 18)
        iconLabel.textAlignment = .center
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.addSubview(iconLabel)

        categoryLabel.font = .systemFont(ofSize: 16, weight: .medium)
        categoryLabel.textColor = .primaryText
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(categoryLabel)

        noteLabel.font = .systemFont(ofSize: 13)
        noteLabel.textColor = .secondaryText
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(noteLabel)

        amountLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        amountLabel.textAlignment = .right
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(amountLabel)

        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .secondaryText
        dateLabel.textAlignment = .right
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

            iconContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            iconContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: 40),
            iconContainerView.heightAnchor.constraint(equalToConstant: 40),

            iconLabel.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),

            categoryLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            categoryLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 12),
            categoryLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountLabel.leadingAnchor, constant: -8),

            noteLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 2),
            noteLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
            noteLabel.trailingAnchor.constraint(lessThanOrEqualTo: dateLabel.leadingAnchor, constant: -8),
            noteLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),

            amountLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            amountLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),

            dateLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 2),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
        ])
    }

    func configure(with transaction: Transaction) {
        categoryLabel.text = transaction.category.rawValue
        noteLabel.text = transaction.note.isEmpty ? transaction.category.rawValue : transaction.note

        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        iconLabel.text = transaction.category.icon

        if transaction.type == .income {
            amountLabel.text = "+\(transaction.amount.currencyFormatted)"
            amountLabel.textColor = .incomeGreen
            iconContainerView.backgroundColor = UIColor.incomeGreen.withAlphaComponent(0.15)
        } else {
            amountLabel.text = "-\(transaction.amount.currencyFormatted)"
            amountLabel.textColor = .expenseRed
            iconContainerView.backgroundColor = UIColor.expenseRed.withAlphaComponent(0.15)
        }

        if transaction.date.isToday {
            dateLabel.text = "Today"
        } else if transaction.date.isYesterday {
            dateLabel.text = "Yesterday"
        } else {
            dateLabel.text = transaction.date.formatted()
        }
    }
}

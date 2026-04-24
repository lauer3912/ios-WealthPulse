import UIKit

final class GoalCell: UICollectionViewCell {
    static let identifier = "GoalCell"

    private let containerView = UIView()
    private let iconLabel = UILabel()
    private let nameLabel = UILabel()
    private let progressRing = CAShapeLayer()
    private let progressLabel = UILabel()
    private let amountLabel = UILabel()
    private let deadlineLabel = UILabel()
    private let daysRemainingLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.backgroundColor = .cardBackground
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false

        iconLabel.font = .systemFont(ofSize: 28)
        iconLabel.textAlignment = .center
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconLabel)

        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        nameLabel.textColor = .primaryText
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(nameLabel)

        amountLabel.font = .systemFont(ofSize: 14, weight: .medium)
        amountLabel.textColor = .secondaryText
        amountLabel.textAlignment = .center
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(amountLabel)

        deadlineLabel.font = .systemFont(ofSize: 12)
        deadlineLabel.textColor = .secondaryText
        deadlineLabel.textAlignment = .center
        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(deadlineLabel)

        daysRemainingLabel.font = .systemFont(ofSize: 11)
        daysRemainingLabel.textColor = .secondaryText
        daysRemainingLabel.textAlignment = .center
        daysRemainingLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(daysRemainingLabel)

        setupProgressRing()

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            iconLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            iconLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconLabel.widthAnchor.constraint(equalToConstant: 50),
            iconLabel.heightAnchor.constraint(equalToConstant: 50),

            nameLabel.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),

            amountLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            amountLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            amountLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),

            deadlineLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 2),
            deadlineLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            deadlineLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),

            daysRemainingLabel.topAnchor.constraint(equalTo: deadlineLabel.bottomAnchor, constant: 2),
            daysRemainingLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            daysRemainingLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
        ])
    }

    private func setupProgressRing() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: 25, y: 25), radius: 20, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)

        progressRing.path = circularPath.cgPath
        progressRing.strokeColor = UIColor.primaryGreen.cgColor
        progressRing.fillColor = UIColor.clear.cgColor
        progressRing.lineWidth = 4
        progressRing.lineCap = .round
        progressRing.strokeEnd = 0
    }

    func configure(with goal: Goal) {
        nameLabel.text = goal.name
        iconLabel.text = goal.icon.rawValue
        iconLabel.backgroundColor = UIColor(hex: goal.color).withAlphaComponent(0.15)
        iconLabel.layer.cornerRadius = 25
        iconLabel.clipsToBounds = true
        iconLabel.textColor = UIColor(hex: goal.color)

        amountLabel.text = "\(goal.currentAmount.currencyFormatted) / \(goal.targetAmount.currencyFormatted)"

        if goal.isCompleted {
            deadlineLabel.text = "Completed!"
            deadlineLabel.textColor = .incomeGreen
            daysRemainingLabel.text = ""
        } else if let days = goal.daysRemaining {
            deadlineLabel.text = goal.deadline?.formatted() ?? ""
            daysRemainingLabel.text = "\(days) days left"
            daysRemainingLabel.textColor = days < 30 ? .warningOrange : .secondaryText
        } else {
            deadlineLabel.text = "No deadline"
            daysRemainingLabel.text = ""
        }

        progressRing.strokeEnd = CGFloat(goal.progress)

        if goal.isCompleted {
            progressRing.strokeColor = UIColor.incomeGreen.cgColor
        } else if goal.isOverdue {
            progressRing.strokeColor = UIColor.expenseRed.cgColor
        } else {
            progressRing.strokeColor = UIColor(hex: goal.color).cgColor
        }

        containerView.layer.addSublayer(progressRing)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        progressRing.removeFromSuperlayer()
    }
}

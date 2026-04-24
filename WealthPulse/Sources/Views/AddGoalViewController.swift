import UIKit

protocol AddGoalDelegate: AnyObject {
    func didAddGoal(_ goal: Goal)
}

final class AddGoalViewController: UIViewController {
    weak var delegate: AddGoalDelegate?

    private let viewModel = GoalsViewModel()

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let iconCollectionView: UICollectionView
    private let nameTextField = UITextField()
    private let targetAmountTextField = UITextField()
    private let deadlineSwitch = UISwitch()
    private let deadlineLabel = UILabel()
    private let deadlinePicker = UIDatePicker()
    private let colorPicker = UIStackView()
    private let saveButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)

    private var selectedIcon: GoalIcon = .moneybag
    private var selectedColor: String = "#34C759"
    private var hasDeadline = false

    private let colors = ["#34C759", "#007AFF", "#FF2D55", "#FF9500", "#AF52DE", "#5856D6", "#00C7BE", "#FF6482"]

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.minimumInteritemSpacing = 12
        iconCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }

    private func setupUI() {
        title = "New Goal"
        view.backgroundColor = .systemBackground

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        let iconSectionLabel = UILabel()
        iconSectionLabel.text = "Choose an Icon"
        iconSectionLabel.font = .systemFont(ofSize: 14, weight: .medium)
        iconSectionLabel.textColor = .secondaryText
        iconSectionLabel.translatesAutoresizingMaskIntoConstraints = false

        iconCollectionView.backgroundColor = .clear
        iconCollectionView.delegate = self
        iconCollectionView.dataSource = self
        iconCollectionView.register(IconCell.self, forCellWithReuseIdentifier: "IconCell")
        iconCollectionView.showsHorizontalScrollIndicator = false
        iconCollectionView.translatesAutoresizingMaskIntoConstraints = false

        nameTextField.placeholder = "Goal name (e.g., New Car)"
        nameTextField.font = .systemFont(ofSize: 16)
        nameTextField.backgroundColor = .secondaryBackground
        nameTextField.layer.cornerRadius = 12
        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        nameTextField.leftViewMode = .always
        nameTextField.translatesAutoresizingMaskIntoConstraints = false

        let currencyLabel = UILabel()
        currencyLabel.text = WealthData.shared.settings.currencySymbol
        currencyLabel.font = .systemFont(ofSize: 24, weight: .bold)
        currencyLabel.textColor = .secondaryText

        targetAmountTextField.placeholder = "0.00"
        targetAmountTextField.font = .systemFont(ofSize: 24, weight: .bold)
        targetAmountTextField.keyboardType = .decimalPad
        targetAmountTextField.borderStyle = .none
        targetAmountTextField.translatesAutoresizingMaskIntoConstraints = false

        let amountStack = UIStackView(arrangedSubviews: [currencyLabel, targetAmountTextField])
        amountStack.spacing = 4
        amountStack.translatesAutoresizingMaskIntoConstraints = false

        let amountContainer = UIView()
        amountContainer.backgroundColor = .secondaryBackground
        amountContainer.layer.cornerRadius = 12
        amountContainer.translatesAutoresizingMaskIntoConstraints = false
        amountContainer.addSubview(amountStack)

        deadlineLabel.text = "Set a Deadline"
        deadlineLabel.font = .systemFont(ofSize: 16)
        deadlineSwitch.isOn = false
        deadlineSwitch.translatesAutoresizingMaskIntoConstraints = false

        let deadlineStack = UIStackView(arrangedSubviews: [deadlineLabel, deadlineSwitch])
        deadlineStack.distribution = .equalSpacing
        deadlineStack.translatesAutoresizingMaskIntoConstraints = false

        deadlinePicker.datePickerMode = .date
        deadlinePicker.preferredDatePickerStyle = .compact
        deadlinePicker.minimumDate = Date()
        deadlinePicker.isHidden = true
        deadlinePicker.translatesAutoresizingMaskIntoConstraints = false

        let colorSectionLabel = UILabel()
        colorSectionLabel.text = "Choose a Color"
        colorSectionLabel.font = .systemFont(ofSize: 14, weight: .medium)
        colorSectionLabel.textColor = .secondaryText
        colorSectionLabel.translatesAutoresizingMaskIntoConstraints = false

        colorPicker.axis = .horizontal
        colorPicker.spacing = 12
        colorPicker.translatesAutoresizingMaskIntoConstraints = false

        for (index, color) in colors.enumerated() {
            let button = UIButton(type: .system)
            button.tag = index
            button.backgroundColor = UIColor(hex: color)
            button.layer.cornerRadius = 20
            button.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
            if color == selectedColor {
                button.layer.borderWidth = 3
                button.layer.borderColor = UIColor.primaryText.cgColor
            }
            colorPicker.addArrangedSubview(button)
        }

        saveButton.setTitle("Create Goal", for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        saveButton.backgroundColor = .primaryGreen
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 14
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(iconSectionLabel)
        contentView.addSubview(iconCollectionView)
        contentView.addSubview(nameTextField)
        contentView.addSubview(amountContainer)
        contentView.addSubview(deadlineStack)
        contentView.addSubview(deadlinePicker)
        contentView.addSubview(colorSectionLabel)
        contentView.addSubview(colorPicker)
        contentView.addSubview(saveButton)
        contentView.addSubview(cancelButton)

        amountStack.translatesAutoresizingMaskIntoConstraints = false

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

            iconSectionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            iconSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            iconCollectionView.topAnchor.constraint(equalTo: iconSectionLabel.bottomAnchor, constant: 12),
            iconCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            iconCollectionView.heightAnchor.constraint(equalToConstant: 70),

            nameTextField.topAnchor.constraint(equalTo: iconCollectionView.bottomAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),

            amountContainer.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 12),
            amountContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            amountContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            amountContainer.heightAnchor.constraint(equalToConstant: 60),

            amountStack.centerYAnchor.constraint(equalTo: amountContainer.centerYAnchor),
            amountStack.leadingAnchor.constraint(equalTo: amountContainer.leadingAnchor, constant: 16),

            deadlineStack.topAnchor.constraint(equalTo: amountContainer.bottomAnchor, constant: 24),
            deadlineStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            deadlineStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            deadlinePicker.topAnchor.constraint(equalTo: deadlineStack.bottomAnchor, constant: 12),
            deadlinePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            colorSectionLabel.topAnchor.constraint(equalTo: deadlinePicker.bottomAnchor, constant: 24),
            colorSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            colorPicker.topAnchor.constraint(equalTo: colorSectionLabel.bottomAnchor, constant: 12),
            colorPicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            saveButton.topAnchor.constraint(equalTo: colorPicker.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 56),

            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 12),
            cancelButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
        ])
    }

    private func setupActions() {
        deadlineSwitch.addTarget(self, action: #selector(deadlineToggled), for: .valueChanged)
        saveButton.addTarget(self, action: #selector(saveGoal), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc private func deadlineToggled() {
        hasDeadline = deadlineSwitch.isOn
        deadlinePicker.isHidden = !hasDeadline
    }

    @objc private func colorSelected(_ sender: UIButton) {
        selectedColor = colors[sender.tag]
        for case let button as UIButton in colorPicker.arrangedSubviews {
            button.layer.borderWidth = button.tag == sender.tag ? 3 : 0
            button.layer.borderColor = button.tag == sender.tag ? UIColor.primaryText.cgColor : nil
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func saveGoal() {
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert("Please enter a goal name")
            return
        }

        guard let amountText = targetAmountTextField.text, let amount = Double(amountText), amount > 0 else {
            showAlert("Please enter a valid target amount")
            return
        }

        let deadline = hasDeadline ? deadlinePicker.date : nil

        viewModel.addGoal(name: name, targetAmount: amount, deadline: deadline, icon: selectedIcon, color: selectedColor)
        dismiss(animated: true)
    }

    @objc private func cancel() {
        dismiss(animated: true)
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension AddGoalViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GoalIcon.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconCell", for: indexPath) as! IconCell
        let icon = GoalIcon.allCases[indexPath.item]
        cell.configure(icon: icon, isSelected: icon == selectedIcon)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIcon = GoalIcon.allCases[indexPath.item]
        collectionView.reloadData()
    }
}

final class IconCell: UICollectionViewCell {
    private let iconLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        iconLabel.font = .systemFont(ofSize: 24)
        iconLabel.textAlignment = .center
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconLabel)

        contentView.layer.cornerRadius = 30
        contentView.backgroundColor = .secondaryBackground

        NSLayoutConstraint.activate([
            iconLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    func configure(icon: GoalIcon, isSelected: Bool) {
        iconLabel.text = icon.rawValue
        if isSelected {
            contentView.backgroundColor = UIColor.primaryGreen.withAlphaComponent(0.2)
            iconLabel.textColor = .primaryGreen
            contentView.layer.borderWidth = 2
            contentView.layer.borderColor = UIColor.primaryGreen.cgColor
        } else {
            contentView.backgroundColor = .secondaryBackground
            iconLabel.textColor = .secondaryText
            contentView.layer.borderWidth = 0
        }
    }
}

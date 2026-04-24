import UIKit

protocol AddTransactionDelegate: AnyObject {
    func didAddTransaction(_ transaction: Transaction)
}

final class AddTransactionViewController: UIViewController {
    weak var delegate: AddTransactionDelegate?

    private let viewModel = TransactionsViewModel()

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let typeSegmentedControl = UISegmentedControl(items: ["Expense", "Income"])
    private let amountTextField = UITextField()
    private let categoryButton = UIButton(type: .system)
    private let noteTextField = UITextField()
    private let datePicker = UIDatePicker()
    private let accountButton = UIButton(type: .system)
    private let recurringSwitch = UISwitch()
    private let recurringLabel = UILabel()
    private let saveButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)

    private var selectedType: TransactionType = .expense
    private var selectedCategory: TransactionCategory = .food
    private var selectedAccount: Account?
    private var selectedDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }

    private func setupUI() {
        title = "Add Transaction"
        view.backgroundColor = .systemBackground

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        typeSegmentedControl.selectedSegmentIndex = 0
        typeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false

        amountTextField.placeholder = "0.00"
        amountTextField.font = .systemFont(ofSize: 48, weight: .bold)
        amountTextField.textAlignment = .center
        amountTextField.keyboardType = .decimalPad
        amountTextField.borderStyle = .none
        amountTextField.translatesAutoresizingMaskIntoConstraints = false

        let currencyLabel = UILabel()
        currencyLabel.text = WealthData.shared.settings.currencySymbol
        currencyLabel.font = .systemFont(ofSize: 48, weight: .bold)
        currencyLabel.textColor = .secondaryText

        let amountStack = UIStackView(arrangedSubviews: [currencyLabel, amountTextField])
        amountStack.spacing = 4
        amountStack.translatesAutoresizingMaskIntoConstraints = false

        categoryButton.setTitle("Food & Dining", for: .normal)
        categoryButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        categoryButton.backgroundColor = .secondaryBackground
        categoryButton.layer.cornerRadius = 12
        categoryButton.contentHorizontalAlignment = .left
        categoryButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        categoryButton.translatesAutoresizingMaskIntoConstraints = false

        noteTextField.placeholder = "Add a note..."
        noteTextField.font = .systemFont(ofSize: 16)
        noteTextField.backgroundColor = .secondaryBackground
        noteTextField.layer.cornerRadius = 12
        noteTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        noteTextField.leftViewMode = .always
        noteTextField.translatesAutoresizingMaskIntoConstraints = false

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.maximumDate = Date()
        datePicker.translatesAutoresizingMaskIntoConstraints = false

        accountButton.setTitle("Select Account", for: .normal)
        accountButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        accountButton.backgroundColor = .secondaryBackground
        accountButton.layer.cornerRadius = 12
        accountButton.contentHorizontalAlignment = .left
        accountButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        accountButton.translatesAutoresizingMaskIntoConstraints = false

        recurringLabel.text = "Recurring Transaction"
        recurringLabel.font = .systemFont(ofSize: 16)
        recurringSwitch.isOn = false
        recurringSwitch.translatesAutoresizingMaskIntoConstraints = false

        let recurringStack = UIStackView(arrangedSubviews: [recurringLabel, recurringSwitch])
        recurringStack.distribution = .equalSpacing
        recurringStack.translatesAutoresizingMaskIntoConstraints = false

        saveButton.setTitle("Save Transaction", for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        saveButton.backgroundColor = .primaryGreen
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 14
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(typeSegmentedControl)
        contentView.addSubview(amountStack)
        contentView.addSubview(categoryButton)
        contentView.addSubview(noteTextField)
        contentView.addSubview(datePicker)
        contentView.addSubview(accountButton)
        contentView.addSubview(recurringStack)
        contentView.addSubview(saveButton)
        contentView.addSubview(cancelButton)

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

            typeSegmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            typeSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            typeSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            amountStack.topAnchor.constraint(equalTo: typeSegmentedControl.bottomAnchor, constant: 30),
            amountStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            categoryButton.topAnchor.constraint(equalTo: amountStack.bottomAnchor, constant: 30),
            categoryButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryButton.heightAnchor.constraint(equalToConstant: 50),

            noteTextField.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: 12),
            noteTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            noteTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            noteTextField.heightAnchor.constraint(equalToConstant: 50),

            datePicker.topAnchor.constraint(equalTo: noteTextField.bottomAnchor, constant: 12),
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            accountButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 12),
            accountButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            accountButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            accountButton.heightAnchor.constraint(equalToConstant: 50),

            recurringStack.topAnchor.constraint(equalTo: accountButton.bottomAnchor, constant: 20),
            recurringStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recurringStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            saveButton.topAnchor.constraint(equalTo: recurringStack.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 56),

            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 12),
            cancelButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
        ])
    }

    private func setupActions() {
        typeSegmentedControl.addTarget(self, action: #selector(typeChanged), for: .valueChanged)
        categoryButton.addTarget(self, action: #selector(selectCategory), for: .touchUpInside)
        accountButton.addTarget(self, action: #selector(selectAccount), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        saveButton.addTarget(self, action: #selector(saveTransaction), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc private func typeChanged() {
        selectedType = typeSegmentedControl.selectedSegmentIndex == 0 ? .expense : .income
        updateCategoryButton()
    }

    private func updateCategoryButton() {
        let categories = selectedType == .expense ? viewModel.categoriesForExpense : viewModel.categoriesForIncome
        selectedCategory = categories.first!
        categoryButton.setTitle(selectedCategory.rawValue, for: .normal)
    }

    @objc private func selectCategory() {
        let categories = selectedType == .expense ? viewModel.categoriesForExpense : viewModel.categoriesForIncome

        let alert = UIAlertController(title: "Select Category", message: nil, preferredStyle: .actionSheet)
        for category in categories {
            alert.addAction(UIAlertAction(title: "\(category.icon) \(category.rawValue)", style: .default) { [weak self] _ in
                self?.selectedCategory = category
                self?.categoryButton.setTitle(category.rawValue, for: .normal)
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func selectAccount() {
        let accounts = viewModel.accounts

        let alert = UIAlertController(title: "Select Account", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "None", style: .default) { [weak self] _ in
            self?.selectedAccount = nil
            self?.accountButton.setTitle("No Account", for: .normal)
        })
        for account in accounts {
            alert.addAction(UIAlertAction(title: "\(account.name)", style: .default) { [weak self] _ in
                self?.selectedAccount = account
                self?.accountButton.setTitle(account.name, for: .normal)
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func dateChanged() {
        selectedDate = datePicker.date
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func saveTransaction() {
        guard let amountText = amountTextField.text, let amount = Double(amountText), amount > 0 else {
            showAlert("Please enter a valid amount")
            return
        }

        viewModel.addTransaction(
            amount: amount,
            type: selectedType,
            category: selectedCategory,
            note: noteTextField.text ?? "",
            date: selectedDate,
            accountId: selectedAccount?.id,
            isRecurring: recurringSwitch.isOn,
            recurringInterval: recurringSwitch.isOn ? "monthly" : nil
        )

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

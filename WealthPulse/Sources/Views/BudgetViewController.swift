import UIKit

class BudgetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Budget"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

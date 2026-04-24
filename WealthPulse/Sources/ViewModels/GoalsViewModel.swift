import Foundation
import Combine

final class GoalsViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    @Published var totalTargetAmount: Double = 0
    @Published var totalCurrentAmount: Double = 0
    @Published var totalRemaining: Double = 0
    @Published var completedGoalsCount: Int = 0
    @Published var activeGoalsCount: Int = 0

    private let dataService = DataService.shared

    init() {
        loadData()
    }

    func loadData() {
        goals = dataService.getGoals()
        totalTargetAmount = goals.reduce(0) { $0 + $1.targetAmount }
        totalCurrentAmount = goals.reduce(0) { $0 + $1.currentAmount }
        totalRemaining = max(0, totalTargetAmount - totalCurrentAmount)
        completedGoalsCount = goals.filter { $0.isCompleted }.count
        activeGoalsCount = goals.filter { !$0.isCompleted }.count
    }

    func addGoal(name: String, targetAmount: Double, deadline: Date?, icon: GoalIcon, color: String = "#34C759") {
        _ = dataService.createGoal(name: name, targetAmount: targetAmount, deadline: deadline, icon: icon, color: color)
        loadData()
    }

    func updateGoal(_ goal: Goal) {
        dataService.updateGoal(goal)
        loadData()
    }

    func deleteGoal(_ goal: Goal) {
        dataService.deleteGoal(goal)
        loadData()
    }

    func contributeToGoal(_ goalId: UUID, amount: Double) {
        dataService.contributeToGoal(goalId, amount: amount)
        loadData()
    }

    func deleteGoal(at indexPath: IndexPath) {
        guard indexPath.row < goals.count else { return }
        let goal = goals[indexPath.row]
        deleteGoal(goal)
    }

    var overallProgress: Double {
        guard totalTargetAmount > 0 else { return 0 }
        return totalCurrentAmount / totalTargetAmount
    }

    var averageProgress: Double {
        guard !goals.isEmpty else { return 0 }
        return goals.reduce(0) { $0 + $1.progress } / Double(goals.count)
    }

    var suggestedMonthlyContribution: Double {
        let activeGoalsWithDeadline = goals.filter { !$0.isCompleted && $0.deadline != nil }
        guard !activeGoalsWithDeadline.isEmpty else { return 0 }

        var totalNeeded: Double = 0
        for goal in activeGoalsWithDeadline {
            guard let deadline = goal.deadline else { continue }
            let monthsRemaining = max(1, Calendar.current.dateComponents([.month], from: Date(), to: deadline).month ?? 1)
            totalNeeded += goal.remainingAmount / Double(monthsRemaining)
        }
        return totalNeeded
    }
}

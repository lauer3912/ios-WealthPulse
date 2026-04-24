import StoreKit

@MainActor
final class SubscriptionService: ObservableObject {
    static let shared = SubscriptionService()

    @Published var products: [Product] = []
    @Published var purchasedProductIDs: Set<String> = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var updateListenerTask: Task<Void, Error>?

    let productIds = [
        "wealthpulse_basic",
        "wealthpulse_premium_monthly",
        "wealthpulse_premium_yearly"
    ]

    private init() {
        updateListenerTask = listenForTransactions()
        Task {
            await loadProducts()
            await updateSubscriptionStatus()
        }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    func loadProducts() async {
        isLoading = true
        errorMessage = nil

        do {
            products = try await Product.products(for: productIds)
            products.sort { $0.price < $1.price }
        } catch {
            errorMessage = "Failed to load products: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func purchase(_ product: Product) async throws -> StoreKit.Transaction? {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await updateSubscriptionStatus()
                await transaction.finish()
                isLoading = false
                return transaction

            case .userCancelled:
                isLoading = false
                return nil

            case .pending:
                isLoading = false
                return nil

            @unknown default:
                isLoading = false
                return nil
            }
        } catch {
            isLoading = false
            errorMessage = "Purchase failed: \(error.localizedDescription)"
            throw error
        }
    }

    func updateSubscriptionStatus() async {
        var purchased: Set<String> = []

        for await result in StoreKit.Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                if transaction.productID == "wealthpulse_basic" ||
                   transaction.productID == "wealthpulse_premium_monthly" ||
                   transaction.productID == "wealthpulse_premium_yearly" {
                    purchased.insert(transaction.productID)
                }
            } catch {
                print("Transaction verification failed: \(error)")
            }
        }

        purchasedProductIDs = purchased
        updateLocalSubscription()
    }

    private func updateLocalSubscription() {
        if purchasedProductIDs.contains("wealthpulse_premium_monthly") {
            WealthData.shared.subscription = Subscription(
                tier: .premium,
                period: .monthly,
                expirationDate: Date().adding(months: 1),
                productId: "wealthpulse_premium_monthly",
                autoRenew: true
            )
        } else if purchasedProductIDs.contains("wealthpulse_premium_yearly") {
            WealthData.shared.subscription = Subscription(
                tier: .premium,
                period: .yearly,
                expirationDate: Date().adding(months: 12),
                productId: "wealthpulse_premium_yearly",
                autoRenew: true
            )
        } else if purchasedProductIDs.contains("wealthpulse_basic") {
            WealthData.shared.subscription = Subscription(
                tier: .basic,
                period: .monthly,
                expirationDate: Date().adding(months: 100),
                productId: "wealthpulse_basic",
                autoRenew: false
            )
        }

        WealthData.shared.save()
    }

    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreKitError.verificationFailed
        case .verified(let safe):
            return safe
        }
    }

    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in StoreKit.Transaction.updates {
                do {
                    let transaction = try await self.checkVerified(result)
                    await self.updateSubscriptionStatus()
                    await transaction.finish()
                } catch {
                    print("Transaction update failed: \(error)")
                }
            }
        }
    }

    var isPremium: Bool {
        guard let sub = WealthData.shared.subscription else { return false }
        if sub.tier == .premium && !sub.isExpired {
            return true
        }
        return purchasedProductIDs.contains("wealthpulse_premium_monthly") ||
               purchasedProductIDs.contains("wealthpulse_premium_yearly")
    }

    var hasActiveSubscription: Bool {
        return isPremium || purchasedProductIDs.contains("wealthpulse_basic")
    }

    func getProduct(_ productId: String) -> Product? {
        return products.first { $0.id == productId }
    }
}

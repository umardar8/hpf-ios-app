import Foundation
import Capacitor
import StoreKit

@objc(HPFStoreKitPlugin)
public class HPFStoreKitPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "HPFStoreKitPlugin"
    public let jsName = "HPFStoreKit"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "canMakePayments", returnType: CAPPluginMethodReturnPromise),
        CAPPluginMethod(name: "checkPremiumStatus", returnType: CAPPluginMethodReturnPromise),
        CAPPluginMethod(name: "purchaseProduct", returnType: CAPPluginMethodReturnPromise),
        CAPPluginMethod(name: "restorePurchases", returnType: CAPPluginMethodReturnPromise)
    ]

    private let defaultProductId = "com.paschallgamehub.highpowerfootball.premium"

    @objc func canMakePayments(_ call: CAPPluginCall) {
        call.resolve([
            "canMakePayments": AppStore.canMakePayments
        ])
    }

    @objc func checkPremiumStatus(_ call: CAPPluginCall) {
        let productId = call.getString("productId") ?? defaultProductId
        Task {
            for await result in Transaction.currentEntitlements {
                if case .verified(let transaction) = result {
                    if transaction.productID == productId && transaction.revocationDate == nil {
                        call.resolve([
                            "hasPremium": true,
                            "productId": transaction.productID
                        ])
                        return
                    }
                }
            }
            call.resolve([
                "hasPremium": false
            ])
        }
    }

    @objc func purchaseProduct(_ call: CAPPluginCall) {
        let productId = call.getString("productId") ?? defaultProductId

        guard AppStore.canMakePayments else {
            call.reject("In-App Purchases are disabled on this device.")
            return
        }

        Task {
            do {
                let products = try await Product.products(for: [productId])
                guard let product = products.first else {
                    call.reject("Product '\(productId)' not found in App Store. Please check App Store Connect / StoreKit configuration.")
                    return
                }

                let result = try await product.purchase()
                switch result {
                case .success(let verification):
                    switch verification {
                    case .verified(let transaction):
                        await transaction.finish()
                        call.resolve([
                            "success": true,
                            "productId": transaction.productID,
                            "transactionId": String(transaction.id)
                        ])
                    case .unverified(_, let error):
                        call.reject("Transaction verification failed: \(error.localizedDescription)")
                    }
                case .userCancelled:
                    call.resolve([
                        "success": false,
                        "cancelled": true,
                        "message": "Purchase was cancelled."
                    ])
                case .pending:
                    call.resolve([
                        "success": false,
                        "pending": true,
                        "message": "Purchase is pending approval."
                    ])
                @unknown default:
                    call.reject("Unknown purchase result.")
                }
            } catch {
                call.reject("Purchase failed: \(error.localizedDescription)")
            }
        }
    }

    @objc func restorePurchases(_ call: CAPPluginCall) {
        let productId = call.getString("productId") ?? defaultProductId
        Task {
            do {
                try await AppStore.sync()
                var hasPremium = false
                for await result in Transaction.currentEntitlements {
                    if case .verified(let transaction) = result {
                        if transaction.productID == productId && transaction.revocationDate == nil {
                            hasPremium = true
                            break
                        }
                    }
                }
                call.resolve([
                    "restored": true,
                    "hasPremium": hasPremium
                ])
            } catch {
                call.reject("Failed to restore purchases: \(error.localizedDescription)")
            }
        }
    }
}

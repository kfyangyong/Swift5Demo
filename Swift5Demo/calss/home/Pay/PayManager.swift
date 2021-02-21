//
//  PayManager.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/1/21.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import StoreKit


/// An enumeration of all the types of products or purchases.
enum SectionType: String, CustomStringConvertible {
    #if os (macOS)
    case availableProducts = "Available Products"
    case invalidProductIdentifiers = "Invalid Product Identifiers"
    case purchased = "Purchased"
    case restored = "Restored"
    #else
    case availableProducts = "AVAILABLE PRODUCTS"
    case invalidProductIdentifiers = "INVALID PRODUCT IDENTIFIERS"
    case purchased = "PURCHASED"
    case restored = "RESTORED"
    #endif
    case download = "DOWNLOAD"
    case originalTransaction = "ORIGINAL TRANSACTION"
    case productIdentifier = "PRODUCT IDENTIFIER"
    case transactionDate = "TRANSACTION DATE"
    case transactionIdentifier = "TRANSACTION ID"
    
    var description: String {
        return self.rawValue
    }
}

/// A structure that is used to represent a list of products or purchases.
struct Section {
    /// Products/Purchases are organized by category.
    var type: SectionType
    /// List of products/purchases.
    var elements = [Any]()
}

class PayManager: NSObject {
    static let shared = PayManager()
    
    var checkResult: (()->())?
    var showMsg: ((_ msg: String)->())?
    var productId: String?
    
    
    fileprivate var productRequest: SKProductsRequest!
    fileprivate var storeResponse = [Section]()

    override init() {
        super.init()
    
    }
    
    /// 唤起内购
    func startPay(productId: String) {
        searchCourseId(productId: productId)
    }
    
    /// 查询商品信息
    private func searchCourseId(productId: String) {
        let productIdentifiers = Set([productId])
        productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest.delegate = self
        productRequest.start()
    }
    
    //MARK: - 开始支付
    private func buy(_ product: SKProduct) {
        let payment = SKMutablePayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    /// Handles successful purchase transactions.
    fileprivate func handlePurchased(_ transaction: SKPaymentTransaction) {

        //TODO: -支付校验
        DispatchQueue.main.async {
            //用户取消
            self.showMsg?("支付校验")
            if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
                FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {

                do {
                    let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                    let receiptString = receiptData.base64EncodedString(options: [])
                    print(receiptString)

                    // Read receiptData 去苹果服务器校验
                    
                }
                catch { print("Couldn't read receipt data with error: " + error.localizedDescription) }
            }
        }

        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    /// Handles failed purchase transactions.
    fileprivate func handleFailed(_ transaction: SKPaymentTransaction) {
        if (transaction.error as? SKError)?.code != .paymentCancelled {
            DispatchQueue.main.async {
                //用户取消
                print("交易已取消")
                self.showMsg?("交易已取消")
            }
        }else {
            DispatchQueue.main.async {
                //用户取消
                print("购买失败")
                self.showMsg?("购买失败")
            }
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    /// Handles restored purchase transactions.
    fileprivate func handleRestored(_ transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
    }

}

extension PayManager: SKProductsRequestDelegate {
    ///查询结果
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        // products contains products whose identifiers have been recognized by the App Store. As such, they can be purchased.
        var availableProducts = [SKProduct]()
        if !response.products.isEmpty {
            //商品信息
            availableProducts = response.products
            print(response.products)
        }
        
        if !availableProducts.isEmpty {
            storeResponse.append(Section(type: .availableProducts, elements: availableProducts))
        }
        
        if !storeResponse.isEmpty {
            DispatchQueue.main.async {
                // 这里可以展示商品信息界面，然后在弹出商品订阅弹框（也可跳过）
            }
            //直接调用支付
            guard let product = response.products.first else {
                return
            }
            let payment = SKMutablePayment(product: product)
            SKPaymentQueue.default().add(payment)
        }else {
            print("商品数量不足")
            showMsg?("商品数量不足")
        }
    }
}


extension PayManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                //交易中
                break
            case .deferred:
                print("Allow the user to continue using your app.")
            case .purchased:
                //交易完成
                handlePurchased(transaction)
            case .failed:
                //交易失败
                handleFailed(transaction)
            case .restored:
                //已经购买过商品
                handleRestored(transaction)
            @unknown default:
                fatalError("Unknown payment transaction case.")
            }
        }
    }
    
    func paymentQueueDidChangeStorefront(_ queue: SKPaymentQueue) {
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print("------------------错误-----------------:%@", error)
    }
    
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("------------反馈信息结束-----------------")
    }

}

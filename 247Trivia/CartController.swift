//
//  CartController.swift
//  247Trivia
//
//  Created by John Nik on 6/28/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import StoreKit

class CartController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    let FIRSTCOINS_PRODUCT_ID = "com.caesar.firstcoins"
    
    var productID = ""
    var productRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    var nonConsumablePurchaseMade = defaults.bool(forKey: "nonConsumablePurchaseMade")
    var coins = defaults.integer(forKey: "coins")
    
    
    let totalCoinsLabel: UILabel = {
        let label = UILabel()
        label.text = "1000 PTS"
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    let coin1ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "coin.jpeg")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let coin1Label: UILabel = {
        let label = UILabel()
        label.text = "1000 PTS"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let coin1Button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Buy Now", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buy1000Coins), for: .touchUpInside)
        return button
    }()
    
    func buy1000Coins() {
        purchaseMyProduct(product: iapProducts[0])
    }
    
    let coin2ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "coin.jpeg")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let coin2Label: UILabel = {
        let label = UILabel()
        label.text = "5000 PTS"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let coin2Button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Buy Now", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let coin3ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "coin.jpeg")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let coin3Label: UILabel = {
        let label = UILabel()
        label.text = "10000 PTS"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let coin3Button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Buy Now", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
        
        totalCoinsLabel.text = "Total: \(coins) PTS"
        
        fetchAvailableProducts()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }

    
    private func setupViews() {
        
        view.addSubview(totalCoinsLabel)
        
        view.addSubview(coin1ImageView)
        view.addSubview(coin1Label)
        view.addSubview(coin1Button)
        view.addSubview(coin2ImageView)
        view.addSubview(coin2Label)
        view.addSubview(coin2Button)
        view.addSubview(coin3ImageView)
        view.addSubview(coin3Label)
        view.addSubview(coin3Button)
        
        totalCoinsLabel.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.5).isActive = true
        totalCoinsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        totalCoinsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        totalCoinsLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        coin1ImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        coin1ImageView.heightAnchor.constraint(equalToConstant: 100 * (coin1ImageView.image?.size.height)! / (coin1ImageView.image?.size.width)!).isActive = true
        coin1ImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        coin1ImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        coin1Label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        coin1Label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        coin1Label.topAnchor.constraint(equalTo: coin1ImageView.topAnchor, constant: 0).isActive = true
        coin1Label.leftAnchor.constraint(equalTo: coin1ImageView.rightAnchor, constant: 50).isActive = true
        
        coin1Button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        coin1Button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        coin1Button.topAnchor.constraint(equalTo: coin1Label.bottomAnchor, constant: 30).isActive = true
        coin1Button.centerXAnchor.constraint(equalTo: coin1Label.centerXAnchor).isActive = true
        
        coin2ImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        coin2ImageView.heightAnchor.constraint(equalToConstant: 100 * (coin1ImageView.image?.size.height)! / (coin1ImageView.image?.size.width)!).isActive = true
        coin2ImageView.topAnchor.constraint(equalTo: coin1ImageView.bottomAnchor, constant: 30).isActive = true
        coin2ImageView.leftAnchor.constraint(equalTo: coin1ImageView.leftAnchor, constant: 0).isActive = true
        
        coin2Label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        coin2Label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        coin2Label.topAnchor.constraint(equalTo: coin2ImageView.topAnchor, constant: 0).isActive = true
        coin2Label.leftAnchor.constraint(equalTo: coin2ImageView.rightAnchor, constant: 50).isActive = true
        
        coin2Button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        coin2Button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        coin2Button.topAnchor.constraint(equalTo: coin2Label.bottomAnchor, constant: 30).isActive = true
        coin2Button.centerXAnchor.constraint(equalTo: coin2Label.centerXAnchor).isActive = true
        
        coin3ImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        coin3ImageView.heightAnchor.constraint(equalToConstant: 100 * (coin1ImageView.image?.size.height)! / (coin1ImageView.image?.size.width)!).isActive = true
        coin3ImageView.topAnchor.constraint(equalTo: coin2ImageView.bottomAnchor, constant: 30).isActive = true
        coin3ImageView.leftAnchor.constraint(equalTo: coin2ImageView.leftAnchor, constant: 0).isActive = true
        
        coin3Label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        coin3Label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        coin3Label.topAnchor.constraint(equalTo: coin3ImageView.topAnchor, constant: 0).isActive = true
        coin3Label.leftAnchor.constraint(equalTo: coin3ImageView.rightAnchor, constant: 50).isActive = true
        
        coin3Button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        coin3Button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        coin3Button.topAnchor.constraint(equalTo: coin3Label.bottomAnchor, constant: 30).isActive = true
        coin3Button.centerXAnchor.constraint(equalTo: coin3Label.centerXAnchor).isActive = true
        
    }
    
    private func setupNavigationBar() {
        
        self.tabBarController?.navigationItem.title = "Store"
        
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Restore", style: .plain, target: self, action: #selector(restorePurchase))
        
        
        view.backgroundColor = UIColor(r: 255, g: 89, b: 100, a: 1)
        
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "247_clock")
        backgroundImageView.alpha = 0.4
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(backgroundImageView)
        
        backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 25).isActive = true
        backgroundImageView.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.85).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.85).isActive = true
        
    }
    
    func fetchAvailableProducts() {
        
        let productIdentifier = NSSet(objects: FIRSTCOINS_PRODUCT_ID)
        
        productRequest = SKProductsRequest(productIdentifiers: productIdentifier as! Set<String>)
        
        productRequest.delegate = self
        productRequest.start()
        
    }
    
    // Mark: - Restore non-consumable purchase button
    
    func restorePurchase() {
        
        SKPaymentQueue.default().add(self)
        
        SKPaymentQueue.default().restoreCompletedTransactions()
        
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        
        
    }
    
    // Mark: Request IAP products
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        if (response.products.count > 0) {
            iapProducts = response.products
            
            let firstProduct = response.products[0] as SKProduct
            
            let numberFormatter = NumberFormatter()
            numberFormatter.formatterBehavior = .behavior10_4
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = firstProduct.priceLocale
            let price1Str = numberFormatter.string(from: firstProduct.price)
            
            coin1Label.text = firstProduct.localizedDescription + "\nfor just \(price1Str!)"
        }
        
    }
    
    // Mark: Make Purchase of a Product
    
    func canMakePurchases() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func purchaseMyProduct(product: SKProduct) {
        if self.canMakePurchases() {
            
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            productID = product.productIdentifier
            
        } else {
            
            showAlertMessage(vc: self, titleStr: "24/7 Trivia", messageStr: "Purchase are disabled in your device!")
            
        }
    }
    
    // Mark: IAP Payment queue
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction: AnyObject in transactions {
            
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    if productID == FIRSTCOINS_PRODUCT_ID {
                        coins += 1000
                        defaults.set(coins, forKey: "coins")
                        totalCoinsLabel.text = "Total: \(coins) PTS"
                        
                        showAlertMessage(vc: self, titleStr: "24/7 Trivia", messageStr: "You've successfully bought 1000 extra points")
                    }
                    
                    break
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                default:
                    break
                }
            }
            
        }
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}


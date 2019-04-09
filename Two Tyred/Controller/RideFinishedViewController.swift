//
//  RideFinishedViewController.swift
//  Two Tyred
//
//  Created by Michael Christie on 13/03/2019.
//  Copyright © 2019 Michael Christie. All rights reserved.
//

import UIKit
import PassKit
import Stripe

class RideFinishedViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    func displayDefaultAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func payPressed(_ sender: Any) {
        // Cards that should be accepted
        let paymentNetworks:[PKPaymentNetwork] = [.amex,.masterCard,.visa]
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            let request = PKPaymentRequest()
            
            request.merchantIdentifier = "merchant.com.michaelchristie.Two-Tyred"
            request.countryCode = "IE"
            request.currencyCode = "EUR"
            request.supportedNetworks = paymentNetworks
            request.requiredShippingContactFields = [.name, .postalAddress]
            // This is based on using Stripe
            request.merchantCapabilities = .capability3DS
            
            let tshirt = PKPaymentSummaryItem(label: "T-shirt", amount: NSDecimalNumber(decimal:1.00), type: .final)
            let shipping = PKPaymentSummaryItem(label: "Shipping", amount: NSDecimalNumber(decimal:1.00), type: .final)
            let tax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(decimal:1.00), type: .final)
            let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(decimal:3.00), type: .final)
            request.paymentSummaryItems = [tshirt, shipping, tax, total]
            
            let authorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: request)
            
            if let viewController = authorizationViewController {
                viewController.delegate = self
                
                present(viewController, animated: true, completion: nil)
            }
            
        }
    }
    
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        // Let the Operating System know that the payment was accepted successfully
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        // Dismiss the Apple Pay UI
        dismiss(animated: true, completion: nil)
    }
    
    
    
}

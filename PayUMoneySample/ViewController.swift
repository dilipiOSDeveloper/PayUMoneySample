//
//  ViewController.swift
//  PayUMoneySample
//
//  Created by SARA Technologies  on 24/04/20.
//  Copyright © 2020 SARA Technologies Pvt. Ltd. All rights reserved.
//

import UIKit
import PlugNPlay
import CommonCrypto

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        continueWithCardPayment()
    }
    
    func continueWithCardPayment() {
        let paymentParam = PUMTxnParam()
        paymentParam.key = "jMHF3RJY" // merchant key can be change
        paymentParam.merchantid = "1234556" // merchant id can be change
        paymentParam.txnID = "123"
        paymentParam.phone = "9898999989"
        paymentParam.amount = "1"
        paymentParam.productInfo = "new producy"
        paymentParam.surl = "https://test.payumoney.com/mobileapp/payumoney/success.php"
        paymentParam.furl = "https://test.payumoney.com/mobileapp/payumoney/failure.php"
        paymentParam.firstname = "john"
        paymentParam.email = "john@john.com"
        paymentParam.environment = PUMEnvironment.production
        paymentParam.udf1 = "udf1"
        paymentParam.udf2 = "udf2"
        paymentParam.udf3 = "udf3"
        paymentParam.udf4 = "udf4"
        paymentParam.udf5 = "udf5"
        paymentParam.udf6 = ""
        paymentParam.udf7 = ""
        paymentParam.udf8 = ""
        paymentParam.udf9 = ""
        paymentParam.udf10 = ""
        paymentParam.hashValue = self.getHashForPaymentParams(paymentParam)
        // paymentParam.offerKey = ""              // Set this property if you want to give offer:
        // paymentParam.userCredentials = ""
        
        
        PlugNPlay.presentPaymentViewController(withTxnParams: paymentParam, on: self) { (dict, error, value) in
            print(dict as Any, error as Any, value as Any)

            print("Error : \(error as Any)")
            print(error?.localizedDescription ?? "")
            
            if error == nil {
                print("error is nil")
            }else if error != nil {
                print("error is nil")
//                if(error?.localizedDescription ?? "" == "Transaction Cancelled By the User.") {
//
//                    print("cancelled by user")
//                } else if(error?.localizedDescription ?? "" == "Transaction Cancelled By the User.") {
//
//                    print("cancelled by user")
//                }
//                else if(error?.localizedDescription ?? "" == "You don’t have internet connection. Please check your connectivity.") {
//
//                    print("internet issue")
//                }
//                else if(error?.localizedDescription ?? "" == "The request timed out.") {
//
//                    print("timeout")
//                }
            }
            else {
                
            }
        }
    }
    
    
    func sha512(_ str: String) -> String {
        
        let data = str.data(using:.utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        data.withUnsafeBytes({
            _ = CC_SHA512($0, CC_LONG(data.count), &digest)
        })
        return digest.map({ String(format: "%02hhx", $0) }).joined(separator: "")
    }
    func getHashForPaymentParams(_ txnParam: PUMTxnParam?) -> String? {
        let salt = "40OLIKYEb7"
        var hashSequence: String? = nil
        if let key = txnParam?.key, let txnID = txnParam?.txnID, let amount = txnParam?.amount, let productInfo = txnParam?.productInfo, let firstname = txnParam?.firstname, let email = txnParam?.email, let udf1 = txnParam?.udf1, let udf2 = txnParam?.udf2, let udf3 = txnParam?.udf3, let udf4 = txnParam?.udf4, let udf5 = txnParam?.udf5, let udf6 = txnParam?.udf6, let udf7 = txnParam?.udf7, let udf8 = txnParam?.udf8, let udf9 = txnParam?.udf9, let udf10 = txnParam?.udf10 {
            hashSequence = "\(key)|\(txnID)|\(amount)|\(productInfo)|\(firstname)|\(email)|\(udf1)|\(udf2)|\(udf3)|\(udf4)|\(udf5)|\(udf6)|\(udf7)|\(udf8)|\(udf9)|\(udf10)|\(salt)"
        }
        
        let hash = self.sha512(hashSequence!).description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        
        return hash
    }
}


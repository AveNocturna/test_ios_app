//
//  Alerts.swift
//  ios_test_app
//
//  Created by AveNocturna on 2/27/23.
//

import Foundation
import UIKit
import Loaf
import CryptoKit

 class AlertHelper {
    public typealias EmptyCompletion = () -> Void
    //MARK:-Alerts
    static func alertMessage(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default,
                handler: nil
            ))
            guard let window : UIWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {return}
            var presentVC = window.rootViewController
            while let next = presentVC?.presentedViewController {
                presentVC = next
            }
            presentVC?.present(alert, animated: true, completion: nil)
        }
    }
     
    class func showLoaf(message: String, state: Loaf.State,location: Loaf.Location = .top) {
        DispatchQueue.main.async {
            guard let window : UIWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {return}
            var presentVC = window.rootViewController
            while let next = presentVC?.presentedViewController {
                presentVC = next
            }
            guard let presenter = presentVC else {
                AlertHelper.alertMessage(title: "", message: message)
                return
            }
            switch state {
            case .success:
                Loaf(message, state: .custom(.init(backgroundColor: UIColor(hexString: "68B984"))),location: location, sender: presenter).show()
            case .warning:
                Loaf(message, state: .warning,location: location, sender: presenter).show()
            case .error:
                Loaf(message, state: .error,location: location, sender: presenter).show()
            default:
                return
            }
        }
    }
    
 }

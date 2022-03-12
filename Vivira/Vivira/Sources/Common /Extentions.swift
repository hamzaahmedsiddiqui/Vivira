//
//  Extentions.swift
//  Vivira
//
//  Created by Hamza Ahmed on 12/03/2022.
//

import Foundation
import UIKit

// MARK: - Extention UIViewController
/**
 Displays alert
 - parameter title: String
 - parameter message: String
 */
extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
                                                    message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}

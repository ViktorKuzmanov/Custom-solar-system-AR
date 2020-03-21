//
//  Alert.swift
//  AR app
//
//  Created by Viktor Kuzmanov on 6/5/19.
//  Copyright © 2019 Inniti. All rights reserved.
//

import UIKit

struct Alert {
    
    static func showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alertViewController, animated: true)
    }
    
    static func showActionSheet(on: UIViewController, style: UIAlertController.Style, title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .default, handler: nil)], completion: (() -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
        }
        on.present(alert, animated: true, completion: completion)
    }
}

//
//  DisplayableAlert.swift
//  GithubQuery
//
//  Created by dkotha on 9/20/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

protocol DisplayableAlert {
    func showAlert(with title: String?, message: String, actions: [UIAlertAction]?)
}

extension DisplayableAlert where Self: UIViewController {
    func showAlert(with title: String?, message: String, actions: [UIAlertAction]? = nil) {
        guard presentedViewController == nil else {
            return
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions?.forEach { action in
            alertController.addAction(action)
        }
        present(alertController, animated: true)
    }
}

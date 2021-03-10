//
//  BaseViewController.swift
//  GitHubUsersSampleApp
//
//  Created by Sajjad Raza on 08/03/2021.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    func createAlert() {
        let alert = UIAlertController.init(title: "", message: "Profile Updated Successfully", preferredStyle: .alert)
        let okBtn = UIAlertAction.init(title: "Ok", style: .destructive, handler: nil)
        alert.addAction(okBtn)
        self.present(alert, animated: true, completion: nil)
    }
}

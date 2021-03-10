//
//  BaseTextField.swift
//  GitHubUsersSampleApp
//
//  Created by Sajjad Raza on 08/03/2021.
//

import Foundation
import UIKit

@IBDesignable
class BaseTextFeilds: UITextField {
    @IBInspectable var rightInset: CGFloat = 30
    @IBInspectable var leftInset: CGFloat = 10
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) || action == #selector(UIResponderStandardEditActions.copy(_:)) || action == #selector(UIResponderStandardEditActions.select(_:)) || action == #selector(UIResponderStandardEditActions.selectAll(_:)) {
            return true
        }
        return super.canPerformAction(action, withSender: sender)
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect.init(x: leftInset, y: bounds.origin.y, width: bounds.size.width - (rightInset + leftInset), height: bounds.height)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}

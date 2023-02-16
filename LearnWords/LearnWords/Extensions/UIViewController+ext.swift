//
//  UIViewController+ext.swift
//  LearnWords
//
//  Created by sergemi on 16.02.2023.
//

import UIKit

extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        return instantiateFromNib()
    }
    
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.globalDismissKeyboard))
//        view.addGestureRecognizer(tap)
//    }

//    @objc func globalDismissKeyboard() {
//        view.endEditing(true)
//    }
    
    func showAlert(alertText : String, alertMessage : String, callback: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: callback))
        self.present(alert, animated: true, completion: nil)
    }
}

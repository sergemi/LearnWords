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
    
    func showAlert(title : String, message : String, callback: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok".localized(), style: UIAlertAction.Style.default, handler: callback))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showYesNoAlert(title: String, message: String, yesTitle: String, noTitle: String, yesCallback: ((UIAlertAction) -> Void)?, noCallback: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: yesTitle, style: UIAlertAction.Style.default, handler: yesCallback))
        
        alert.addAction(UIAlertAction(title: noTitle, style: UIAlertAction.Style.cancel, handler: noCallback))
        
        self.present(alert, animated: true, completion: nil)
    }
}

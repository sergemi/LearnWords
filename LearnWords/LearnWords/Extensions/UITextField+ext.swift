//
//  UITextField+ext.swift
//  LearnWords
//
//  Created by sergemi on 20.02.2023.
//

import UIKit

extension UITextField {
    
    func setPaddingFor(left: CGFloat? = nil, right: CGFloat? = nil) {
        if let left = left {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
        
        if let right = right {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}

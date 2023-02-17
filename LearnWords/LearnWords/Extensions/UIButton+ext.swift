//
//  UIButton+ext.swift
//  LearnWords
//
//  Created by sergemi on 17.02.2023.
//

import UIKit

extension UIButton {
    func setTitle(_ title: String?) {
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .selected)
    }
}

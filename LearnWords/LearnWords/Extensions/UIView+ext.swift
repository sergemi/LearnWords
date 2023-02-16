//
//  UIView+ext.swift
//  LearnWords
//
//  Created by sergemi on 15.02.2023.
//

import UIKit

extension UIView {
    func loadViewFromNib() -> UIView? {
         let bundle = Bundle(for: type(of: self))
         let nib = UINib(nibName: String(describing: Self.self), bundle: bundle)
         return nib.instantiate(withOwner: self, options: nil).first as? UIView
     }
}

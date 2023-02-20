//
//  UICheckbox.swift
//  LearnWords
//
//  Created by sergemi on 19.02.2023.
//

import UIKit

class UICheckbox: UIButton {
    var selectedBorderColor: UIColor = .black
    var defaultBorderColor: UIColor = .black
    
    var disableTogle = false

    func toggle() {
        isSelected = !isSelected
        updateBorderColor()
    }
    
    func updateBorderColor() {
        let borderColor = isSelected ? selectedBorderColor : defaultBorderColor
        self.layer.borderColor = borderColor.cgColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if disableTogle {
            super.touchesBegan(touches, with: event)
        }
        else {
            toggle()
        }
    }
    
    func select(_ selected: Bool = true) {
        isSelected = selected
        updateBorderColor()
    }
}

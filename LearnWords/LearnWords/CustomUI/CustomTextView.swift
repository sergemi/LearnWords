//
//  CustomTextView.swift
//  LearnWords
//
//  Created by sergemi on 25.02.2023.
//

import Foundation
import UIKit

class CustomTextView: UITextView {
    var borderView: UIView!
//    var floatingLabel = UILabel(frame: CGRect.zero) // todo
    var border: CAShapeLayer? = nil
    var floatingLabel: UILabel!
    var floatingLabelHeight: CGFloat = 14
    
    @IBInspectable
    var _placeholder: String? {
        didSet {
//            UpdateBorder()
            UpdateFloatingLabel()
        }
    }
    
    var _cornerRadius: CGFloat = 0
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return _cornerRadius
        }
        set {
            self._cornerRadius = newValue
            UpdateBorder()
            UpdateFloatingLabel()
        }
    }
    
    @IBInspectable
    var floatingLabelColor: UIColor = UIColor.black {
        didSet {
            self.floatingLabel.textColor = floatingLabelColor
            borderColor = floatingLabelColor
            self.setNeedsDisplay()
        }
    }
    
    fileprivate var _borderColor: UIColor = UIColor(rgb: 0x6D6E70)
    @IBInspectable
    var borderColor: UIColor = UIColor(rgb: 0x6D6E70) {
        didSet {
            _borderColor = borderColor
            UpdateBorder()
        }
    }
    
    @IBInspectable
    var floatingLabelFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            self.floatingLabel.font = self.floatingLabelFont
            self.font = self.floatingLabelFont
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var _backgroundColor: UIColor = UIColor.white {
        didSet {
            self.layer.backgroundColor = self._backgroundColor.cgColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        floatingLabelColor = UIColor(rgb: 0xD0D2D3)
        _borderColor = floatingLabelColor
        
        _cornerRadius = 8.0
        
        // border
        borderView = UIView(frame: bounds)
        self.addSubview(borderView)
        borderView.isUserInteractionEnabled = false
        textColor = UIColor(rgb: 0x6D6E70)
        floatingLabel = UILabel(frame: CGRect.zero)
        
        // placeholder
        AddFloatLabel()
//        UpdateFloatingLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        UpdateBorder()
        UpdateFloatingLabel()
        self.setNeedsDisplay()
    }
    
    func UpdateBorder() {
        border?.removeFromSuperlayer()
        border = CAShapeLayer()
        guard let border = border else {
            return
        }
        border.lineWidth = 1.0
        border.strokeColor = borderColor.cgColor//floatingLabelColor.cgColor
//        border.strokeColor = floatingLabelColor.cgColor
        border.frame = bounds
        border.fillColor = nil
        if cornerRadius > 0 {
            border.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            border.path = UIBezierPath(rect: bounds).cgPath
        }
        borderView.layer.addSublayer(border)
    }
    
    // Add a floating label to the view on becoming first responder
    @objc func UpdateFloatingLabel() {
        self.floatingLabel.text = " " + (self._placeholder ?? "") + " "
//        self.floatingLabel.frame = CGRect(x: 0, y: 0, width: floatingLabel.frame.width+4, height: floatingLabel.frame.height+2)
        
        self.floatingLabel.isHidden = self._placeholder == "" || self._placeholder == nil
        self.bringSubviewToFront(self.floatingLabel)
    }
    
    fileprivate func AddFloatLabel() {
        self.floatingLabel.isHidden = false
        self.floatingLabel.textColor = floatingLabelColor
        self.floatingLabel.font = floatingLabelFont
//            self.floatingLabel.layer.backgroundColor = UIColor.white.cgColor
        self.floatingLabel.backgroundColor = UIColor.white
        self.clipsToBounds = false
        
        self.floatingLabel.frame = CGRect(x: 0, y: 0, width: floatingLabel.frame.width+4, height: floatingLabel.frame.height+2)
        
        self.floatingLabel.textAlignment = .center
        self.floatingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.floatingLabel.clipsToBounds = true
        self.addSubview(self.floatingLabel)
//            self.layer.borderColor = self.borderColor.cgColor

        self.floatingLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.floatingLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 14).isActive = true
    }
    
    @objc func RemoveFloatingLabel() {
        UIView.animate(withDuration: 0.13) { [weak self] in
            guard let self = self else {
                return
            }
            self.floatingLabel.removeFromSuperview()
            self.floatingLabel.isHidden = true
            self.setNeedsDisplay()
        }
    }
}

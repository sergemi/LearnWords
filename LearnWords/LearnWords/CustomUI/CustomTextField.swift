//
//  CustomTextField.swift
//  LearnWords
//
//  Created by sergemi on 20.02.2023.
//

import UIKit

class CustomTextField: UITextField {
    var floatingLabel = UILabel(frame: CGRect.zero)
    var borderView: UIView!
    var border: CAShapeLayer? = nil
    var floatingLabelHeight: CGFloat = 14
    var button = UIButton(type: .custom)
    var imageView = UIImageView(frame: CGRect.zero)
    var forceUpdate = false
    
    @IBInspectable
    var _placeholder: String? {
        didSet {
            forceUpdate = true
            UpdateBorder()
            UpdateFloatingLabel()
            forceUpdate = false
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

    override var text: String? {
        didSet {
            forceUpdate = true
            UpdateBorder()
            UpdateFloatingLabel()
            forceUpdate = false
        }
    }
    
//    @IBInspectable
//    var floatingLabelBackground: UIColor = UIColor.white.withAlphaComponent(1) {
//        didSet {
//            self.floatingLabel.backgroundColor = self.floatingLabelBackground
//            self.setNeedsDisplay()
//        }
//    }
    
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
        
        // placeholder
        self._placeholder = (self._placeholder != nil) ? self._placeholder : placeholder
        placeholder = self._placeholder // Make sure the placeholder is shown
        self.addTarget(self, action: #selector(self.UpdateFloatingLabel), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.RemoveFloatingLabel), for: .editingDidEnd)
        
        setPaddingFor(left: 25, right: 25)
        UpdateFloatingLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        UpdateBorder()
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
        if self.text == "" || self.text == nil || forceUpdate {
            if self._placeholder == nil {
                self.floatingLabel.isHidden = true
            }
            else {
                AddFloatLabel()
            }
        }
        else {
            AddFloatLabel()
        }
    }
    
    fileprivate func AddFloatLabel() {
        self.floatingLabel.isHidden = false
        self.placeholder = ""
        self.floatingLabel.textColor = floatingLabelColor
        self.floatingLabel.font = floatingLabelFont
        self.floatingLabel.text = " " + (self._placeholder ?? "") + " "
//            self.floatingLabel.layer.backgroundColor = UIColor.white.cgColor
        self.floatingLabel.backgroundColor = UIColor.white
        self.floatingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.floatingLabel.clipsToBounds = true
        self.floatingLabel.frame = CGRect(x: 0, y: 0, width: floatingLabel.frame.width+4, height: floatingLabel.frame.height+2)
        self.floatingLabel.textAlignment = .center
        self.floatingLabel.isHidden = false
        self.addSubview(self.floatingLabel)
//            self.layer.borderColor = self.borderColor.cgColor

        self.floatingLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.floatingLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 14).isActive = true
        
        // Floating label may be stuck behind text input. we bring it forward as it was the last item added to the view heirachy
        guard let lastSubview = subviews.last else {
            return
        }
        self.bringSubviewToFront(lastSubview)
        self.setNeedsDisplay()
    }
    
    @objc func RemoveFloatingLabel() {
        if self.text == "" {
            UIView.animate(withDuration: 0.13) { [weak self] in
                guard let self = self else {
                    return
                }
//                self.subviews.forEach{ $0.removeFromSuperview() }
                self.floatingLabel.removeFromSuperview()
                self.setNeedsDisplay()
            }
            self.placeholder = self._placeholder
        }
//        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func addViewPasswordButton() {
        self.button.setImage(UIImage(named: "ic_reveal"), for: .normal)
        self.button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.button.frame = CGRect(x: 0, y: 16, width: 22, height: 16)
        self.button.clipsToBounds = true
        self.rightView = self.button
        self.rightViewMode = .always
        self.button.addTarget(self, action: #selector(self.enablePasswordVisibilityToggle), for: .touchUpInside)
    }
    
    func addImage(image: UIImage){
        
        self.imageView.image = image
        self.imageView.frame = CGRect(x: 20, y: 0, width: 20, height: 20)
        self.imageView.translatesAutoresizingMaskIntoConstraints = true
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        
        DispatchQueue.main.async {
            self.leftView = self.imageView
            self.leftViewMode = .always
        }
        
    }
    
    @objc func enablePasswordVisibilityToggle() {
        isSecureTextEntry.toggle()
        if isSecureTextEntry {
            self.button.setImage(UIImage(named: "ic_show"), for: .normal)
        }else{
            self.button.setImage(UIImage(named: "ic_hide"), for: .normal)
        }
    }
}

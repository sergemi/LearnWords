//
//  PopupViewController.swift
//  LearnWords
//
//  Created by sergemi on 15.02.2023.
//

import UIKit

protocol PopupViewControllerDelegate {
    func closePopup()
}

class PopupViewController: UIViewController, PopupViewControllerDelegate {
    weak var parentVC: BasePopupDelegate? = nil
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundCancelBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var popupContainer: UIView!
    
    private weak var childVC: UIViewController?
    
    init (vc: PopupChildViewController?, parentVC: BasePopupDelegate?) {
        super.init(nibName: "PopupViewController", bundle: Bundle.main)
        
        self.parentVC = parentVC
        childVC = vc
        vc?.popupDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func onClose(_ sender: Any) {
        closePopup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.alpha = 0.5
        
        guard let childVC = childVC else {
            fatalError()
        }
        popupContainer.addSubview(childVC.view)
        
        self.addChild(childVC)
        childVC.view.translatesAutoresizingMaskIntoConstraints = false
        childVC.didMove(toParent: self)
        
        guard let childView = childVC.view, let parentView = self.view else {
            fatalError()
        }
        childView.translatesAutoresizingMaskIntoConstraints = false
        let views = ["view": parentView, "childView": childView]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterY, metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: views)
        parentView.addConstraints(horizontalConstraints)
        parentView.addConstraints(verticalConstraints)
        
        view.layoutIfNeeded()
    }
    
    func closePopup() {
        parentVC?.closePopup()
    }
}

class PopupChildViewController: UIViewController {
    var popupDelegate: PopupViewControllerDelegate? = nil
}

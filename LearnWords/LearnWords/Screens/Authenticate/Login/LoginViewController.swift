//
//  LoginViewController.swift
//  LearnWords
//
//  Created by sergemi on 05.04.2024.
//

import UIKit

class LoginViewController: BaseViewController {
    var model = LoginViewModel()
    
    weak var authenticateCoordinator: AuthenticateProtocol? {
        get {
            return model.authenticateCoordinator
        }
        set {
            model.authenticateCoordinator = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    
    // MARK: - BaseViewController
    override func bindUI() {
        
    }

}

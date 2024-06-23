//
//  LoginViewController.swift
//  LearnWords
//
//  Created by sergemi on 05.04.2024.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

final class LoginViewController: BaseViewController {
    private var viewModel: LoginViewModel?
    
    @IBOutlet weak var GoogleButton: GIDSignInButton!
    
    @IBOutlet weak var loginTF: CustomTextField!
    @IBOutlet weak var passwordTF: CustomTextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    convenience init(viewModel: LoginViewModel) {
        self.init(nibName: String(describing: "LoginViewController"), bundle: nil)
        self.viewModel = viewModel
    }
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.showErrorDelegate = self
        navigationItem.hidesBackButton = true
    }

    
    // MARK: - BaseViewController
    override func bindUI() {
        guard let viewModel = viewModel else {
            return
        }
        _ = viewModel.title.subscribe(onNext: { [weak self] value in
            guard let value = value else {
                return
            }
            self?.title = value
        }).disposed(by: disposeBag)
        
        
        _ = viewModel.loginPlaceholder.subscribe(onNext: { [weak self] value in
            guard let value = value else {
                return
            }
            self?.loginTF._placeholder = value
            
        }).disposed(by: disposeBag)
        
        _ = viewModel.passwordPlaceholder.subscribe(onNext: { [weak self] value in
            guard let value = value else {
                return
            }
            self?.passwordTF._placeholder = value
            
        }).disposed(by: disposeBag)
        
        _ = viewModel.loginBtnCaption.subscribe(onNext: { [weak self] value in
            guard let value = value else {
                return
            }
            self?.loginBtn.setTitle(value)
            
        }).disposed(by: disposeBag)
        
        _ = viewModel.signUpBtnCaption.subscribe(onNext: { [weak self] value in
            guard let value = value else {
                return
            }
            self?.signUpBtn.setTitle(value)
            
        }).disposed(by: disposeBag)
        
        loginBtn.rx.tap.bind(to: (viewModel.loginBtnObserver)).disposed(by: self.disposeBag)
        
        signUpBtn.rx.tap.bind(to: (viewModel.signUpBtnObserver)).disposed(by: self.disposeBag)
        
        (loginTF.rx.text <-> viewModel.email).disposed(by: disposeBag)
        (passwordTF.rx.text <-> viewModel.password).disposed(by: disposeBag)
    }

}

//
//  SignUpViewController.swift
//  LearnWords
//
//  Created by sergemi on 07.04.2024.
//

import UIKit

class SignUpViewController: BaseViewController {
    var viewModel = SignUpViewModel()
    
    weak var authenticateCoordinator: AuthenticateProtocol? {
        get {
            return viewModel.authenticateCoordinator
        }
        set {
            viewModel.authenticateCoordinator = newValue
        }
    }
    
    @IBOutlet weak var loginTF: CustomTextField!
    @IBOutlet weak var password1TF: CustomTextField!
    @IBOutlet weak var password2TF: CustomTextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func bindUI() {
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
        
        _ = viewModel.password1Placeholder.subscribe(onNext: { [weak self] value in
            guard let value = value else {
                return
            }
            self?.password1TF._placeholder = value
            
        }).disposed(by: disposeBag)
        
        _ = viewModel.password2Placeholder.subscribe(onNext: { [weak self] value in
            guard let value = value else {
                return
            }
            self?.password2TF._placeholder = value
            
        }).disposed(by: disposeBag)
        
        _ = viewModel.signUpBtnCaption.subscribe(onNext: { [weak self] value in
            guard let value = value else {
                return
            }
            self?.signUpBtn.setTitle(value)
            
        }).disposed(by: disposeBag)
        
        signUpBtn.rx.tap.bind(to: (viewModel.signUpBtnObserver)).disposed(by: self.disposeBag)
        
        (loginTF.rx.text <-> viewModel.email).disposed(by: disposeBag)
        (password1TF.rx.text <-> viewModel.password1).disposed(by: disposeBag)
        (password2TF.rx.text <-> viewModel.password2).disposed(by: disposeBag)
    }
    

}

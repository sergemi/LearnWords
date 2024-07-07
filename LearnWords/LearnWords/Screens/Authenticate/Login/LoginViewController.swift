//
//  LoginViewController.swift
//  LearnWords
//
//  Created by sergemi on 05.04.2024.
//

import UIKit
import FirebaseCore // ?
import FirebaseAuth
import GoogleSignIn // ?

final class LoginViewController: BaseViewController {
    private var viewModel: LoginViewModel?
    
    @IBOutlet weak var googleBtn: GIDSignInButton!
    
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
    
    
    @IBAction func onGoogleLogin(_ sender: Any) {
        log.method()
//        viewModel?.onGoogleLogin()
//        return
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
          guard error == nil else {
              return // todo
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
              return // todo
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in

              print("+++")
            }

            print("+++")
          // ...
        }
        
        print("!!!")
        /*
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { authentication, error in
                        if let error = error {
                            print("There is an error signing the user in ==> \(error)")
                            return
                        }
                        guard let user = authentication?.user, let idToken = user.idToken?.tokenString else { return }
                        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
                        
                    Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                            if error != nil {
                                print(error ?? "0")
                            } else {
                                print("Cool!!!")
//                                self.email = authResult?.user.email
//                                let name = user.profile?.name
//                                
//                     
//                                ProgressHUD.show("Wait ,Loading...")
//                                
//                              //present tab bar
//                                tabManager(homeScreenVC)
                                
                            }
                        }
                    }
         */
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

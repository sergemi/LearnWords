//
//  BaseViewController.swift
//  LearnWords
//
//  Created by sergemi on 09.02.2021.
//

import RxCocoa
import RxSwift
import UIKit

protocol BasePopupDelegate: AnyObject {
    func showPopup(_ popup: PopupChildViewController)
    func closePopup()
}

protocol ShowErrorProtocol: AnyObject {
    typealias ErrorCompletion = () -> Void
    
    func showError(_ message: String, controlls: [UIControl]?)
    func hideErrors()
    func errorAllert(_ message: String, completion: ErrorCompletion?)
    func errorAlert(_ error: Error, completion: ErrorCompletion?)
}

extension ShowErrorProtocol {
    func showError(_ message: String) {
        showError(message, controlls: [])
    }
    
    func errorAllert(_ message: String) {
        errorAllert(message, completion: nil)
    }
    
    func errorAlert(_ error: Error) {
        errorAlert(error, completion: nil)
    }
}

class BaseViewController: UIViewController, ShowErrorProtocol {
    let disposeBag = DisposeBag()
    let keyboardObserver = KeyboardObserver()
    
    var popupVC: PopupViewController? = nil
    // MARK: - UIViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        print("viewDidLoad" + String(describing: self))
        bindUI()
    }
    
    deinit {
        print("deinit " + String(describing: self))
    }

    func bindUI() {
        fatalError("This method should be overriden in the child of the BaseViewController")
    }
    
    // MARK: - ShowErrorProtocol
    func showError(_ message: String, controlls: [UIControl]? = nil) {
        print("Error: \(message)")
    }
    
    func showError(_ message: String) {
        showError(message, controlls: nil)
    }
    
    func hideErrors() {}
    
    func errorAllert(_ message: String, completion: ErrorCompletion? = nil) {
        
        showAlert(title: "Error", message: message)
    }
    func errorAlert(_ error: Error, completion: ErrorCompletion? = nil) {
        let msg = error.localizedDescription ?? "Unknown error"
        errorAllert(msg, completion: completion)
    }
    
//    func errorAllert(_ message: String, completion: ErrorCompletion? = nil) {
//        print("!!!")
//    }
//
//    func errorAlert(_ error: Error, completion: ErrorCompletion? = nil) {
//        print("!!!")
//    }
    
    func startActivity() {
    }
    
    func stopActivity() {
        
    }

}

// MARK: - Keyboard

extension BaseViewController {
    func handleKeyboard(scrollView: UIScrollView, offset: CGFloat = 0.0) {
        keyboardObserver.willShow
            .observe(on: MainScheduler.instance)
            .subscribe { keyboardInfo in
                guard let height = keyboardInfo.element?.frameEnd.height else {
                    return
                }
                let newOffset = CGPoint(x: 0, y: height - offset)

                guard newOffset.y > 0.0, abs(scrollView.contentOffset.y - newOffset.y) > (0.3 * scrollView.contentOffset.y) else {
                    return
                }
                UIView.animate(withDuration: 0.25) {
                    scrollView.contentOffset = CGPoint(x: 0, y: height - offset)
                }
            }
            .disposed(by: disposeBag)

        keyboardObserver.willHide
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                UIView.animate(withDuration: 0.25) {
                    scrollView.contentOffset = CGPoint.zero
                }
            }
            .disposed(by: disposeBag)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.globalDismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func globalDismissKeyboard() {
        hideErrors()
        view.endEditing(true)
    }
}

extension BaseViewController: BasePopupDelegate {
    func showPopup(_ popup: PopupChildViewController) {
        popupVC = PopupViewController(vc: popup, parentVC: self)
        guard let popupVC = popupVC else {
            return
        }
        present(popupVC, animated: true)
    }
    
    func closePopup() {
        dismiss(animated: true)
        popupVC = nil
    }
}

extension BaseViewController {
    func addBackBtn(movetoroot: Bool = false) {
//        let backBtn = UIBarButtonItem(title: "<", style: .plain, target: nil, action: nil)
        let backBtn = UIBarButtonItem(image: UIImage(named: "arrow_left"), style: .plain, target: self, action: #selector(ncPop))
        
        self.navigationItem.leftBarButtonItem = backBtn
    }
    
    func removeBackBtn() {
        self.navigationItem.leftBarButtonItem = nil
    }
    
    @objc func ncPop() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func ncPopToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}

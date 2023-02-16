//
//  KeyboardObserver.swift
//  LearnWords
//
//  Created by sergemi on 05.02.2023.
//

import Foundation
import RxSwift
import RxCocoa

public final class KeyboardObserver {
    
    public struct KeyboardInfo {

        public let frameEnd: CGRect
        
        init(notification: Notification) {
            let userInfo = notification.userInfo as? [String: Any]
            if let keyboardFrame: NSValue = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                frameEnd = keyboardRectangle
            } else {
                frameEnd = CGRect()
            }
        }
    }
    
    public let willChangeFrame = PublishSubject<KeyboardInfo>()
    public let didChangeFrame = PublishSubject<KeyboardInfo>()
    
    public let willShow = PublishSubject<KeyboardInfo>()
    public let didShow = PublishSubject<KeyboardInfo>()
    public let willHide = PublishSubject<KeyboardInfo>()
    public let didHide = PublishSubject<KeyboardInfo>()
    
    public init() {
        
        NotificationCenter.default
            .rx.notification(UIResponder.keyboardWillChangeFrameNotification)
            .map { KeyboardInfo(notification: $0) }
            .bind(to: self.willChangeFrame)
            .disposed(by: disposeBag)
        
        NotificationCenter.default
            .rx.notification(UIResponder.keyboardDidChangeFrameNotification)
            .map { KeyboardInfo(notification: $0) }
            .bind(to: self.didChangeFrame)
            .disposed(by: disposeBag)
        
        NotificationCenter.default
            .rx.notification(UIResponder.keyboardWillShowNotification)
            .map { KeyboardInfo(notification: $0) }
            .bind(to: self.willShow)
            .disposed(by: disposeBag)
        
        NotificationCenter.default
            .rx.notification(UIResponder.keyboardDidShowNotification)
            .map { KeyboardInfo(notification: $0) }
            .bind(to: self.didShow)
            .disposed(by: disposeBag)
        
        NotificationCenter.default
            .rx.notification(UIResponder.keyboardWillHideNotification)
            .map { KeyboardInfo(notification: $0) }
            .bind(to: self.willHide)
            .disposed(by: disposeBag)
        
        NotificationCenter.default
            .rx.notification(UIResponder.keyboardDidHideNotification)
            .map { KeyboardInfo(notification: $0) }
            .bind(to: self.didHide)
            .disposed(by: disposeBag)
    }
    
    private let disposeBag = DisposeBag()
}

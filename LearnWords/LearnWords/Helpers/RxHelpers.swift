//
//  RxHelpers.swift
//  LearnWords
//
//  Created by sergemi on 21.02.2023.
//

import UIKit
import RxCocoa
import RxSwift

infix operator <-> : DefaultPrecedence

func <-><T> (property: ControlProperty<T>, relay: BehaviorRelay<T>) -> Disposable {
    let bindToUIDisposable = relay.bind(to: property)
    let bindToRelay = property
        .subscribe(onNext: { n in
            relay.accept(n)
        }, onCompleted:  {
            bindToUIDisposable.dispose()
        })

    return Disposables.create(bindToUIDisposable, bindToRelay)
}


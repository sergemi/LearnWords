//
//  BaseStatViewController.swift
//  LearnWords
//
//  Created by sergemi on 17.02.2023.
//

import UIKit
import RxCocoa
import RxSwift

class BaseStatViewController: BaseViewController {
    var model = BaseStatViewModel()
    
    weak var statCoordinator: StatCoordinatorProtocol? {
        get {
            return model.statCoordinator
        }
        set {
            model.statCoordinator = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func bindUI() {
        log.method()
    }

}

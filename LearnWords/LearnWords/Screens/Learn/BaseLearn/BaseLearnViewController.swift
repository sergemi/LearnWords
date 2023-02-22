//
//  BaseLearnViewController.swift
//  LearnWords
//
//  Created by sergemi on 17.02.2023.
//

import UIKit
import RxCocoa
import RxSwift

class BaseLearnViewController: BaseViewController {
    
    var model = BaseLearnViewModel()
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var newBtn: UIButton!
    
    weak var learnCoordinator: LearnCoordinatorProtocol? {
        get {
            return model.learnCoordinator
        }
        set {
            model.learnCoordinator = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func bindUI() {
        log.method()
        
        continueBtn.rx.tap.bind(to: model.continueBtnObserver).disposed(by: disposeBag)
        newBtn.rx.tap.bind(to: model.newBtnObserver).disposed(by: disposeBag)
    }
    
    func setupUI() {
        continueBtn.setTitle("Learn.BaseLearn.Continue".localized())
        newBtn.setTitle("Learn.BaseLearn.New".localized())
    }
}

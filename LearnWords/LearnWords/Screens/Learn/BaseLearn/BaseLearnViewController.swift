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
    
    weak var learnCoordinator: LearnCoordinatorProtocl? {
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
        bindUI()
    }
    
    override func bindUI() {
        log.method()
    }
    
    func setupUI() {
        continueBtn.setTitle("Learn.BaseLearn.Continue".localized())
        newBtn.setTitle("Learn.BaseLearn.New".localized())
    }
}

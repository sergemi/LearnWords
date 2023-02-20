//
//  UniversalTableViewController.swift
//  LearnWords
//
//  Created by sergemi on 19.02.2023.
//

import UIKit
import RxCocoa
import RxSwift

class UniversalTableViewController: BaseViewController {
    
    var viewModel: UniversalTableViewModel? = nil
    
    convenience init(viewModel: UniversalTableViewModel) {
        self.init(nibName: String(describing: "UniversalTableViewController"), bundle: nil)
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindUI()
    }
    
    override func bindUI() {
        log.method()
        
        _ = viewModel?.name.subscribe(onNext: { [weak self] value in
            guard let value = value else {
                return
            }
            self?.title = value
        }).disposed(by: disposeBag)
    }
    
    func setupUI() {
//        continueBtn.setTitle("Learn.BaseLearn.Continue".localized())
//        newBtn.setTitle("Learn.BaseLearn.New".localized())
    }

}

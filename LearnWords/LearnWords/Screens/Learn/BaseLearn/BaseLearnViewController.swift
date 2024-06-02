//
//  BaseLearnViewController.swift
//  LearnWords
//
//  Created by sergemi on 17.02.2023.
//

import UIKit
import RxCocoa
import RxSwift

final class BaseLearnViewController: BaseViewController {
    
    private var viewModel: BaseLearnViewModel?
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var newBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    convenience init(viewModel: BaseLearnViewModel) {
        self.init(nibName: String(describing: "BaseLearnViewController"), bundle: nil)
        self.viewModel = viewModel
    }
    
    override func bindUI() {
        log.method()
        guard let viewModel = viewModel else {
            return
        }
        
        continueBtn.rx.tap.bind(to: viewModel.continueBtnObserver).disposed(by: disposeBag)
        newBtn.rx.tap.bind(to: viewModel.newBtnObserver).disposed(by: disposeBag)
    }
    
    func setupUI() {
        continueBtn.setTitle("Learn.BaseLearn.Continue".localized())
        newBtn.setTitle("Learn.BaseLearn.New".localized())
    }
}

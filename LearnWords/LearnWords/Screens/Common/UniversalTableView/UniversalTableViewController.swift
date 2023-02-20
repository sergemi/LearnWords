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
    
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var tableHeaderLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actionSelectedBtn: UIButton!
    
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
        
        _ = viewModel?.details.subscribe(onNext: {[weak self] value in
            self?.descriptionLbl.text = value
        }).disposed(by: disposeBag)
        
        _ = viewModel?.tableHeader.subscribe(onNext: {[weak self] value in
            self?.tableHeaderLbl.text = value
        }).disposed(by: disposeBag)
        
        _ = viewModel?.hasActionAllBtn.subscribe(onNext: {[weak self] value in
            var isVisible = value == true
            self?.actionSelectedBtn.isHidden = !isVisible
        }).disposed(by: disposeBag)
    }
    
    func setupUI() {
//        continueBtn.setTitle("Learn.BaseLearn.Continue".localized())
//        newBtn.setTitle("Learn.BaseLearn.New".localized())
    }

}

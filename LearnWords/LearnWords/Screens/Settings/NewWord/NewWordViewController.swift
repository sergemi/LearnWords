//
//  NewWordViewController.swift
//  LearnWords
//
//  Created by sergemi on 23.02.2023.
//

import UIKit
import RxCocoa
import RxSwift

class NewWordViewController: BaseViewController {
    var viewModel: NewWordViewModel? = nil
    let rightBtn = UIBarButtonItem(title: "rightBtn", style: .plain, target: nil, action: nil)
    
    @IBOutlet weak var targetTField: CustomTextField!
    @IBOutlet weak var pronounceTField: CustomTextField!
    @IBOutlet weak var translateTField: CustomTextField!
    @IBOutlet weak var notesTView: UITextView!
    
    convenience init(viewModel: NewWordViewModel) {
        self.init(nibName: String(describing: "NewWordViewController"), bundle: nil)
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func bindUI() {
        guard let viewModel = viewModel else {
            return
        }
        
        rightBtn.rx.tap.bind(to: (viewModel.rightBtnObserver)).disposed(by: self.disposeBag)
        
        _ = viewModel.title.subscribe(onNext: { [weak self] value in
            guard let value = value else {
                return
            }
            self?.title = value
        }).disposed(by: disposeBag)
        
        (targetTField.rx.text <-> viewModel.target).disposed(by: disposeBag)
        (pronounceTField.rx.text <-> viewModel.pronounce).disposed(by: disposeBag)
        (translateTField.rx.text <-> viewModel.translate).disposed(by: disposeBag)
        (notesTView.rx.text <-> viewModel.notes).disposed(by: disposeBag)
        
        _ = viewModel.rightBarBtnCaption.subscribe(onNext: {[weak self] value in
            self?.rightBtn.title = value
        }).disposed(by: disposeBag)
        
        _ = viewModel.haveRightBarBtn.subscribe(onNext: { [weak self] value in
            guard let self = self else {
                return
            }
            if value == true {
                self.navigationItem.rightBarButtonItem = self.rightBtn
            }
            else {
                self.navigationItem.rightBarButtonItem = nil
            }
        }).disposed(by: disposeBag)
    }
    
    fileprivate func setupUI() {
        targetTField.placeholder = "Settings.NewWord.TargetPlaceholder".localized()
        pronounceTField.placeholder = "Settings.NewWord.PronouncePlaceholder".localized()
        translateTField.placeholder = "Settings.NewWord.TranslatePlaceholder".localized()
//        notesTView.placeholder = "Settings.NewWord.TargetPlaceholder".localized()
        self.addBackBtn()
    }
}

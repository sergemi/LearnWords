//
//  SettingsMainMenuViewController.swift
//  LearnWords
//
//  Created by sergemi on 16.02.2023.
//

import UIKit
import RxCocoa
import RxSwift

final class SettingsMainMenuViewController: BaseViewController {
    private var viewModel: SettingsMainMenuViewModel?
    
    @IBOutlet weak var setupSystemlBtn: UIButton!
    @IBOutlet weak var editWordsBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    
    convenience init(viewModel: SettingsMainMenuViewModel) {
        self.init(nibName: String(describing: "SettingsMainMenuViewController"), bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func bindUI() {
        log.method()
        guard let viewModel = viewModel else {
            return
        }
        
        setupSystemlBtn.rx.tap.bind(to: viewModel.localBaseBtnObserver).disposed(by: disposeBag)
        
        editWordsBtn.rx.tap.bind(to: viewModel.editWordsBtnObserver).disposed(by: disposeBag)
        
        logoutBtn.rx.tap.bind(to: viewModel.logoutBtnObserver).disposed(by: disposeBag)
    }
    
    func setupUI() {
        setupSystemlBtn.setTitle("Settings.MainMenu.SystemSettings".localized())
        editWordsBtn.setTitle("Settings.MainMenu.EditWords".localized())
    }
}

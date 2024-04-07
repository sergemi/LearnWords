//
//  SettingsMainMenuViewController.swift
//  LearnWords
//
//  Created by sergemi on 16.02.2023.
//

import UIKit
import RxCocoa
import RxSwift

class SettingsMainMenuViewController: BaseViewController {
    var model = SettingsMainMenuViewModel()
    
    weak var settingsCoordinator: SettingsCoordinatorProtocol? {
        get {
            return model.settingsCoordinator
        }
        set {
            model.settingsCoordinator = newValue
        }
    }
    
    @IBOutlet weak var setupSystemlBtn: UIButton!
    @IBOutlet weak var editWordsBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func bindUI() {
        log.method()
        
        setupSystemlBtn.rx.tap.bind(to: model.localBaseBtnObserver).disposed(by: disposeBag)
        
        editWordsBtn.rx.tap.bind(to: model.editWordsBtnObserver).disposed(by: disposeBag)
        
        logoutBtn.rx.tap.bind(to: model.logoutBtnObserver).disposed(by: disposeBag)
    }
    
    func setupUI() {
        setupSystemlBtn.setTitle("Settings.MainMenu.SystemSettings".localized())
        editWordsBtn.setTitle("Settings.MainMenu.EditWords".localized())
    }
}

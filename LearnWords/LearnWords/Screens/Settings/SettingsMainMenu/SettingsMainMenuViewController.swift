//
//  SettingsMainMenuViewController.swift
//  LearnWords
//
//  Created by sergemi on 16.02.2023.
//

import UIKit

class SettingsMainMenuViewController: BaseViewController {
    var model = SettingsMainMenuViewModel()
    
    weak var settingsCoordinator: SettingsCoordinatorProtocl? {
        get {
            return model.settingsCoordinator
        }
        set {
            model.settingsCoordinator = newValue
        }
    }
    
    @IBOutlet weak var setupLocalBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bindUI() {
        log.method()
    }
}

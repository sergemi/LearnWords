//
//  BaseStatViewController.swift
//  LearnWords
//
//  Created by sergemi on 17.02.2023.
//

import UIKit
import RxCocoa
import RxSwift

final class BaseStatViewController: BaseViewController {
    private var viewModel: BaseStatViewModel?
    
    convenience init(viewModel: BaseStatViewModel) {
        self.init(nibName: String(describing: "BaseStatViewController"), bundle: nil)
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func bindUI() {
        log.method()
    }

}

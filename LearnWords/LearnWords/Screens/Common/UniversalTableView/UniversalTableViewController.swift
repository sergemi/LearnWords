//
//  UniversalTableViewController.swift
//  LearnWords
//
//  Created by sergemi on 19.02.2023.
//

import UIKit
import RxCocoa
import RxSwift

class UniversalTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var viewModel: UniversalTableViewModel? = nil
    
    let rightBtn = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: nil, action: nil)
    
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
    }
    
    fileprivate func setupTableView() {
        let cellNib = UINib(nibName: "DataTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "DataTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        log.method()
    }
    
    override func bindUI() {
        log.method()
        
        guard let viewModel2 = viewModel else {
            return
        }
        
        rightBtn.rx.tap.bind(to: (viewModel2.addBtnObserver)).disposed(by: self.disposeBag)
        
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
        
        _ = viewModel?.rows.subscribe(onNext: {[weak self] value in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        _ = viewModel?.canAdd.subscribe(onNext: { [weak self] value in
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
    
    func setupUI() {
        setupTableView()
//        continueBtn.setTitle("Learn.BaseLearn.Continue".localized())
//        newBtn.setTitle("Learn.BaseLearn.New".localized())
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = viewModel?.rows.value else {
            return 0
        }
        
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DataTableViewCell", for: indexPath) as! DataTableViewCell
        guard let rows = viewModel?.rows.value else {
            return cell
        }
        let cellModel = rows[indexPath.row]
        cell.setup(model: cellModel)
        
        return cell
    }
}

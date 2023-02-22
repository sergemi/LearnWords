//
//  UniversalTableViewController.swift
//  LearnWords
//
//  Created by sergemi on 19.02.2023.
//

import UIKit
import RxCocoa
import RxSwift

class UniversalTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var viewModel: UniversalTableViewModel? = nil
    
//    let rightBtn = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: nil, action: nil)
    let rightBtn = UIBarButtonItem(title: "rightBtn", style: .plain, target: nil, action: nil)
    
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var tableHeaderLbl: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actionSelectedBtn: UIButton!
    
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    convenience init(viewModel: UniversalTableViewModel) {
        self.init(nibName: String(describing: "UniversalTableViewController"), bundle: nil)
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel?.reloadTableData()
    }
    
    fileprivate func setupTableView() {
        let cellNib = UINib(nibName: "DataTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "DataTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.allowsMultipleSelection = false
        
        log.method()
    }
    
    override func bindUI() {
        log.method()
        
        guard let viewModel = viewModel else {
            return
        }
        
        rightBtn.rx.tap.bind(to: (viewModel.rightBtnObserver)).disposed(by: self.disposeBag)
        addBtn.rx.tap.bind(to: (viewModel.addBtnObserver)).disposed(by: self.disposeBag)
        
        _ = viewModel.title.subscribe(onNext: { [weak self] value in
            guard let value = value else {
                return
            }
            self?.title = value
        }).disposed(by: disposeBag)
        
        _ = viewModel.haveBackBarBtn.subscribe(onNext: { [weak self] value in
            if value {
                self?.addBackBtn()
            }
        }).disposed(by: disposeBag)
        
        (nameTextField.rx.text <-> viewModel.name).disposed(by: disposeBag)
        (descriptionTextView.rx.text <-> viewModel.details).disposed(by: disposeBag)
        _ = viewModel.namePlaceholder.subscribe(onNext: { [weak self] value in
            guard let value = value else {
                return
            }
            self?.nameTextField.placeholder = value
            self?.nameTextField._placeholder = value
            
        }).disposed(by: disposeBag)
        
        _ = viewModel.details.subscribe(onNext: {[weak self] value in
            self?.descriptionLbl.text = value
        }).disposed(by: disposeBag)
        
        _ = viewModel.tableHeader.subscribe(onNext: {[weak self] value in
            self?.tableHeaderLbl.text = value
        }).disposed(by: disposeBag)
        
        _ = viewModel.canAdd.subscribe(onNext: {[weak self] value in
            let isVisible = value == true
            self?.addBtn.isHidden = !isVisible
        }).disposed(by: disposeBag)
        
        _ = viewModel.addBtnCaption.subscribe(onNext: {[weak self] value in
            self?.addBtn.setTitle(value)
        }).disposed(by: disposeBag)
        
        _ = viewModel.rightBarBtnCaption.subscribe(onNext: {[weak self] value in
            self?.rightBtn.title = value
        }).disposed(by: disposeBag)
        
        _ = viewModel.hasActionAllBtn.subscribe(onNext: {[weak self] value in
            let isVisible = value == true
            self?.actionSelectedBtn.isHidden = !isVisible
        }).disposed(by: disposeBag)
        
        _ = viewModel.rows.subscribe(onNext: {[weak self] value in
            self?.tableView.reloadData()
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
        
        _ = viewModel.canSelect.subscribe(onNext: {[weak self] value in
            self?.tableView.allowsSelection = value
        }).disposed(by: disposeBag)
        
        _ = viewModel.canEdit.subscribe(onNext: { [weak self] value in
            guard let self = self else {
                return
            }
            self.nameTextField.isHidden = !value
            self.descriptionTextView.isHidden = !value
            self.descriptionLbl.isHidden = value
        }).disposed(by: disposeBag)
    }
    
    func setupUI() {
        setupTableView()
        
        nameTextField.delegate = self
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
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.selectRow(index: indexPath.row)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return viewModel?.canDeleteRows.value == true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") {  [weak self] (contextualAction, view, boolValue) in
            guard let self = self, let viewModel = self.viewModel else { return }
            
//            self.showAlert(title: "title", message: "message", callback: {_ in
//                print("callback")
//            })
            
            self.showYesNoAlert(title: viewModel.deleteLineAlertTitle,
                                message: viewModel.deleteLineAlertMessage,
                                yesTitle: viewModel.deleteLineAlertYesTitle,
                                noTitle: viewModel.deleteLineAlertNoTitle,
                                yesCallback: { _ in
                self.viewModel?.deleteRow(index: indexPath.row)
            })
            
//            self.viewModel?.deleteRow(index: indexPath.row)
            
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
}

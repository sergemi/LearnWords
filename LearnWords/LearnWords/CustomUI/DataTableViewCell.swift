//
//  DataTableViewCell.swift
//  LearnWords
//
//  Created by sergemi on 17.02.2023.
//

import UIKit

class DataTableViewCell: UITableViewCell {
    @IBOutlet weak var checkbox: UICheckbox!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var percentLbl: UILabel!
    @IBOutlet weak var arrowRight: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(checkboxState: CheckBoxState, title: String, percent: Int?, showArrow: Bool) {
        switch checkboxState {
        case .hiden:
            checkbox.isHidden = true
            
        case .checked:
            checkbox.isHidden = false
            checkbox.select(true)
            
        case .empty:
            checkbox.isHidden = false
            checkbox.select(false)
        }
        
        titleLbl.text = title
        
        if let percent = percent {
            percentLbl.text = "\(percent) %"
            percentLbl.isHidden = false
        }
        else {
            percentLbl.isHidden = true
        }
        
        arrowRight.isHidden = !showArrow
    }
    
    func setup(model: ModelTableViewCell) {
        setup(checkboxState: model.checkbox,
              title: model.title,
              percent: model.percent,
              showArrow: model.showArrow)
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}

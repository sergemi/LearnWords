//
//  ModelTableViewCell.swift
//  LearnWords
//
//  Created by sergemi on 20.02.2023.
//

import Foundation

enum CheckBoxState: Int {
    case hiden = 0
    case checked
    case empty
}

struct ModelTableViewCell {
    var checkbox: CheckBoxState
    var title: String
    var percent: Int?
    var showArrow: Bool
}

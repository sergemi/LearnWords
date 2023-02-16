//
//  BaseViewFromNib.swift
//  LearnWords
//
//  Created by sergemi on 09.02.2021.
//

import UIKit

class BaseViewFromNib: UIView {
    private var contentView: UIView?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        addSubview(view)
        self.contentView = view
        setup()
    }

    func setup() {
        fatalError("Should be overriden in subclasses")
    }
}

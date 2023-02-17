//
//  String+localization.swift
//  LearnWord
//
//  Created by sergemi on 1y.02.2023.
//

import Foundation

extension String {
//    func localized(_ comment: String = "") -> String? {
//        let localizedString = NSLocalizedString(self, comment: "")
//        guard localizedString == self else {
//            return localizedString
//        }
//		return nil
//    }
    func localized(_ comment: String = "") -> String {
        let localizedString = NSLocalizedString(self, comment: "")
        guard localizedString == self else {
            return localizedString
        }
        return self
    }
}

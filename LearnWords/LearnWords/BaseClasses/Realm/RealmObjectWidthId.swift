//
//  RealmObjectWidthId.swift
//  LearnWords
//
//  Created by sergemi on 21.04.2024.
//

import Foundation
import RealmSwift

class RealmObjectWidthId: Object {
    @Persisted(primaryKey: true) var id: String
    override required init() {
        super.init()
    }
}

//
//  ModelModule_realm.swift
//  LearnWords
//
//  Created by sergemi on 21.02.2023.
//

import Foundation
import RealmSwift

class ModelModule_realm: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var details: String = ""
    @Persisted var topics: List<ModelTopic_realm>
}

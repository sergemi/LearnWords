//
//  ModelTopic_realm.swift
//  LearnWords
//
//  Created by sergemi on 21.02.2023.
//

import Foundation
import RealmSwift

class ModelTopic_realm: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var details: String = ""
    @Persisted var words: List<ModelLearnedWord_realm>
    @Persisted var availablesExercises: List<ModelExercise_realm>
}

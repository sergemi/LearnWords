//
//  ModelLearnedWord_realm.swift
//  LearnWords
//
//  Created by sergemi on 21.02.2023.
//

import Foundation
import RealmSwift

class ModelLearnedWord_realm: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var word: ModelWordPair_realm?
    @Persisted var exercises: List<ModelExercise_realm>
}

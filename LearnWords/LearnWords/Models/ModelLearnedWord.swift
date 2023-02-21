//
//  ModelLearnedWord.swift
//  LearnWords
//
//  Created by sergemi on 21.02.2023.
//

import Foundation
import RealmSwift

class ModelLearnedWord: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var word: ModelWordPair?
    @Persisted var exercises: List<ModelExercise>
}

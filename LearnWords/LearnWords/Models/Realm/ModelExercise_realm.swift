//
//  Exercise.swift
//  LearnWords
//
//  Created by sergemi on 21.02.2023.
//

import Foundation
import RealmSwift

enum exerciseType_realm: Int, PersistableEnum {
    case choseTranslate = 0
    case choseTranslateInverse
    case writeTranslate
    case writeTranslateInverse
    case swapLettersTranslate
    case swapLettersTranslateInverse
}

class ModelExercise_realm: EmbeddedObject {
    @Persisted var id: ObjectId
    @Persisted var type: exerciseType_realm = .choseTranslate
    @Persisted var maxScore: Int = 5
    @Persisted var correct: Int = 0
    @Persisted var incorrect: Int = 0
}

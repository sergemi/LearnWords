//
//  Exercise.swift
//  LearnWords
//
//  Created by sergemi on 21.02.2023.
//

import Foundation
import RealmSwift

enum exerciseType: Int, PersistableEnum {
    case choseTranslate = 0
    case choseTranslateInverse
    case writeTranslate
    case writeTranslateInverse
    case swapLettersTranslate
    case swapLettersTranslateInverse
}

class ModelExercise: EmbeddedObject {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var type: exerciseType = .choseTranslate
    @Persisted var maxScore: Int = 5
    @Persisted var correct: Int = 0
    @Persisted var incorrect: Int = 0
}

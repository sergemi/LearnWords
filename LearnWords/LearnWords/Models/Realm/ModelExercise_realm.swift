//
//  Exercise.swift
//  LearnWords
//
//  Created by sergemi on 21.02.2023.
//

import Foundation
import RealmSwift

enum ExerciseType_realm: String, PersistableEnum {
    case choseTranslate
    case choseTranslateInverse
    case writeTranslate
    case writeTranslateInverse
    case swapLettersTranslate
    case swapLettersTranslateInverse
}

extension ExerciseType_realm {
    init(model: ExerciseType) {
        self.init(rawValue: model.rawValue)!
    }
    
    var model: ExerciseType {
        return ExerciseType(rawValue: self.rawValue)!
    }
}

class ModelExercise_realm: EmbeddedObject {
    @Persisted var id: String
    @Persisted var type: ExerciseType_realm = .choseTranslate
    @Persisted var maxScore: Int = 5
    @Persisted var correct: Int = 0
    @Persisted var incorrect: Int = 0
}

extension ModelExercise_realm {
    convenience init(model: Exercise) {
        self.init()
        self.id = model.id
        self.type = ExerciseType_realm(model: model.type)
        self.maxScore = model.maxScore
        self.correct = model.correct
        self.incorrect = model.incorrect
    }
    
    var model: Exercise {
        var newModel = Exercise(id: self.id,
                                type: self.type.model,
                                maxScore: self.maxScore)
        newModel.correct = self.correct
        newModel.incorrect = self.incorrect
        
        return newModel
    }
}

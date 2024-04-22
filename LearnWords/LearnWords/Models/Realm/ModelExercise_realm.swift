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
    init(exerciseType: ExerciseType) {
        self.init(rawValue: exerciseType.rawValue)!
    }
    
    var exerciseType: ExerciseType {
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
    func updateFrom(exercise: Exercise) {
        self.type = ExerciseType_realm(exerciseType: exercise.type)
        self.maxScore = exercise.maxScore
        self.correct = exercise.correct
        self.incorrect = exercise.incorrect
    }
    
    convenience init(exercise: Exercise) {
        self.init()
        
        self.id = exercise.id
        updateFrom(exercise: exercise)
    }
    
    var exercise: Exercise {
        var newExercise = Exercise(id: self.id,
                                type: self.type.exerciseType,
                                maxScore: self.maxScore)
        newExercise.correct = self.correct
        newExercise.incorrect = self.incorrect
        
        return newExercise
    }
}

//
//  Exercise.swift
//  LearnWords
//
//  Created by sergemi on 11.04.2024.
//

import Foundation

enum ExerciseType: String {
    case choseTranslate
    case choseTranslateInverse
    case writeTranslate
    case writeTranslateInverse
    case swapLettersTranslate
    case swapLettersTranslateInverse
}

struct Exercise {
    let id: String
    
    var type: ExerciseType
    var maxScore: Int
    var correct: Int = 0
    var incorrect: Int = 0
    
    init(id: String, type: ExerciseType, maxScore: Int) {
        self.id = id
        self.type = type
        self.maxScore = maxScore
    }
    
    init(type: ExerciseType, maxScore: Int) {
        self.init(id: UUID().uuidString,
                  type: type,
                  maxScore: maxScore)
    }
}

extension Exercise: Equatable {}

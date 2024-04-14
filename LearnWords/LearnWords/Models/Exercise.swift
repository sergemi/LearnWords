//
//  Exercise.swift
//  LearnWords
//
//  Created by sergemi on 11.04.2024.
//

import Foundation

enum exerciseType: String {
    case choseTranslate
    case choseTranslateInverse
    case writeTranslate
    case writeTranslateInverse
    case swapLettersTranslate
    case swapLettersTranslateInverse
}

struct Exercise {
    let id: String
    
    var type: exerciseType
    var maxScore: Int
    var correct: Int = 0
    var incorrect: Int = 0
    
    init(id: String, type: exerciseType, maxScore: Int) {
        self.id = id
        self.type = type
        self.maxScore = maxScore
    }
    
    init(type: exerciseType, maxScore: Int) {
        self.init(id: UUID().uuidString,
                  type: type,
                  maxScore: maxScore)
    }
}

//
//  TopicPreload.swift
//  LearnWords
//
//  Created by sergemi on 28.04.2024.
//

import Foundation

struct TopicPreload {
    let id: String
    
    var name: String
    var details: String
    var wordsIds: [String]
    var exercises: [ExerciseType]
    
    init(id: String, name: String, details: String, wordsIds: [String], exercises: [ExerciseType]) {
        self.id = id
        self.name = name
        self.details = details
        self.wordsIds = wordsIds
        self.exercises = exercises
    }
    
//    init (name: String, details: String, words: [LearnedWord], exercises: [ExerciseType]) {
    init (name: String, details: String, wordsIds: [String], exercises: [ExerciseType]) {
        self.init(id: UUID().uuidString,
                  name: name,
                  details: details,
                  wordsIds: wordsIds,
                  exercises: exercises)
    }
    
    init() {
        self.init(name: "", details: "", wordsIds: [], exercises: [])
    }
}

extension TopicPreload: Equatable {}

//
//  Topic.swift
//  LearnWords
//
//  Created by sergemi on 11.04.2024.
//

import Foundation

struct Topic {
    let id: String
    
    var name: String
    var details: String
    var words: [LearnedWord]
    var exercises: [ExerciseType]
    
    init(id: String, name: String, details: String, words: [LearnedWord], exercises: [ExerciseType]) {
        self.id = id
        self.name = name
        self.details = details
        self.words = words
        self.exercises = exercises
    }
    
    init (name: String, details: String, words: [LearnedWord], exercises: [ExerciseType]) {
        self.init(id: UUID().uuidString,
                  name: name,
                  details: details,
                  words: words,
                  exercises: exercises)
    }
    
    init() {
        self.init(name: "", details: "", words: [], exercises: [])
    }
}

extension Topic: Equatable {}

extension Topic {
    var topicPreload:TopicPreload {
        let wordIds = words.map { $0.id }
        return TopicPreload(id: id,
                            name: name,
                            details: details,
                            wordsIds: wordIds,
                            exercises: exercises)
    }
    
    init (topicPreload: TopicPreload, words: [LearnedWord]) {
        self.init(id: topicPreload.id,
                  name: topicPreload.name,
                  details: topicPreload.details,
                  words: words,
                  exercises: topicPreload.exercises)
    }
}

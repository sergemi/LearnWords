//
//  LearnedWord.swift
//  LearnWords
//
//  Created by sergemi on 11.04.2024.
//

import Foundation

struct LearnedWord {
    let id: String
    
    var word: WordPair
    var exercises: [Exercise]
    
    init (word: WordPair, exercises: [Exercise]) {
        self.id = UUID().uuidString
        self.word = word
        self.exercises = exercises
    }
}

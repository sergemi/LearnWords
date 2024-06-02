//
//  LearnedWord.swift
//  LearnWords
//
//  Created by sergemi on 11.04.2024.
//

import Foundation

struct LearnedWord: Equatable, Codable {
    let id: String
    
    var word: WordPair
    var exercises: [Exercise]
    
    init (id: String, word: WordPair, exercises: [Exercise]) {
        self.id = id
        self.word = word
        self.exercises = exercises
    }
    
    init (word: WordPair, exercises: [Exercise]) {
        self.init(id: UUID().uuidString,
                  word: word,
                  exercises: exercises)
    }
    
    init() {
        self.init(word: WordPair(), exercises: [])
    }
    
    // MARK - Codable
    private enum CodingKeys: String, CodingKey {
        case id
        case word
        case exercises
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(word, forKey: .word)
        try container.encode(exercises, forKey: .exercises)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        word = try container.decode(WordPair.self, forKey: .word)
        exercises = try container.decodeIfPresent([Exercise].self, forKey: .exercises) ?? []
    }
}

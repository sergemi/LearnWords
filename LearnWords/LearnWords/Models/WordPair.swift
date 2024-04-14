//
//  WordPair.swift
//  LearnWords
//
//  Created by sergemi on 11.04.2024.
//

import Foundation

struct WordPair {
    let id: String
    
    var target: String
    var translate: String
    var pronounce: String
    var notes: String
    
    init(id: String, target: String, translate: String, pronounce: String, notes: String) {
        self.id = id
        self.target = target
        self.translate = translate
        self.pronounce = pronounce
        self.notes = notes
    }
    
    init (target: String, translate: String, pronounce: String, notes: String) {
        self.init(id: UUID().uuidString,
                  target: target,
                  translate: translate,
                  pronounce: pronounce,
                  notes: notes)
    }
}

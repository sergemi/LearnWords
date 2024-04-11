//
//  WordPair_realm.swift
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
    
    init(target: String, translate: String, pronounce: String, notes: String) {
        self.id = UUID().uuidString
        self.target = target
        self.translate = translate
        self.pronounce = pronounce
        self.notes = notes
    }
}

//
//  ModelWordPair_realm.swift
//  LearnWords
//
//  Created by sergemi on 21.02.2023.
//

import Foundation
import RealmSwift

class ModelWordPair_realm: RealmObjectWidthId {
    @Persisted var target: String = ""
    @Persisted var translate: String = ""
    @Persisted var pronounce: String = ""
    @Persisted var notes: String = ""
    
    required init() {
        super.init()
        
        id = UUID().uuidString
    }
}

extension ModelWordPair_realm {
    convenience init(wordPair: WordPair) {
        self.init()
        
        self.id = wordPair.id
        self.target = wordPair.target
        self.translate = wordPair.translate
        self.pronounce = wordPair.pronounce
        self.notes = wordPair.notes
    }
    
    var wordPair: WordPair {
        get {
            let newWordPair = WordPair(
                id: id,
                target: target,
                translate: translate,
                pronounce: pronounce,
                notes: notes)
            
            return newWordPair
        }
    }
}

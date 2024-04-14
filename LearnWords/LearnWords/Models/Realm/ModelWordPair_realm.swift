//
//  ModelWordPair_realm.swift
//  LearnWords
//
//  Created by sergemi on 21.02.2023.
//

import Foundation
import RealmSwift

class ModelWordPair_realm: Object {
//    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted(primaryKey: true) var id: String
    
    @Persisted var target: String = ""
    @Persisted var translate: String = ""
    @Persisted var pronounce: String = ""
    @Persisted var notes: String = ""
    
    override init() {
        super.init()
        
        id = UUID().uuidString
    }
}

extension ModelWordPair_realm {
    convenience init(model: WordPair) {
        self.init()
        
        self.id = model.id
        self.target = model.target
        self.translate = model.translate
        self.pronounce = model.pronounce
        self.notes = model.notes
    }
    
    var model: WordPair {
        get {
            let model = WordPair(target: target,
                     translate: translate,
                     pronounce: pronounce,
                     notes: notes)
            
            return model
        }
    }
}

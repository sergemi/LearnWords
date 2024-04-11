//
//  ModelWordPair.swift
//  LearnWords
//
//  Created by sergemi on 21.02.2023.
//

import Foundation
import RealmSwift

class ModelWordPair: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var target: String = ""
    @Persisted var translate: String = ""
    @Persisted var pronounce: String = ""
    @Persisted var notes: String = ""
}

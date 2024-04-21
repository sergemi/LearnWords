//
//  RealmHelpers.swift
//  LearnWords
//
//  Created by sergemi on 21.04.2024.
//

import Foundation
import RealmSwift

func getRealmObject<T:RealmObjectWidthId>(realm: Realm, objectType: T.Type, id: String) -> T? {
    
    let obj = realm.object(ofType: objectType, forPrimaryKey: id)
    return obj
}

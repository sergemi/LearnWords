//
//  Config.swift
//  LearnWords
//
//  Created by sergemi on 23.04.2024.
//

import Foundation
import RealmSwift

class Config {
    static let instance = Config()
    
    enum Mode {
        case release
        case unitTests
    }
    
    enum DataBaseType {
        case moc
        case firebase
        case realm
        case swiftData
        case rest
    }
    
    private init() {
    }
    
    var mode: Mode = .release
    var dataBaseType: DataBaseType = .moc
    
    private let realmFileNameRelease = "default"
    private let realmFileNameUnitTests = "UnitTests"
    private let firebaseFileNameRelease = "default"
    private let firebaseFileNameUnitTests = "UnitTests"
    
    lazy var realm: Realm = {
        let fileName = mode == .release ? realmFileNameRelease : realmFileNameUnitTests
        var config = Realm.Configuration.defaultConfiguration
        config.fileURL!.deleteLastPathComponent()
        config.fileURL!.appendPathComponent(fileName)
        config.fileURL!.appendPathExtension("realm")
        
        return try! Realm(configuration: config)
    }()
    
    lazy var dataManager: DataManager = {
        switch (dataBaseType) {
        case .firebase:
            return FirebaseDataManager(basePaht: firebaseBasePath)
            
        case .realm:
            return RealmDataManager(realm: realm)
         
            // TODO: implement rest types
        default:
            return MockDataManager.instance
        }
    }()
    
    var firebaseBasePath:String {
        switch(mode) {
        case .release:
            return firebaseFileNameRelease
            
        case .unitTests:
            return firebaseFileNameUnitTests
        }
    }
}

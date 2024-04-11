//
//  DataManagerTests.swift
//  LearnWordsTests
//
//  Created by sergemi on 11.04.2024.
//

import XCTest
@testable import LearnWords

final class DataManagerTests: XCTestCase {
    var authManager: AuthProtocol!
    var dataManager: DataManager!

    override func setUpWithError() throws {
        let mockAuthManager = MockAuthManager()
        MockAuthManager.userId = "mocUser1@gmail.com"
//        MockAuthManager.users["test@gmail.com"] = MockAuthManager.MockUser(email: "test@gmail.com", password: "qwerty")
        authManager = mockAuthManager
        
        dataManager = MockDataManager(authManager: authManager!)
    }

    override func tearDownWithError() throws {
        authManager = nil
        dataManager = nil
    }

    func testCorrectUserLoggedIn() {
        XCTAssertEqual("mocUser1@gmail.com", MockAuthManager.userId)
    }
    
    func testModules() {
        XCTAssertEqual(dataManager.modules.count, 0, "modules count now must be 0")
        
        guard let userId = MockAuthManager.userId else {
            XCTFail("userID sholdn't be nil ")
            return
        }
        
        let module1 = Module(name: "Module 1", details: "Details", topics: [], author: userId, isPublic: false)
        
        let addedModule = dataManager.addModule(module1)
        
        XCTAssertNotNil(addedModule, "Must return added module. Not nil")
        
        XCTAssertEqual(dataManager.modules.count, 1, "Now is 1 module for current user")
        
        guard var moduleToChange = addedModule else {
            return
        }
        moduleToChange.name = "Changed"
        
        guard let changedModule = dataManager.updateModule(moduleToChange) else {
            XCTFail("Change Module error")
            return
        }
        
        XCTAssertEqual(changedModule.name, "Changed")
        
        let module2 = Module(name: "Module 2", details: "Details 2", topics: [], author: userId, isPublic: false)
        
        let addedModule2 = dataManager.addModule(module2)
        
        XCTAssertEqual(dataManager.modules.count, 2, "Now is 2 modules for current user")
        
        // TODO: change user
        let deletedModule = dataManager.deleteModule(module1)
        
        XCTAssertEqual(dataManager.modules.count, 1, "Now is 1 module for current user")
    }

}

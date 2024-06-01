//
//  DataManagerTests.swift
//  LearnWordsTests
//
//  Created by sergemi on 11.04.2024.
//

import XCTest
@testable import LearnWords

final class DataManagerTests: XCTestCase {
    var dataManager: DataManager!

    override func setUpWithError() throws {
        let mockAuthManager = MockAuthManager()
        MockAuthManager.userId = "mocUser1@gmail.com"
        
        Config.instance.mode = .unitTests
        Config.instance.dataBaseType = .moc
        dataManager = Config.instance.dataManager
        
        Task {
            try await dataManager.reset()
        }
    }

    override func tearDownWithError() throws {
        dataManager = nil
    }

    func testCorrectUserLoggedIn() {
        XCTAssertEqual("mocUser1@gmail.com", MockAuthManager.userId)
    }
    
    // - MARK: Module tests
    func testAddModule() async throws {
        let startCount = try await dataManager.modules.count
        XCTAssertEqual(startCount, 0, "modules count must be 0 on init")
        
        let module = Module(name: "New module", details: "test", topics: [], author: "Tester", isPublic: true)
        
        try await dataManager.addModule(module)
        let afterAddCount = try await dataManager.modules.count
        
        XCTAssertEqual(afterAddCount, 1, "modules count must be 1")
    }
    
    func testGetModule() async throws {
        let module2add = Module(name: "New module", details: "test", topics: [], author: "Tester", isPublic: true)
        
        try await dataManager.addModule(module2add)
        
        let gettedModule = try await dataManager.module(id: module2add.id)
        
        XCTAssertEqual(module2add, gettedModule)
    }
    
    func testModuleNotFound() async throws {
        do {
            _ = try await dataManager.module(id: "wrong id")
            XCTFail("Expected error not thrown")
            
        }
        catch {
            XCTAssertEqual((error as? DataManagerError), .moduleNotFound)
        }
    }
    
    func testUpdateModule() async throws {
        let firstModule = Module(name: "First", details: "test", topics: [], author: "Tester", isPublic: true)
        
        let secondModule = Module(id:firstModule.id, name: "Second", details: "test", topics: [], author: "Tester", isPublic: true)
        
        try await dataManager.addModule(firstModule)
        try await dataManager.updateModule(secondModule)
        
        let resultModule = try await dataManager.module(id: secondModule.id)
        
        XCTAssertEqual(secondModule, resultModule)
        XCTAssertNotEqual(firstModule, resultModule)
    }
    
    func testUpdateModuleWrongId() async throws {
        let module = Module(name: "Module", details: "test", topics: [], author: "Tester", isPublic: true)
        do {
            _ = try await dataManager.updateModule(module)
            XCTFail("Expected error not thrown")
            
        }
        catch {
            XCTAssertEqual((error as? DataManagerError), .moduleNotFound)
        }
    }
    
    func testDeleteModule() async throws {
        let module = Module(id: "module id", name: "Module", details: "test", topics: [], author: "Tester", isPublic: true)
        
        try await dataManager.addModule(module)
        try await dataManager.deleteModule(id: module.id)
        let modulesCount = try await dataManager.modules.count
        XCTAssertEqual(modulesCount, 0)
    }
    
    func testDeleteModuleWrongId() async throws {
        do {
            _ = try await dataManager.deleteModule(id: "wrong id")
            XCTFail("Expected error not thrown")
            
        }
        catch {
            XCTAssertEqual((error as? DataManagerError), .moduleNotFound)
        }
    }
    
    // - MARK: Topic tests
    
    func testAddAndGetTopic() async throws {
        let topic1 = Topic(name: "topic 1", details: "topic details", words: [], exercises: [])
        
        try await dataManager.addTopic(topic1, moduleId: nil)
        
        let topic2 = try await dataManager.topic(id: topic1.id)
        
        XCTAssertEqual(topic1, topic2)
    }
    
    func testTopicNotFound() async throws {
        do {
            _ = try await dataManager.topic(id: "wrong id")
            XCTFail("Expected error not thrown")
            
        }
        catch {
            XCTAssertEqual((error as? DataManagerError), .topicNotFound)
        }
    }
    
    func testUpdateTopic() async throws {
        let topic1 = Topic(name: "topic 1", details: "topic details", words: [], exercises: [])
        
        let topic2 = Topic(id: topic1.id, name: "topic updated", details: "topic updated details", words: [], exercises: [])
        
        try await dataManager.addTopic(topic1, moduleId: nil)
        try await dataManager.updateTopic(topic2, moduleId: nil)
        
        let topic3 = try await dataManager.topic(id: topic1.id)
        
        XCTAssertEqual(topic2, topic3)
        XCTAssertNotEqual(topic1, topic3)
    }
    
    func testUpdateTopicWrongId() async throws {
        let topic = Topic(name: "test topic", details: "topic details", words: [], exercises: [])
        
        do {
            try await dataManager.updateTopic(topic, moduleId: nil)
            XCTFail("Expected error not thrown")
        }
        catch {
            XCTAssertEqual((error as? DataManagerError), .topicNotFound)
        }
    }
    
    func testDeleteTopic() async throws {
        let topic = Topic(name: "test topic", details: "topic details", words: [], exercises: [])
        
        try await dataManager.addTopic(topic, moduleId: nil)
        try await dataManager.deleteTopic(id: topic.id, moduleId: nil)
        
        do {
            try await _ = dataManager.topic(id: topic.id)
            XCTFail("Expected error not thrown")
        }
        catch {
            XCTAssertEqual((error as? DataManagerError), .topicNotFound)
        }
    }
    
    func testDeleteTopicWrongId() async throws {
        
        do {
            try await dataManager.deleteTopic(id: "wrong id", moduleId: nil)
            XCTFail("Expected error not thrown")
        }
        catch {
            XCTAssertEqual((error as? DataManagerError), .topicNotFound)
        }
    }
    
}

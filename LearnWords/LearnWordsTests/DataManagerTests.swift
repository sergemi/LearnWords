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
        
//        dataManager = MockDataManager.instance
//        dataManager = RealmDataManager()
        
        Config.instance.mode = .unitTests
        Config.instance.dataBaseType = .realm
        dataManager = Config.instance.dataManager
        
        dataManager.reset()
    }

    override func tearDownWithError() throws {
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
    
    func testTopicsInModule() {
        guard let userId = MockAuthManager.userId else {
            XCTFail("userID sholdn't be nil ")
            return
        }
        
        guard let module = addTestModule() else {
            return
        }
        
        var topic1 = Topic(name: "Topic 1", details: "Topic 1 details", words: [], exercises: [])
        
        let topic2 = Topic(name: "Topic 2", details: "Topic 2 details", words: [], exercises: [])
        
        let resAddTopic1 = dataManager.addTopic(moduleId: module.id, topic: topic1)
        
        XCTAssertNotNil(resAddTopic1, "Must be not nil")
        
        XCTAssertEqual( dataManager.module(id: module.id)!.topics.count,
        1, "Must be 1 topic now")
        
        let resAddTopic2 = dataManager.addTopic(moduleId: module.id, topic: topic2)
        XCTAssertNotNil(resAddTopic2, "Must be not nil")
        
        let topicById = dataManager.topic(id: topic2.id)
        XCTAssertNotNil(topicById)
        
        XCTAssertEqual(dataManager.module(id: module.id)!.topics.count, 2, "Must be 2 topics now")
        
        
        topic1.name = "topic 1 updated"
        let resUpdate = dataManager.updateTopic(moduleId: module.id, topic: topic1)
        
        XCTAssertNotNil(resUpdate, "Must return module")
        
        let updatedModule = dataManager.module(id: module.id)!
        let updatedTopic = updatedModule.topics.first(where: {$0.id == topic1.id})!
        
        XCTAssertEqual(updatedTopic.name, topic1.name)
        
        let moduleAfterDeleteTopic = dataManager.deleteTopic(moduleId: module.id, topic:updatedTopic)
        
        XCTAssertEqual(dataManager.module(id: module.id)!.topics.count, 1, "Must be 1 topics now")
        
    }
    
    // helpers
    fileprivate func addTestModule() -> Module? {
        guard let userId = MockAuthManager.userId else {
            XCTFail("userID sholdn't be nil ")
            return nil
        }
        
        let module1 = Module(name: "Module 1", details: "Details", topics: [], author: userId, isPublic: false)
        
        let addedModule = dataManager.addModule(module1)
        return addedModule
    }
    
    func testLearnedWordsInTopic() {
        guard let userId = MockAuthManager.userId else {
            XCTFail("userID sholdn't be nil ")
            return
        }
        
        guard let module = addTestModule() else {
            return
        }
        
        var topic1 = Topic(name: "Topic 1", details: "Topic 1 details", words: [], exercises: [])
        
        _ = dataManager.addTopic(moduleId: module.id, topic: topic1)
        
        let word1 = WordPair(target: "Hello", translate: "Buenos", pronounce: "hel lo", notes: "Привіт!")
        
        var learnedWord1 = LearnedWord(word: word1, exercises: [])
        
        dataManager.addWord(topicId: topic1.id, word: learnedWord1)
        
        topic1 = dataManager.topic(id: topic1.id)!
        
        XCTAssertEqual(topic1.words.count, 1)
        
        learnedWord1.word.target = "changed"
        
        let updateWordRes = dataManager.updateWord(topicId: topic1.id, word: learnedWord1)
        
        XCTAssertNotNil(updateWordRes)
        
        XCTAssertEqual(updateWordRes!.words.count, 1)
        
        guard let updatedWord = dataManager.learnedWord(id: learnedWord1.id) else {
            XCTFail("Get learnedWord by index is fail")
            return
        }
        
        XCTAssertEqual(updatedWord.word.target, "changed")
        
        let deleteWordRes = dataManager.deleteWord(topicId: topic1.id, word: learnedWord1)
        
        XCTAssertNotNil(deleteWordRes)
        
        guard let topicAfterDelete = dataManager.topic(id: topic1.id) else {
            XCTFail("Must be not nil")
            return
        }
        
        XCTAssertEqual(topicAfterDelete.words.count, 0)
    }
    
    func testWord() {
        guard let userId = MockAuthManager.userId else {
            XCTFail("userID sholdn't be nil ")
            return
        }
        
        guard let module = addTestModule() else {
            return
        }
        
        var topic1 = Topic(name: "Topic 1", details: "Topic 1 details", words: [], exercises: [])
        
        _ = dataManager.addTopic(moduleId: module.id, topic: topic1)
        
        var word1 = WordPair(target: "Hello", translate: "Buenos", pronounce: "hel lo", notes: "Привіт!")
        
        var learnedWord1 = LearnedWord(word: word1, exercises: [])
        
        _ = dataManager.addWord(topicId: topic1.id, word: learnedWord1)
        
        word1.target = "changed"
        
        let updateRes = dataManager.updateWord(learnedWordId: learnedWord1.id, word: word1)
        
        XCTAssertNotNil(updateRes)
        
        let updatedWord = dataManager.learnedWord(id: learnedWord1.id)
        
        guard let updatedWord else {
            XCTFail("Learned word don't find")
            return
        }
        
        XCTAssertEqual(updatedWord.word.target, word1.target)
    }
}

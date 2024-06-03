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
        
        Config.instanceUT.dataBaseType = .moc
        dataManager = Config.instanceUT.dataManager
        
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
    
    // MARK: - Module tests
    func testAddModule() async throws {
        // Given
        let startCount = try await dataManager.modules.count
        XCTAssertEqual(startCount, 0, "modules count must be 0 on init")
        
        let module = Module(name: "New module", details: "test", topics: [], author: "Tester", isPublic: true)
        
        // When
        try await dataManager.addModule(module)
        let afterAddCount = try await dataManager.modules.count
        
        // Then
        XCTAssertEqual(afterAddCount, 1, "modules count must be 1")
    }
    
    func testGetModule() async throws {
        // Given
        let module2add = Module(name: "New module", details: "test", topics: [], author: "Tester", isPublic: true)
        
        try await dataManager.addModule(module2add)
        
        // When
        let gettedModule = try await dataManager.module(id: module2add.id)
        
        // Then
        XCTAssertEqual(module2add, gettedModule)
    }
    
    func testModuleNotFound() async throws {
        // Given
        // When
        do {
            _ = try await dataManager.module(id: "wrong id")
            XCTFail("Expected error not thrown")
            
        }
        // Then
        catch {
            XCTAssertEqual((error as? DataManagerError), .moduleNotFound)
        }
    }
    
    func testUpdateModule() async throws {
        // Given
        let firstModule = Module(name: "First", details: "test", topics: [], author: "Tester", isPublic: true)
        
        let secondModule = Module(id:firstModule.id, name: "Second", details: "test", topics: [], author: "Tester", isPublic: true)
        
        try await dataManager.addModule(firstModule)
        
        // When
        try await dataManager.updateModule(secondModule)
        
        let resultModule = try await dataManager.module(id: secondModule.id)
        
        // Then
        XCTAssertEqual(secondModule, resultModule)
        XCTAssertNotEqual(firstModule, resultModule)
    }
    
    func testUpdateModuleWrongId() async throws {
        // Given
        // When
        let module = Module(name: "Module", details: "test", topics: [], author: "Tester", isPublic: true)
        do {
            _ = try await dataManager.updateModule(module)
            XCTFail("Expected error not thrown")
            
        }
        // Then
        catch {
            XCTAssertEqual((error as? DataManagerError), .moduleNotFound)
        }
    }
    
    func testDeleteModule() async throws {
        // Given
        let module = Module(id: "module id", name: "Module", details: "test", topics: [], author: "Tester", isPublic: true)
        
        try await dataManager.addModule(module)
        
        // When
        try await dataManager.deleteModule(id: module.id)
        
        // Then
        let modulesCount = try await dataManager.modules.count
        XCTAssertEqual(modulesCount, 0)
    }
    
    func testDeleteModuleWrongId() async throws {
        // Given
        // When
        do {
            _ = try await dataManager.deleteModule(id: "wrong id")
            XCTFail("Expected error not thrown")
            
        }
        // Then
        catch {
            XCTAssertEqual((error as? DataManagerError), .moduleNotFound)
        }
    }
    
    // MARK: - Topic tests
    
    func testAddGetTopic() async throws {
        // Given
        let topic1 = Topic(name: "topic 1", details: "topic details", words: [], exercises: [])
        
        // When
        try await dataManager.addTopic(topic1, moduleId: nil)
        let topic2 = try await dataManager.topic(id: topic1.id)
        
        // Then
        XCTAssertEqual(topic1, topic2)
    }
    
    func testTopicNotFound() async throws {
        // Given
        // When
        do {
            _ = try await dataManager.topic(id: "wrong id")
            XCTFail("Expected error not thrown")
            
        }
        // Then
        catch {
            XCTAssertEqual((error as? DataManagerError), .topicNotFound)
        }
    }
    
    func testUpdateTopic() async throws {
        // Given
        let topic1 = Topic(name: "topic 1", details: "topic details", words: [], exercises: [])
        
        let topic2 = Topic(id: topic1.id, name: "topic updated", details: "topic updated details", words: [], exercises: [])
        
        try await dataManager.addTopic(topic1, moduleId: nil)
        
        // When
        try await dataManager.updateTopic(topic2, moduleId: nil)
        
        // Then
        let topic3 = try await dataManager.topic(id: topic1.id)
        
        XCTAssertEqual(topic2, topic3)
        XCTAssertNotEqual(topic1, topic3)
    }
    
    func testUpdateTopicWrongId() async throws {
        // Given
        let topic = Topic(name: "test topic", details: "topic details", words: [], exercises: [])
        
        // When
        do {
            try await dataManager.updateTopic(topic, moduleId: nil)
            XCTFail("Expected error not thrown")
        }
        
        // Then
        catch {
            XCTAssertEqual((error as? DataManagerError), .topicNotFound)
        }
    }
    
    func testDeleteTopic() async throws {
        // Given
        let topic = Topic(name: "test topic", details: "topic details", words: [], exercises: [])
        
        try await dataManager.addTopic(topic, moduleId: nil)
        
        // When
        try await dataManager.deleteTopic(id: topic.id, moduleId: nil)
        
        // Then
        do {
            try await _ = dataManager.topic(id: topic.id)
            XCTFail("Expected error not thrown")
        }
        catch {
            XCTAssertEqual((error as? DataManagerError), .topicNotFound)
        }
    }
    
    func testDeleteTopicWrongId() async throws {
        // Given
        // When
        do {
            try await dataManager.deleteTopic(id: "wrong id", moduleId: nil)
            XCTFail("Expected error not thrown")
        }
        
        // Then
        catch {
            XCTAssertEqual((error as? DataManagerError), .topicNotFound)
        }
    }
    
    func testAddGetTopicWithModule() async throws {
        // Given
        let module = Module(id: "module id", name: "Module", details: "test", topics: [], author: "Tester", isPublic: true)
        try await dataManager.addModule(module)
        
        let topic1 = Topic(name: "topic 1", details: "topic details", words: [], exercises: [])
        
        // When
        try await dataManager.addTopic(topic1, moduleId: module.id)
        
        let topic2 = try await dataManager.topic(id: topic1.id)
        
        // Then
        XCTAssertEqual(topic1, topic2)
    }
    
    func testUpdateTopicWithModule() async throws {
        // Given
        let module = Module(id: "module id", name: "Module", details: "test", topics: [], author: "Tester", isPublic: true)
        try await dataManager.addModule(module)
        
        let topic1 = Topic(name: "topic 1", details: "topic details", words: [], exercises: [])
        
        let topic2 = Topic(id: topic1.id, name: "topic updated", details: "topic updated details", words: [], exercises: [])
        
        try await dataManager.addTopic(topic1, moduleId: module.id)
        
        // When
        try await dataManager.updateTopic(topic2, moduleId: module.id)
        
        // Then
        let topic3 = try await dataManager.topic(id: topic1.id)
        
        XCTAssertEqual(topic2, topic3)
        XCTAssertNotEqual(topic1, topic3)
    }
    
    func testUpdateTopicWrongIdWithModule() async throws {
        // Given
        let module = Module(id: "module id", name: "Module", details: "test", topics: [], author: "Tester", isPublic: true)
        try await dataManager.addModule(module)
        
        let topic = Topic(name: "test topic", details: "topic details", words: [], exercises: [])
        
        // When
        do {
            try await dataManager.updateTopic(topic, moduleId: module.id)
            XCTFail("Expected error not thrown")
        }
        
        // Then
        catch {
            XCTAssertEqual((error as? DataManagerError), .topicNotFound)
        }
    }
    
    func testDeleteTopicWithModule() async throws {
        // Given
        let module = Module(id: "module id", name: "Module", details: "test", topics: [], author: "Tester", isPublic: true)
        try await dataManager.addModule(module)
        
        let topic = Topic(name: "test topic", details: "topic details", words: [], exercises: [])
        
        try await dataManager.addTopic(topic, moduleId: module.id)
        
        // When
        try await dataManager.deleteTopic(id: topic.id, moduleId: module.id)
        
        // Then
        do {
            try await _ = dataManager.topic(id: topic.id)
            XCTFail("Expected error not thrown")
        }
        catch {
            XCTAssertEqual((error as? DataManagerError), .topicNotFound)
        }
    }
    
    func testDeleteTopicWrongIdWithModule() async throws {
        // Given
        let module = Module(id: "module id", name: "Module", details: "test", topics: [], author: "Tester", isPublic: true)
        try await dataManager.addModule(module)
        
        // When
        do {
            try await dataManager.deleteTopic(id: "wrong id", moduleId: module.id)
            XCTFail("Expected error not thrown")
        }
        
        // Then
        catch {
            XCTAssertEqual((error as? DataManagerError), .topicNotFound)
        }
    }
    
    // MARK: - WordPair tests
    
    func testAddGetWordPair() async throws {
        // Given
        let word = WordPair(target: "target",
                            translate: "translate",
                            pronounce: "pronounce",
                            notes: "notes")
        
        // When
        try await dataManager.addWord(word)
        let word2 = try await dataManager.word(id: word.id)
        
        // Then
        XCTAssertEqual(word, word2)
    }
    
    func testUpdateWordPair() async throws {
        // Given
        let word1 = WordPair(target: "target1",
                             translate: "translate1",
                             pronounce: "pronounce1",
                             notes: "notes1")
        
        let word2 = WordPair(id: word1.id,
                             target: "target2",
                             translate: "translate2",
                             pronounce: "pronounce2",
                             notes: "notes2")
        
        // When
        try await dataManager.addWord(word1)
        try await dataManager.updateWord(word2)
        let word3 = try await dataManager.word(id: word1.id)
        
        // Then
        XCTAssertEqual(word2, word3)
        XCTAssertNotEqual(word1, word3)
    }
    
    // MARK: - LearnedWord tests
    
    func testAddGetLearnedWord() async throws {
        // Given
        let wordPair = WordPair(target: "target1",
                                translate: "translate1",
                                pronounce: "pronounce1",
                                notes: "notes1")
        let learnedWord = LearnedWord(word: wordPair, exercises: [])
        
        // When
        
        try await dataManager.addWord(learnedWord, topicId: nil)
        let learnedWord2 = try await dataManager.learnedWord(id: learnedWord.id)
        
        // Then
        XCTAssertEqual(learnedWord, learnedWord2)
    }
    
    func testUpdateLearnedWord() async throws {
        // Given
        let wordPair1 = WordPair(target: "target1",
                                 translate: "translate1",
                                 pronounce: "pronounce1",
                                 notes: "notes1")
        let learnedWord1 = LearnedWord(word: wordPair1, exercises: [])
        
        let wordPair2 = WordPair(id: wordPair1.id,
                                 target: "target2",
                                 translate: "translate2",
                                 pronounce: "pronounce2",
                                 notes: "notes2")
        let learnedWord2 = LearnedWord(id:learnedWord1.id, word: wordPair2, exercises: [])
        
        try await dataManager.addWord(learnedWord1, topicId: nil)
        
        // When
        try await dataManager.updateWord(learnedWord2, topicId: nil)
        let learnedWord3 = try await dataManager.learnedWord(id: learnedWord1.id)
        // Then
        XCTAssertEqual(learnedWord2, learnedWord3)
        XCTAssertNotEqual(learnedWord1, learnedWord3)
    }
    
    func testDeleteLearnedWord() async throws {
        // Given
        let wordPair1 = WordPair(target: "target1",
                                 translate: "translate1",
                                 pronounce: "pronounce1",
                                 notes: "notes1")
        let learnedWord1 = LearnedWord(word: wordPair1, exercises: [])
        try await dataManager.addWord(learnedWord1, topicId: nil)
        
        // When
        try await dataManager.deleteWord(learnedWord1, topicId: nil)
        do {
            try await dataManager.deleteWord(learnedWord1, topicId: nil)
            XCTFail("Expected error not thrown")
        }
        // Then
        catch {
            XCTAssertEqual((error as? DataManagerError), .learnedWordNotFound)
        }
    }
    
    func testDeleteLearnedWordWithWrongId() async throws {
        // Given
        let wordPair1 = WordPair(target: "target1",
                                 translate: "translate1",
                                 pronounce: "pronounce1",
                                 notes: "notes1")
        let learnedWord1 = LearnedWord(word: wordPair1, exercises: [])
        
        // When
        do {
            try await dataManager.deleteWord(learnedWord1, topicId: nil)
            XCTFail("Expected error not thrown")
        }
        // Then
        catch {
            XCTAssertEqual((error as? DataManagerError), .learnedWordNotFound)
        }
    }
    
    func testAddGetLearnedWordWithTopic() async throws {
        // Given
        let topic = Topic(name: "Topic",
                          details: "Test topic",
                          words: [],
                          exercises: [])
        try await dataManager.addTopic(topic, moduleId: nil)
        
        let wordPair = WordPair(target: "target1",
                                translate: "translate1",
                                pronounce: "pronounce1",
                                notes: "notes1")
        let learnedWord = LearnedWord(word: wordPair, exercises: [])
        
        // When
        
        try await dataManager.addWord(learnedWord, topicId: topic.id)
        let learnedWord2 = try await dataManager.learnedWord(id: learnedWord.id)
        
        // Then
        XCTAssertEqual(learnedWord, learnedWord2)
    }
    
    func testUpdateLearnedWordWithTopic() async throws {
        // Given
        let topic = Topic(name: "Topic",
                          details: "Test topic",
                          words: [],
                          exercises: [])
        try await dataManager.addTopic(topic, moduleId: nil)
        
        let wordPair1 = WordPair(target: "target1",
                                 translate: "translate1",
                                 pronounce: "pronounce1",
                                 notes: "notes1")
        let learnedWord1 = LearnedWord(word: wordPair1, exercises: [])
        
        let wordPair2 = WordPair(id: wordPair1.id,
                                 target: "target2",
                                 translate: "translate2",
                                 pronounce: "pronounce2",
                                 notes: "notes2")
        let learnedWord2 = LearnedWord(id:learnedWord1.id, word: wordPair2, exercises: [])
        
        try await dataManager.addWord(learnedWord1, topicId: topic.id)
        
        // When
        try await dataManager.updateWord(learnedWord2, topicId: topic.id)
        let learnedWord3 = try await dataManager.learnedWord(id: learnedWord1.id)
        // Then
        XCTAssertEqual(learnedWord2, learnedWord3)
        XCTAssertNotEqual(learnedWord1, learnedWord3)
    }
    
    func testDeleteLearnedWordWithTopic() async throws {
        // Given
        let topic = Topic(name: "Topic",
                          details: "Test topic",
                          words: [],
                          exercises: [])
        try await dataManager.addTopic(topic, moduleId: nil)
        
        let wordPair1 = WordPair(target: "target1",
                                 translate: "translate1",
                                 pronounce: "pronounce1",
                                 notes: "notes1")
        let learnedWord1 = LearnedWord(word: wordPair1, exercises: [])
        try await dataManager.addWord(learnedWord1, topicId: topic.id)
        
        // When
        try await dataManager.deleteWord(learnedWord1, topicId: topic.id)
        do {
            try await dataManager.deleteWord(learnedWord1, topicId: topic.id)
            XCTFail("Expected error not thrown")
        }
        // Then
        catch {
            XCTAssertEqual((error as? DataManagerError), .learnedWordNotFound)
        }
    }
    
    func testDeleteLearnedWordWithWrongIdWithTopic() async throws {
        // Given
        let topic = Topic(name: "Topic",
                          details: "Test topic",
                          words: [],
                          exercises: [])
        try await dataManager.addTopic(topic, moduleId: nil)
        
        let wordPair1 = WordPair(target: "target1",
                                 translate: "translate1",
                                 pronounce: "pronounce1",
                                 notes: "notes1")
        let learnedWord1 = LearnedWord(word: wordPair1, exercises: [])
        
        // When
        do {
            try await dataManager.deleteWord(learnedWord1, topicId: topic.id)
            XCTFail("Expected error not thrown")
        }
        // Then
        catch {
            XCTAssertEqual((error as? DataManagerError), .learnedWordNotFound)
        }
    }
}

//
//  ModelsRealmConverting.swift
//  LearnWordsTests
//
//  Created by sergemi on 14.04.2024.
//

import XCTest
import Foundation
import RealmSwift
@testable import LearnWords

final class ModelsRealmConverting: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testExerciseType() throws {
        // Given
        let m_ChoseTranslate = ExerciseType.choseTranslate
        let m_writeTranslate = ExerciseType.writeTranslate
        // When
        let r_ChoseTranslate = ExerciseType_realm(exerciseType: m_ChoseTranslate)
        
        let m_ChoseTranslate2 = r_ChoseTranslate.exerciseType
        
        let r_writeTranslate = ExerciseType_realm(exerciseType: m_writeTranslate)
        
        let m_writeTranslate2 = r_writeTranslate.exerciseType
        
        // Then
        XCTAssertEqual(m_ChoseTranslate, m_ChoseTranslate2)
        XCTAssertEqual(m_writeTranslate, m_writeTranslate2)
        XCTAssertNotEqual(m_ChoseTranslate2, m_writeTranslate2)
    }
    
    func testExercise() {
        // Given
        let m_Translate = Exercise(type: .choseTranslate, maxScore: 10)
        let m_Swap = Exercise(type: .swapLettersTranslate, maxScore: 5)
        
        // When
        let r_Translate = ModelExercise_realm(exercise: m_Translate)
        
        let m_Translate2 = r_Translate.exercise
        
        let r_Swap = ModelExercise_realm(exercise: m_Swap)
        let m_Swap2 = r_Swap.exercise
        // Then
        XCTAssertEqual(m_Translate, m_Translate2)
        XCTAssertEqual(m_Swap, m_Swap2)
        XCTAssertNotEqual(m_Translate2, m_Swap2)
    }
    
    func testWordPair() {
        // Given
        let mWordPair = WordPair(target: "cerveza", translate: "пиво", pronounce: "сервеза", notes: "")
        // When
        let rWordPair = ModelWordPair_realm(wordPair: mWordPair)
        let mWordPair2 = rWordPair.wordPair
        // Then
        XCTAssertEqual(mWordPair, mWordPair2)
    }
    
    func testLearnedWord() {
        // Given
        let word = WordPair(target: "aaa", translate: "bbb", pronounce: "ccc", notes: "ddd")
        let exercises = [
            Exercise(type: .choseTranslate, maxScore: 5),
            Exercise(type: .writeTranslate, maxScore: 10)
        ]
        let mLearnedWord = LearnedWord(word: word, exercises: exercises)
        // When
        let rLearnedWord = ModelLearnedWord_realm(learnedWord: mLearnedWord)
        let mLearnedWord2 = rLearnedWord.learnedWord
        // Then
        XCTAssertEqual(mLearnedWord, mLearnedWord2)
    }
    
    func testTopics() {
        // Given
        let word = WordPair(target: "aaa", translate: "bbb", pronounce: "ccc", notes: "ddd")
        let exercises = [
            Exercise(type: .choseTranslate, maxScore: 5),
            Exercise(type: .writeTranslate, maxScore: 10)
        ]
        let mLearnedWord = LearnedWord(word: word, exercises: exercises)
        
        let exercise = Exercise(type: .choseTranslate, maxScore: 10)
        
        let mTopic = Topic(name: "eee",
                          details: "fff",
                          words: [mLearnedWord],
                          exercises: [exercise])
        // When
        let rTopic = ModelTopic_realm(topic: mTopic)
        let mTopic2 = rTopic.topic
        // Then
        XCTAssertEqual(mTopic, mTopic2)
    }
    
    func testModules() {
        // Given
        let word = WordPair(target: "aaa", translate: "bbb", pronounce: "ccc", notes: "ddd")
        let exercises = [
            Exercise(type: .choseTranslate, maxScore: 5),
            Exercise(type: .writeTranslate, maxScore: 10)
        ]
        let mLearnedWord = LearnedWord(word: word, exercises: exercises)
        
        let exercise = Exercise(type: .choseTranslate, maxScore: 10)
        
        let mTopic = Topic(name: "eee",
                          details: "fff",
                          words: [mLearnedWord],
                          exercises: [exercise])
        
        let mModule = Module(name: "ggg",
                             details: "hhh",
                             topics: [mTopic],
                             author: "Serhii",
                             isPublic: true)
        
        // When
        let rModule = ModelModule_realm(module: mModule)
        let mModule2 = rModule.module
        
        // Then
        XCTAssertEqual(mModule, mModule2)
    }
}

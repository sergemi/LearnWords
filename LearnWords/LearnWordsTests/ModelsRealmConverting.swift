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
        let r_ChoseTranslate = ExerciseType_realm(model: m_ChoseTranslate)
        
        let m_ChoseTranslate2 = r_ChoseTranslate.model
        
        let r_writeTranslate = ExerciseType_realm(model: m_writeTranslate)
        
        let m_writeTranslate2 = r_writeTranslate.model
        
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
        let r_Translate = ModelExercise_realm(model: m_Translate)
        
        let m_Translate2 = r_Translate.model
        
        let r_Swap = ModelExercise_realm(model: m_Swap)
        let m_Swap2 = r_Swap.model
        // Then
        XCTAssertEqual(m_Translate, m_Translate2)
        XCTAssertEqual(m_Swap, m_Swap2)
        XCTAssertNotEqual(m_Translate2, m_Swap2)
    }
}

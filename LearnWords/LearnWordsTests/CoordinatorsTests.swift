//
//  CoordinatorsTests.swift
//  CoordinatorsTest
//
//  Created by sergemi on 10.04.2024.
//

import XCTest
@testable import LearnWords

final class UIButtonExtTest: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func testSetTitle() {
        // Given
        let btn = UIButton()
        
        // When
        btn.setTitle("test")
        
        // Then
        XCTAssertEqual(btn.title(for: .normal), "test")
        XCTAssertEqual(btn.title(for: .selected), "test")
    }
}

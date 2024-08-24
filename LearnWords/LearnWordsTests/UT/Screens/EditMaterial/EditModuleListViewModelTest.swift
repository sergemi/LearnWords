//
//  EditModuleListViewModelTest.swift
//  LearnWordsTests
//
//  Created by sergemi on 08.07.2024.
//

import XCTest
@testable import LearnWords

final class EditModuleListViewModelTest: XCTestCase {
    var dataManager: DataManager!
    var navigationController: UINavigationController!
    var coordinator: EditMaterialCoordinatorProtocol!
    var viewModel: EditModuleListViewModel!
    
    override func setUpWithError() throws {
        dataManager = MockDataManager.instance
        navigationController = UINavigationController()
        coordinator = EditMaterialCoordinator(navigationController: navigationController,
                                              dataManager: dataManager)
        viewModel = EditModuleListViewModel(dataManager: dataManager,
                                            coordinator: coordinator)
        
    }
    
    override func tearDownWithError() throws {
        coordinator = nil
        navigationController = nil
        Task {
            try await dataManager.reset()
        }
        viewModel = nil
    }
    
    func testAaa() {
        // Given
        
        // When
        
        // Then
    }
    
}

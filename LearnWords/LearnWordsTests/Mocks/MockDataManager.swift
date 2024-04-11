//
//  MockDataManager.swift
//  LearnWordsTests
//
//  Created by sergemi on 11.04.2024.
//

import Foundation
@testable import LearnWords

class MockDataManager: DataManager {
    var modules: [LearnWords.Module] = []
    
    var authManager: AuthProtocol
    
    init(authManager: AuthProtocol) {
        self.authManager = authManager
    }
    
    // MARK - DataManager
    func module(id: String) -> LearnWords.Module? {
        let module = modules.first{$0.id == id}
        return module
    }
    
    func addModule(_ module: LearnWords.Module) -> LearnWords.Module? {
        modules.append(module)
        return module
    }
    
    func updateModule(_ module: Module) -> LearnWords.Module? {
        guard let index = modules.firstIndex(where: {$0.id == module.id}) else {
            return nil
        }
        
        modules[index] = module
        return modules[index]
    }
    
    func deleteModule(_ module: Module) -> LearnWords.Module? {
        guard let index = modules.firstIndex(where: {$0.id == module.id}) else {
            return nil
        }
        return modules.remove(at: index)
    }
    
    
}

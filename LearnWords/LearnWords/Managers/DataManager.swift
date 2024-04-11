//
//  DataManager.swift
//  LearnWords
//
//  Created by sergemi on 11.04.2024.
//

import Foundation

protocol DataManager {
    var modules: [Module] {get}
    func module(id: String) -> Module? // nil if not found
    func addModule(_ module: Module) -> Module? // nil if fail
    func updateModule(_ module: Module) -> Module? // nil if fail
    func deleteModule(_ module: Module) -> Module? // nil if fail
}

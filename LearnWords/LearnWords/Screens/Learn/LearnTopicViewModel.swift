//
//  LearnTopicViewModel.swift
//  LearnWords
//
//  Created by sergemi on 27.02.2023.
//

import Foundation
import RealmSwift

class LearnTopicViewModel: UniversalTableViewModel {
    var learnCoordinator: LearnCoordinatorProtocol? = nil
    
    var topic: ModelTopic
    var words: [ModelLearnedWord] = []
    
    init(topic: ModelTopic) {
        self.topic = topic
        super.init()
        
        title.accept(self.topic.name)
        tableHeader.accept("Learn.Topic.tableHeader".localized())
        
        name.accept(topic.name)
        details.accept(topic.details)
        
        canSelect.accept(true)
    }
    
    override func reloadTableData(){
//        let realm = try! Realm()
        words = Array(topic.words)
        
        let wordsRows = words.map{
            ModelTableViewCell(checkbox: .checked,
                               title: "\($0.word?.target ?? "") - \($0.word?.translate ?? "")",
                               percent: 0,
                               showArrow: true)
        }
        rows.accept(wordsRows)
    }
}

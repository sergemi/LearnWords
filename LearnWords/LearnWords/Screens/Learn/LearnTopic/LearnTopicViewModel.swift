//
//  LearnTopicViewModel.swift
//  LearnWords
//
//  Created by sergemi on 27.02.2023.
//

import Foundation

class LearnTopicViewModel: UniversalTableViewModel {
    var learnCoordinator: LearnCoordinatorProtocol? = nil
    let dataManager: DataManager!
    
    var topic: Topic
    var words: [LearnedWord] = []
    
    init(dataManager: DataManager, topic: Topic) {
        self.dataManager = dataManager
        self.topic = topic
        super.init()
        
        title.accept(self.topic.name)
        tableHeader.accept("Learn.Topic.tableHeader".localized())
        
        name.accept(topic.name)
        details.accept(topic.details)
        
        canSelect.accept(true)
    }
    
    override func reloadTableData(){
        // TODO
        words = []
        //words = Array(topic.words)
//        
//        let wordsRows = words.map{
//            ModelTableViewCell(checkbox: .checked,
//                               title: "\($0.word.target) - \($0.word.translate)",
//                               percent: 0,
//                               showArrow: true)
//        }
//        rows.accept(wordsRows)
    }
}

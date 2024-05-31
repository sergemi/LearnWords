//
//  LearnTopicViewModel.swift
//  LearnWords
//
//  Created by sergemi on 27.02.2023.
//

import Foundation

class LearnTopicViewModel: UniversalTableViewModel {
    var learnCoordinator: LearnCoordinatorProtocol? = nil
    private let dataManager: DataManager!
    
    private var topicId: String
    var topic: Topic?
    var words: [LearnedWord] = []
    
    init(dataManager: DataManager, topicId: String) {
        self.dataManager = dataManager
        self.topicId = topicId
        super.init()
        
        tableHeader.accept("Learn.Topic.tableHeader".localized())
        
        // todo
//        title.accept(self.topic.name)
//        name.accept(topic.name)
//        details.accept(topic.details)
        
        canSelect.accept(true)
    }
    
    override func reloadData(){
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

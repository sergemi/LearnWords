//
//  LearnTopicViewModel.swift
//  LearnWords
//
//  Created by sergemi on 27.02.2023.
//

import Foundation

final class LearnTopicViewModel: UniversalTableViewModel {
    private weak var coordinator: LearnCoordinatorProtocol?
    private let dataManager: DataManager!
    
    private var topicId: String
    var topic: Topic?
//    var words: [LearnedWord] = []
    
    init(dataManager: DataManager, coordinator:LearnCoordinatorProtocol, topicId: String) {
        self.dataManager = dataManager
        self.coordinator = coordinator
        self.topicId = topicId
        super.init()
        
        tableHeader.accept("Learn.Topic.tableHeader".localized())
        canSelect.accept(true)
    }
    
    override func reloadData(){
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                self.topic = try await dataManager.topic(id: topicId)
                guard let topic = self.topic else {
                    return
                }
                
                let wordRows = topic.words.map{
                    ModelTableViewCell(checkbox: .checked,
                                       title: "\($0.word.target) - \($0.word.translate)",
                                       percent: 0,
                                       showArrow: true)
                }
                DispatchQueue.main.async { [weak self] in
                    self?.title.accept(topic.name)
                    self?.name.accept(topic.name)
                    self?.details.accept(topic.details)
                    self?.rows.accept(wordRows)
                }
            }
            catch {
                if let error = error as? LocalizedError {
                    print(error.localizedDescription)
                } else {
                    print("An unexpected error occurred: \(error)")
                }
            }
        }
    }
}

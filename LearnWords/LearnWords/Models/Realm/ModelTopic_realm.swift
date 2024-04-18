//
//  ModelTopic_realm.swift
//  LearnWords
//
//  Created by sergemi on 21.02.2023.
//

import Foundation
import RealmSwift

class ModelTopic_realm: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String = ""
    @Persisted var details: String = ""
    @Persisted var words: List<ModelLearnedWord_realm>
    @Persisted var availablesExercises: List<ExerciseType_realm>
}

extension ModelTopic_realm {
    convenience init(topic: Topic) {
        self.init()
        id = topic.id
        name = topic.name
        details = topic.details
        
        let wordsArray = topic.words.map{ModelLearnedWord_realm(learnedWord: $0)}
        words.append(objectsIn: wordsArray)
        
        let exercisesArray = topic.exercises.map{ExerciseType_realm(exerciseType: $0)}
        availablesExercises.append(objectsIn: exercisesArray)
    }
    
    var topic: Topic {
        var newWords = [LearnedWord]()
        for realmWord in words {
            let word = realmWord.learnedWord
            newWords.append(word)
        }

        var newExercises = [ExerciseType]()
        for realmExercise in availablesExercises {
            let exercise = realmExercise.exerciseType
            newExercises.append(exercise)
        }
        
        var newTopic = Topic(id: id,
                             name: name,
                             details: details,
                             words: newWords,
                             exercises: newExercises
        )
        
        return newTopic
    }
}

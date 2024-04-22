//
//  ModelTopic_realm.swift
//  LearnWords
//
//  Created by sergemi on 21.02.2023.
//

import Foundation
import RealmSwift

class ModelTopic_realm: RealmObjectWidthId {
    @Persisted var name: String = ""
    @Persisted var details: String = ""
    @Persisted var words: List<ModelLearnedWord_realm>
    @Persisted var availablesExercises: List<ExerciseType_realm>
}

extension ModelTopic_realm {
    func updateFrom(topic: Topic) {
        name = topic.name
        details = topic.details
        
        words.removeAll()
        var wordsArray: [ModelLearnedWord_realm] = []
        
        do {
            let realm = try Realm()
            
            for word in topic.words {
                var realmWord = getRealmObject(realm: realm,
                                               objectType: ModelLearnedWord_realm.self,
                                               id: word.id)
                if realmWord == nil {
                    realmWord = ModelLearnedWord_realm(learnedWord: word)
                }
                wordsArray.append(realmWord!)
            }
        } catch let error as NSError {
            print("Realm error: \(error.localizedDescription)")
            return
        }
        
        availablesExercises.removeAll()
        let exercisesArray = topic.exercises.map{ExerciseType_realm(exerciseType: $0)}
        availablesExercises.append(objectsIn: exercisesArray)
    }
    
    convenience init(topic: Topic) {
        self.init()
        id = topic.id
        updateFrom(topic: topic)
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
        
        let newTopic = Topic(id: id,
                             name: name,
                             details: details,
                             words: newWords,
                             exercises: newExercises
        )
        
        return newTopic
    }
}

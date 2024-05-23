//
//  ModelLearnedWord_realm.swift
//  LearnWords
//
//  Created by sergemi on 21.02.2023.
//

import Foundation
import RealmSwift

class ModelLearnedWord_realm: RealmObjectWidthId {
    @Persisted var word: ModelWordPair_realm?
    @Persisted var exercises: List<ModelExercise_realm>
}

extension ModelLearnedWord_realm {
    func updateFrom(_ learnedWord: LearnedWord) {
        //TODO
        do {
//            let realm = try Realm()
//            
//            var wordPair = getRealmObject(realm: realm,
//                                                objectType: ModelWordPair_realm.self,
//                                                id: learnedWord.word.id)
//            if wordPair != nil {
//                wordPair?.updateFrom(wordPair: learnedWord.word)
//            }
//            else {
//                wordPair = ModelWordPair_realm(wordPair: learnedWord.word)
//            }
//            word = wordPair
//            
//            exercises.removeAll()
//            let exercisesArray = learnedWord.exercises.compactMap{ModelExercise_realm(exercise: $0)}
//            
//            exercises.append(objectsIn: exercisesArray)
                
        } catch let error as NSError {
            print("Realm error: \(error.localizedDescription)")
            return
        }
    }
    
    convenience init( learnedWord: LearnedWord) {
        self.init()
        id = learnedWord.id
        updateFrom(learnedWord)
    }
    
    var learnedWord: LearnedWord {
//        return LearnedWord(wordPairId: "abc", exerciseId: []) // todo
        var exercisesArray = [Exercise]()
        for exerciseRealm in exercises {
            let exercise = exerciseRealm.exercise
            exercisesArray.append(exercise)
        }
        
        let newWord = LearnedWord(id: id,
                                   word: word!.wordPair,
                                   exercises: exercisesArray)
        
        return newWord
    }
}

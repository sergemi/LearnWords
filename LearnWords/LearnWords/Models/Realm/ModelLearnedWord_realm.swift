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
    convenience init( learnedWord: LearnedWord) {
        self.init()
        id = learnedWord.id
        word = ModelWordPair_realm(wordPair: learnedWord.word)
        
        let exercisesArray = learnedWord.exercises.compactMap{ModelExercise_realm(exercise: $0)}
        
        exercises.append(objectsIn: exercisesArray)
    }
    
    var learnedWord: LearnedWord {
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

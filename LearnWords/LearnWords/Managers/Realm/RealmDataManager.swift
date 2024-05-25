//
//  RealmDataManager.swift
//  LearnWords
//
//  Created by sergemi on 14.04.2024.
//
/*
import Foundation
import RealmSwift

 class RealmDataManager: DataManager {
 let realm: Realm
 
 init(realm: Realm) {
 self.realm = realm
 }
 
 var modules: [ModulePreload] {
 return [] // TODO
 //        let realmModules = realm.objects(ModelModule_realm.self)
 //
 //        return realmModules.map{$0.module}
 
 }
 
 func reset() {
 do {
 try realm.write {
 realm.delete(realm.objects(ModelLearnedWord_realm.self))
 realm.delete(realm.objects(ModelTopic_realm.self))
 realm.delete(realm.objects(ModelModule_realm.self))
 realm.delete(realm.objects(ModelWordPair_realm.self))
 }
 } catch let error as NSError {
 print("Realm error: \(error.localizedDescription)")
 }
 }
 
 func module(id: String) -> Module? {
 guard let moduleRealm = realm.object(ofType: ModelModule_realm.self, forPrimaryKey: id) else {
 return nil
 }
 return moduleRealm.module
 }
 
 func addModule(_ module: Module) -> Module? {
 let realmModule = ModelModule_realm(module: module)
 
 do {
 try realm.write {
 realm.add(realmModule)
 }
 
 } catch let error as NSError {
 print("Realm error: \(error.localizedDescription)")
 return nil
 }
 
 return module
 }
 
 func updateModule(_ module: Module) -> Module? {
 do {
 guard let moduleRealm = getRealmObject(realm: realm, objectType: ModelModule_realm.self, id: module.id) else {
 return nil
 }
 
 try realm.write {
 moduleRealm.updateFrom(module)
 }
 } catch let error as NSError {
 print("Realm error: \(error.localizedDescription)")
 return nil
 }
 
 return module
 }
 
 func deleteModule(_ module: Module) -> Module? {
 do {
 guard let moduleRealm = realm.object(ofType: ModelModule_realm.self, forPrimaryKey: module.id) else {
 return nil
 }
 
 try realm.write {
 realm.delete(moduleRealm)
 }
 } catch let error as NSError {
 print("Realm error: \(error.localizedDescription)")
 return nil
 }
 return module
 }
 
 func topic(id: String) -> Topic? {
 guard let topicRealm = realm.object(ofType: ModelTopic_realm.self, forPrimaryKey: id) else {
 return nil
 }
 return topicRealm.topic
 }
 
 func addTopic(moduleId: String, topic: Topic) -> Module? {
 let topicRealm = ModelTopic_realm(topic: topic)
 do {
 guard let moduleRealm = getRealmObject(realm: realm, objectType: ModelModule_realm.self, id: moduleId) else {
 return nil
 }
 
 try realm.write {
 moduleRealm.topics.append(topicRealm)
 }
 return moduleRealm.module
 } catch let error as NSError {
 print("Realm error: \(error.localizedDescription)")
 return nil
 }
 }
 
 func updateTopic(moduleId: String, topic: Topic) -> Module? {
 do {
 guard let moduleRealm = getRealmObject(realm: realm, objectType: ModelModule_realm.self, id: moduleId) else {
 return nil
 }
 
 guard let realmTopic = moduleRealm.topics.first(where: {$0.id == topic.id}) else {
 return nil
 }
 
 try realm.write {
 realmTopic.updateFrom(topic: topic)
 }
 return moduleRealm.module
 } catch let error as NSError {
 print("Realm error: \(error.localizedDescription)")
 return nil
 }
 }
 
 func deleteTopic(moduleId: String, topic: Topic) -> Module? {
 do {
 guard let moduleRealm = realm.object(ofType: ModelModule_realm.self, forPrimaryKey: moduleId) else {
 return nil
 }
 
 guard let index = moduleRealm.topics.firstIndex(where: {$0.id == topic.id}) else {
 return nil
 }
 
 guard let realmTopic = moduleRealm.topics.first(where: {$0.id == topic.id}) else {
 return nil
 }
 
 try realm.write {
 moduleRealm.topics.remove(at: index)
 realm.delete(realmTopic)
 }
 return moduleRealm.module
 
 } catch let error as NSError {
 print("Realm error: \(error.localizedDescription)")
 return nil
 }
 }
 
 func learnedWord(id: String) -> LearnedWord? {
 guard let word = realm.object(ofType: ModelLearnedWord_realm.self, forPrimaryKey: id) else {
 return nil
 }
 return word.learnedWord
 }
 
 func addWord(topicId: String, word: LearnedWord) -> Topic? {
 do {
 let realmLearnWord = ModelLearnedWord_realm(learnedWord: word)
 
 guard let realmTopic = getRealmObject(realm: realm,
 objectType: ModelTopic_realm.self,
 id: topicId) else {
 return nil
 }
 try realm.write {
 realmTopic.words.append(realmLearnWord)
 }
 return realmTopic.topic
 
 } catch let error as NSError {
 print("Realm error: \(error.localizedDescription)")
 return nil
 }
 }
 
 func updateWord(topicId: String, word: LearnedWord) -> Topic? {
 do {
 guard let realmTopic = getRealmObject(realm: realm,
 objectType: ModelTopic_realm.self,
 id: topicId) else {
 return nil
 }
 
 guard let realmWord = getRealmObject(realm: realm,
 objectType: ModelLearnedWord_realm.self,
 id: word.id) else {
 return nil
 }
 
 try realm.write {
 realmWord.updateFrom(word)
 }
 return realmTopic.topic
 
 } catch let error as NSError {
 print("Realm error: \(error.localizedDescription)")
 return nil
 }
 }
 
 func deleteWord(topicId: String, word: LearnedWord) -> Topic? {
 do {
 guard let realmTopic = getRealmObject(realm: realm,
 objectType: ModelTopic_realm.self,
 id: topicId) else {
 return nil
 }
 
 guard let index = realmTopic.words.firstIndex(where: {$0.id == word.id}) else {
 return nil
 }
 
 let realmLearningWord = realmTopic.words[index]
 
 try realm.write {
 realmTopic.words.remove(at: index)
 realm.delete(realmLearningWord)
 }
 return realmTopic.topic
 } catch let error as NSError {
 print("Realm error: \(error.localizedDescription)")
 return nil
 }
 }
 
 func word(id: String) -> WordPair? {
 guard let word = realm.object(ofType: ModelWordPair_realm.self, forPrimaryKey: id) else {
 return nil
 }
 return word.wordPair
 }
 
 func updateWord(learnedWordId: String, word: WordPair) -> LearnedWord? {
 do {
 guard let realmLearnedWord = realm.object(ofType: ModelLearnedWord_realm.self, forPrimaryKey: learnedWordId) else {
 return nil
 }
 try realm.write {
 realmLearnedWord.word?.updateFrom(wordPair: word)
 }
 return realmLearnedWord.learnedWord
 } catch let error as NSError {
 print("Realm error: \(error.localizedDescription)")
 return nil
 }
 }
 
 
 }
 */

//
//  EntryController.swift
//  Journal CoreData
//
//  Created by Iyin Raphael on 1/22/19.
//  Copyright © 2019 Iyin Raphael. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    init(){
        fetchEntriesFromServer()
    }
    
    typealias CompletionHandler = (Error?) -> Void
    let baseURL = URL(string: "https://journal-coredata-3d3fc.firebaseio.com/")!
    let moc = CoreDataStack.shared.mainContext
    
    func saveToPersistence() {
        
        do {
           try moc.save()
        } catch {
            moc.reset()
            NSLog("Error occur trying to save to context \(error)")
        }
    }
    
    func updateEntry(entry: Entry, title: String, bodytext: String, mood: String, date: Date = Date() ){
        entry.title = title
        entry.bodyText = bodytext
        entry.mood = mood
        entry.date = date
    }
    
    func update(entry: Entry, entryRepresentation: EntryRepresentation){
        entry.title = entryRepresentation.title
        entry.bodyText = entryRepresentation.bodyText
        entry.date = entryRepresentation.date
        entry.mood = entryRepresentation.mood
        
        put(entry: entry)
    }
    
    func delete(_ entry: Entry){
        deleteEntryFromServer(entry: entry)
        moc.delete(entry)
        saveToPersistence()
    }
}

extension EntryController {
    
    func put(entry: Entry, completionHandler: @escaping CompletionHandler = {_ in }) {
        let identifier = entry.identity ?? UUID()
        
        let url = baseURL.appendingPathComponent(identifier.uuidString)
                        .appendingPathExtension("json")
        var urlRequest =  URLRequest(url: url)
        urlRequest.httpMethod = "PUT"

        do {
            let jsonEncoder = JSONEncoder()
            urlRequest.httpBody = try jsonEncoder.encode(entry)
        } catch {
            NSLog("Error encoding data: \(error)")
            completionHandler(error)
            return
        }
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                NSLog("Error putting data to server: \(error)")
            }
            completionHandler(nil)
        }.resume()
    }


    func deleteEntryFromServer(entry: Entry, completionHandler: @escaping CompletionHandler = {_ in }){
        let url = baseURL.appendingPathComponent(entry.identity!.uuidString)
                        .appendingPathExtension("json")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: urlRequest) { (_, _, error) in
            if let error = error {
                NSLog("Error putting data to server: \(error)")
                completionHandler(error)
            }
            completionHandler(nil)
        }.resume()
        
    }
    
    func fetchSingleEntryFromPersisitenceStore(identity: UUID) -> Entry?{
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identity == %@", identity as NSUUID)
        return (try? moc.fetch(fetchRequest))?.first
    }
    
    func fetchEntriesFromServer(completionHandler: @escaping CompletionHandler = {_ in}) {
        let url = baseURL.appendingPathExtension("json")
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else {
                NSLog("Data not found on database")
                completionHandler(NSError())
                return
            }
            
            if let error = error {
                NSLog("Error fetching data task: \(error)")
                completionHandler(error)
                return
            }
            
            do{
                let entryRepresetationDict = try JSONDecoder().decode([String: EntryRepresentation].self, from: data)
                let entryRepresentations = Array(entryRepresetationDict.values)
                for entryRep in entryRepresentations {
                    if let entry = self.fetchSingleEntryFromPersisitenceStore(identity: entryRep.identity){
                        self.update(entry: entry, entryRepresentation: entryRep)
                    }else {
                        let _ = Entry(entryRepresentation: entryRep)
                    }
                }
                self.saveToPersistence()
                completionHandler(nil)
            }catch{
                NSLog("Error occured trying to retrieve data from dataBase \(error)")
                completionHandler(error)
                return
            }
        }.resume()
    }
}

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
    
}

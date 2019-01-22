//
//  EntryController.swift
//  Journal CoreData
//
//  Created by Iyin Raphael on 1/22/19.
//  Copyright © 2019 Iyin Raphael. All rights reserved.
//

import Foundation

class EntryController {
    
    let moc = CoreDataStack.shared.mainContext
    
    func saveToPersistence() {
        
        do {
           try moc.save()
        } catch {
            NSLog("Error occur trying to save to context \(error)")
        }
    }
    
    
    
    func update(entry: Entry, title: String, bodytext: String, date: Date = Date(), mood: String){
        entry.title = title
        entry.bodyText = bodytext
        entry.date = date
        entry.mood = mood
    }
}

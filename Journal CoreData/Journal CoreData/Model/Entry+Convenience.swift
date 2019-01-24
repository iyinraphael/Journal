//
//  Entry+Convenience.swift
//  Journal CoreData
//
//  Created by Iyin Raphael on 9/24/18.
//  Copyright © 2018 Iyin Raphael. All rights reserved.
//

import Foundation
import CoreData

extension Entry{
    
    convenience init(title: String, bodyText: String? = nil, date: Date = Date(), mood: MoodType = .normal, identity: UUID = UUID(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.date = date
        self.mood = mood.rawValue
        self.identity = identity
        
        
    }
    convenience init?(entryRepresentation: EntryRepresentation, manageObjectContext: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        self.init(title: entryRepresentation.title, bodyText: entryRepresentation.bodyText, date: entryRepresentation.date, mood: MoodType(rawValue: entryRepresentation.mood)!, identity: entryRepresentation.identity, context: manageObjectContext)
    }
}


//extension Entry {
//
//
//    var newIdentity: UUID {
//
//        get {
//            return identity ?? UUID()
//        }
//
//        set {
//            identity = newValue
//        }
//    }
//}

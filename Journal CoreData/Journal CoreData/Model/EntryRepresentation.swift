//
//  EntryRepresentation.swift
//  Journal CoreData
//
//  Created by Iyin Raphael on 1/23/19.
//  Copyright © 2019 Iyin Raphael. All rights reserved.
//

import Foundation

struct EntryRepresentation: Decodable {
    var title: String
    var bodyText: String
    var date: Date
    var identity: UUID
    var mood: String
    
}


func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return
            lhs.title == rhs.title &&
            lhs.bodyText == rhs.bodyText &&
            lhs.date == rhs.date &&
            lhs.mood == rhs.mood &&
            lhs.identity == rhs.identity
}


func ==(lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return
            lhs.title == rhs.title &&
            lhs.bodyText == rhs.bodyText &&
            lhs.date == rhs.date &&
            lhs.mood == rhs.mood &&
            lhs.identity == rhs.identity
}

func !=(lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return
            lhs.title != rhs.title &&
            lhs.bodyText != rhs.bodyText &&
            lhs.date != rhs.date &&
            lhs.mood != rhs.mood &&
            lhs.identity != rhs.identity
}

func !=(lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return
        lhs.title != rhs.title &&
            lhs.bodyText != rhs.bodyText &&
            lhs.date != rhs.date &&
            lhs.mood != rhs.mood &&
            lhs.identity != rhs.identity
}

//
//  MoodType.swift
//  Journal CoreData
//
//  Created by Iyin Raphael on 1/22/19.
//  Copyright © 2019 Iyin Raphael. All rights reserved.
//

import Foundation

enum MoodType: String, CaseIterable {
    case sad = "😟"
    case normal = "😐"
    case happy = "😊"
    
}


extension Entry {
    var moodType: MoodType {
        get {
            return MoodType(rawValue: mood!) ?? .normal
        }set {
            mood = newValue.rawValue
        }
    }
}

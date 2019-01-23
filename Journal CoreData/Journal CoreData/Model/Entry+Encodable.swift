//
//  Entry+Encodable.swift
//  Journal CoreData
//
//  Created by Iyin Raphael on 1/23/19.
//  Copyright © 2019 Iyin Raphael. All rights reserved.
//

import Foundation

extension Entry: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case title
        case bodytext
        case date
        case identity
        case mood
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.title, forKey: .title)
        try container.encode(self.bodyText, forKey: .bodytext)
        try container.encode(self.date, forKey: .date)
        try container.encode(self.identity, forKey: .identity)
        try container.encode(self.mood, forKey: .mood)
      
    }
}

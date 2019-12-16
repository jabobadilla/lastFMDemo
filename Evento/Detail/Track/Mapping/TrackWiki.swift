//
//  Data.swift
//  Evento
//
//  Created by Juan Antonio Bobadilla on 12/12/19.
//  Copyright © 2019 pretechmobile. All rights reserved.
//

import Foundation
import ObjectMapper

struct TrackWiki : Mappable {
    var published : String?
    var summary : String?
    var content : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        published <- map["published"]
        summary <- map["summary"]
        content <- map["content"]
        
    }
    
}

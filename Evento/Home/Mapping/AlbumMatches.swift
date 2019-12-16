//
//  Data.swift
//  Evento
//
//  Created by Juan Antonio Bobadilla on 12/12/19.
//  Copyright © 2019 pretechmobile. All rights reserved.
//

import Foundation
import ObjectMapper

struct AlbumMatches : Mappable {
    var album : [Album]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        album <- map["album"]
    }
    
}

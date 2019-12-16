//
//  Data.swift
//  Evento
//
//  Created by Juan Antonio Bobadilla on 12/12/19.
//  Copyright © 2019 pretechmobile. All rights reserved.
//

import Foundation
import ObjectMapper

struct AlbumTrack : Mappable {
    var name : String?
    var url : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        name <- map["name"]
        url <- map["url"]
        
    }
    
}

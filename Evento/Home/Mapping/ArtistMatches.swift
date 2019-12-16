//
//  Data.swift
//  Evento
//
//  Created by Juan Antonio Bobadilla on 12/12/19.
//  Copyright © 2019 pretechmobile. All rights reserved.
//

import Foundation
import ObjectMapper

struct ArtistMatches : Mappable {
    var artist : [Artist]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        artist <- map["artist"]
    }
    
}

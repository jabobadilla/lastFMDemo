//
//  Data.swift
//  Evento
//
//  Created by Juan Antonio Bobadilla on 12/12/19.
//  Copyright © 2019 pretechmobile. All rights reserved.
//

import Foundation
import ObjectMapper

struct TrackTag : Mappable {
    var tag : [Tag]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        tag <- map["tag"]
        
    }
    
}

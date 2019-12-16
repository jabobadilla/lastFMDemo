//
//  Clima.swift
//  Evento
//
//  Created by Juan Antonio Bobadilla on 12/12/19.
//  Copyright © 2019 pretechmobile. All rights reserved.
//

import Foundation
import ObjectMapper

struct TrackDetail : Mappable {
    var track : TrackDetailData?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        track <- map["track"]
    }
    
}


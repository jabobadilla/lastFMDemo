//
//  Data.swift
//  Evento
//
//  Created by Juan Antonio Bobadilla on 12/12/19.
//  Copyright © 2019 pretechmobile. All rights reserved.
//

import Foundation
import ObjectMapper

struct SimilarArtistData : Mappable {
    var artist : [SimilarArtist]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        artist <- map["artist"]
    }
    
}

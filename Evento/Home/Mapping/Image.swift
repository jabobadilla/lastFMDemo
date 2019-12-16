//
//  AlbumImage.swift
//  Evento
//
//  Created by Juan Antonio Bobadilla on 12/12/19.
//  Copyright © 2019 pretechmobile. All rights reserved.
//

import Foundation
import ObjectMapper

struct Image : Mappable {
    var text : String?
    var size : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        text <- map["#text"]
        size <- map["size"]
    }
    
}

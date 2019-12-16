//
//  AlbumImage.swift
//  Evento
//
//  Created by Juan Antonio Bobadilla on 12/12/19.
//  Copyright © 2019 pretechmobile. All rights reserved.
//

import Foundation
import ObjectMapper

struct SimilarArtist : Mappable {
    var name : String?
    var url : String?
    var image : [Image]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        name <- map["name"]
        url <- map["url"]
        image <- map["image"]
    }
    
}

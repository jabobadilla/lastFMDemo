//
//  Data.swift
//  Evento
//
//  Created by Juan Antonio Bobadilla on 12/12/19.
//  Copyright © 2019 pretechmobile. All rights reserved.
//

import Foundation
import ObjectMapper

struct TrackAlbum : Mappable {
    var artist : String?
    var title : String?
    var url : String?
    var image : [Image]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        artist <- map["artist"]
        title <- map["title"]
        url <- map["url"]
        image <- map["image"]
        
    }
    
}

//
//  Data.swift
//  Evento
//
//  Created by Juan Antonio Bobadilla on 12/12/19.
//  Copyright © 2019 pretechmobile. All rights reserved.
//

import Foundation
import ObjectMapper

struct TrackDetailData : Mappable {
    var name : String?
    var url : String?
    var album : TrackAlbum?
    var toptags : TrackTag?
    var wiki : TrackWiki?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        name <- map["name"]
        url <- map["url"]
        album <- map["album"]
        toptags <- map["toptags"]
        wiki <- map["wiki"]
        
    }
    
}

//
//  Data.swift
//  Evento
//
//  Created by Juan Antonio Bobadilla on 12/12/19.
//  Copyright © 2019 pretechmobile. All rights reserved.
//

import Foundation
import ObjectMapper

struct ArtistDetailData : Mappable {
    var name : String?
    var url : String?
    var image : [Image]?
    var similar : SimilarArtistData?
    var bio : ArtistBio?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        name <- map["name"]
        url <- map["url"]
        image <- map["image"]
        similar <- map["similar"]
        bio <- map["bio"]
        
    }
    
}

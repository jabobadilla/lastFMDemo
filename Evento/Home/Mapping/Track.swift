//
//  Data.swift
//  Evento
//
//  Created by Juan Antonio Bobadilla on 12/12/19.
//  Copyright © 2019 pretechmobile. All rights reserved.
//

import Foundation
import ObjectMapper

struct Track : Mappable {
    var name : String?
    var artist : String?
    var url : String?
    var image : [Image]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        name <- map["name"]
        artist <- map["artist"]
        url <- map["url"]
        image <- map["image"]
    }
    
}

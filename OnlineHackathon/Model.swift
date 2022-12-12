//
//  Model.swift
//  OnlineHackathon
//
//  Created by Ruslan Ismailov on 09/12/22.
//

import Foundation
import ObjectMapper

class Photos: Mappable {
    
    var photos: [PhotoModel] = []
    
    required init?(map: ObjectMapper.Map) {
        
    }
    
    func mapping(map: ObjectMapper.Map) {
        photos <- map["photos"]
    }
    
    
    
}

class PhotoModel: Mappable {
    
    var title: String = ""
    var photographer: String = ""
    var photoSize: PhotoSize?
    var linkToPhotographer: String = ""
    
    
    required init?(map: ObjectMapper.Map) {
        
    }
    
    func mapping(map: ObjectMapper.Map) {
        title <- map["alt"]
        photographer <- map["photographer"]
        photoSize <- map["src"]
        linkToPhotographer <- map["photographer_url"]
    }
}

class PhotoSize: Mappable {
    
    var tiny: String = ""
    var portrait: String = ""
    
    required init?(map: ObjectMapper.Map) {
        
    }
    
    func mapping(map: ObjectMapper.Map) {
        tiny <- map["tiny"]
        portrait <- map["portrait"]
    }
    
}

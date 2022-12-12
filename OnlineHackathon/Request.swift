//
//  Request.swift
//  OnlineHackathon
//
//  Created by Ruslan Ismailov on 07/12/22.
//

import Foundation
import Moya

private let apiKey = "563492ad6f91700001000001ab6e8e8097304bfa90afbdd9ab3af2fe"

enum PixelsEnum: TargetType {
    
    case getPhoto(perPage: Int, page: Int)
    case search(searchRequest: String, page: Int)
    
    var baseURL: URL {
        guard let url = URL(string: "https://api.pexels.com/v1") else {fatalError()}
        return url
    }
    
    var path: String {
        switch self{
        case .getPhoto:
            return "/curated"
        case .search:
            return "/search"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self{
        case let .getPhoto(perPage, page):
            return .requestParameters(parameters: ["per_page" : perPage, "page" : page], encoding: URLEncoding.queryString)
        case let .search(searchRequest, page):
            return .requestParameters(parameters: ["query": searchRequest, "per_page" : 30, "page" : page], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Authorization" : apiKey]
    }
    
    
}

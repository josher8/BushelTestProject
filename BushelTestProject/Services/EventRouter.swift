//
//  EventRouter.swift
//  BushelTestProject
//
//  Created by Josh Slebodnik on 1/8/20.
//  Copyright © 2020 Josh Slebodnik. All rights reserved.
//

import Foundation
import Alamofire

public enum EventRouter: URLRequestConvertible {
    
    enum EventConstants {
        //Base URL Path. Gets configuration variables from info plist. Would be different base url for Dev and Prod
        static let baseURLPath = "https://challenge.myriadapps.com/api/v1"
    }
    
    case events
    case eventID(String)
    case speakers(String)
    
    var method: HTTPMethod {
        
        switch self {
        case .events, .eventID, .speakers:
            return .get
        }
        
    }
    
    var path: String {
        
        switch self {
        case .events:
            return "/events"
        case .eventID(let eventID):
            return "/events/" + eventID
        case .speakers(let speakerID):
            return "/speakers/" + speakerID
        }
        
    }
    
//    var parameters: [String : Any] {
//
//        switch self {
//        case .eventID(let id):
//            return ["":id]
//        case .speakers(let id):
//            return ["id":id]
//        default:
//            return [:]
//        }
//
//    }
    
    public func asURLRequest() throws -> URLRequest {
        
        let url = try EventConstants.baseURLPath.asURL()
        
        //Gets token from user defaults.
        var token = ""
        if UserDefaults.standard.object(forKey: "token") != nil{
            token = UserDefaults.standard.object(forKey: "token") as! String
        }
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        return try URLEncoding.default.encode(request, with: nil)
        
    }
    
}

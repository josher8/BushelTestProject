//
//  LoginRouter.swift
//  BushelTestProject
//
//  Created by Josh Slebodnik on 1/7/20.
//  Copyright © 2020 Josh Slebodnik. All rights reserved.
//

import Foundation
import Alamofire

public enum LoginRouter: URLRequestConvertible {
    
    enum LoginConstants {
        //Base URL Path
        static let baseURLPath = "https://challenge.myriadapps.com/api/v1"
    }
    
    case login(String, String)
    
    var method: HTTPMethod {
        
        switch self {
        case .login:
            return .post
        }
        
    }
    
    var path: String {
        
        switch self {
        case .login:
            return "/login"
        }
        
    }
    
    var parameters: [String : Any] {
        
        switch self {
        case .login(let Username, let Password):
            return ["Username": Username, "Password" : Password]
        }
        
    }
    
    public func asURLRequest() throws -> URLRequest {
        
        let url = try LoginConstants.baseURLPath.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        
        return try URLEncoding.default.encode(request, with: parameters)
        
    }
    
}

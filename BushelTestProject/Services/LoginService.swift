//
//  LoginService.swift
//  BushelTestProject
//
//  Created by Josh Slebodnik on 1/7/20.
//  Copyright © 2020 Josh Slebodnik. All rights reserved.
//

import Foundation
import Alamofire

class LoginService {
    
     func login(username:String, password: String, completion: @escaping (Token?) -> Void){
        
        Alamofire.request(LoginRouter.login(username,password)).responseString { response in
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while getting token: \(String(describing: response.result.error))")
                    completion(nil)
                    return
            }
            completion(Token(json: value))
        }
        
    }
}

//
//  EventService.swift
//  BushelTestProject
//
//  Created by Josh Slebodnik on 1/8/20.
//  Copyright © 2020 Josh Slebodnik. All rights reserved.
//

import Foundation
import Alamofire

class EventService{

    func loadEventList(completion: @escaping ([Event]?) -> Void){
        
        Alamofire.request(EventRouter.events).responseString { response in
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error while getting events: \(String(describing: response.result.error))")
                    completion(nil)
                    return
            }
            completion([Event](json: value))
        }
    }

}

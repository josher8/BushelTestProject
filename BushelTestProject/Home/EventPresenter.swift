//
//  EventPresenter.swift
//  BushelTestProject
//
//  Created by Josh Slebodnik on 1/8/20.
//  Copyright © 2020 Josh Slebodnik. All rights reserved.
//

import Foundation


protocol EventViewDelegate: NSObjectProtocol {
    func loadEvents()
    func presentEventLoadErrorDialog()
}

class EventPresenter{
    
    private let eventService: EventService
    weak private var eventViewDelegate: EventViewDelegate?
    
    var eventArray: [Event] = []
    
    init(eventService: EventService){
        self.eventService = eventService
    }
    
    public func setViewDelegate(eventViewDelegate: EventViewDelegate){
        self.eventViewDelegate = eventViewDelegate
    }
    
    func loadEventList(){
        self.eventService.loadEventList(completion: {
            events in
            
            if events != nil{
                self.eventArray = events!
                self.eventViewDelegate?.loadEvents()
            }else{
                self.eventViewDelegate?.presentEventLoadErrorDialog()
            }
            
        })
    }
    
    public func getEvents() -> [Event]{
        return eventArray
    }
    
    //Clears user token
    public func clearToken(){
        if UserDefaults.standard.object(forKey: "token") != nil{
            UserDefaults.standard.set(nil, forKey: "token")
        }
    }
    
    
}

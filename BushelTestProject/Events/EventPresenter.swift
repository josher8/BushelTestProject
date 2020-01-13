//
//  EventPresenter.swift
//  BushelTestProject
//
//  Created by Josh Slebodnik on 1/8/20.
//  Copyright © 2020 Josh Slebodnik. All rights reserved.
//

import Foundation


protocol EventListViewDelegate: NSObjectProtocol {
    
    func loadEvents()
    func presentEventLoadErrorDialog()
    func presentLoginScreen()
    func hideTable()
    func showSpinner()
    func hideSpinner()
}



class EventPresenter{
    
    private let eventService: EventService
    weak private var eventListViewDelegate: EventListViewDelegate?
    
    private var eventArray: [Event] = []
        
    init(){
        
        self.eventService = EventService()
        
    }
    
    //------------------- HomeViewController methods 
    
    //Sets Eventlist delegate in HomeViewController
    public func setEventListViewDelegate(eventListViewDelegate: EventListViewDelegate){
        
        self.eventListViewDelegate = eventListViewDelegate
        
    }

    //Loads Event List in HomeView Controller
    func populateEventList(){
        
        self.eventListViewDelegate?.showSpinner()
        
        self.eventService.loadEventList(completion: {
            events in
            
            self.eventListViewDelegate?.hideSpinner()
            
            guard let events = events else { self.eventListViewDelegate?.presentEventLoadErrorDialog(); return }
            
            self.eventArray = events
            self.eventListViewDelegate?.loadEvents()
        })
        
    }

    //Get Event Array
    public func getEvents() -> [Event]{
        
        return eventArray
        
    }

    //Clears user token
    public func clearToken(){
        
        if UserDefaults.standard.object(forKey: "token") != nil{
            
            UserDefaults.standard.set(nil, forKey: "token")
            
        }
        
    }
    
    public func signOut(){
        
        //Removes token and empties array.
        if UserDefaults.standard.object(forKey: "token") != nil{
            
            UserDefaults.standard.set(nil, forKey: "token")
            eventArray.removeAll()
            //Hides and reloads table in case there is data in view
            self.eventListViewDelegate?.hideTable()
            self.eventListViewDelegate?.presentLoginScreen()
            
        }else{
            
            self.eventListViewDelegate?.hideTable()
            self.eventListViewDelegate?.presentLoginScreen()
            
        }
    }
    
    public func presentLoginScreen(){
        
        self.eventListViewDelegate?.presentLoginScreen()
        
    }

}

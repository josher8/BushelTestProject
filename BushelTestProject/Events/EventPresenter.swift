//
//  EventPresenter.swift
//  BushelTestProject
//
//  Created by Josh Slebodnik on 1/8/20.
//  Copyright © 2020 Josh Slebodnik. All rights reserved.
//

import Foundation


protocol EventListView: class {
    
    func loadEvents()
    func presentEventLoadErrorDialog()
    func presentLoginScreen()
    func hideTable()
    func showSpinner()
    func hideSpinner()
}



class EventPresenter{
    
    private let eventService: EventService
    weak private var eventListView: EventListView?
    
    private var eventArray: [Event] = []
        
    init(with view: EventListView){
        
        self.eventListView = view.self
        self.eventService = EventService()
        
    }

    //Loads Event List in HomeView Controller
    func populateEventList(){
        
        self.eventListView?.showSpinner()
        
        self.eventService.loadEventList(completion: {
            events in
            
            self.eventListView?.hideSpinner()
            
            guard let events = events else { self.eventListView?.presentEventLoadErrorDialog(); return }
            
            self.eventArray = events
            self.eventListView?.loadEvents()
        })
        
    }

    //Get Event Array
    public func getEvents() -> [Event]{
        
        return eventArray
        
    }

    //Clears user token
    public func clearToken(){

        UserDefaults.standard.set(nil, forKey: "token")

    }
    
    public func signOut(){
        
        //Removes token,empties array, and goes to login screen.
        if UserDefaults.standard.object(forKey: "token") != nil{
            
            clearToken()
            eventArray.removeAll()
            //Hides and reloads table in case there is data in view
            self.eventListView?.hideTable()
            self.eventListView?.presentLoginScreen()
            
        }
    }


}

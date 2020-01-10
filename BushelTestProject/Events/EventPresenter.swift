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

protocol SingleEventViewDelegate: NSObjectProtocol {
    
    func loadEvent()
    func loadSpeakers()
    func showSpinner()
    func hideSpinner()
}

class EventPresenter{
    
    private let eventService: EventService
    weak private var eventListViewDelegate: EventListViewDelegate?
    weak private var singleEventViewDelegate: SingleEventViewDelegate?
    
    var eventArray: [Event] = []
    var speakerArray: [Speaker] = []
    
    var event: Event?
    var eventID: String?
    
    init(eventService: EventService){
        
        self.eventService = eventService
        
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
            
            if events != nil{
                
                self.eventArray = events!
                self.eventListViewDelegate?.loadEvents()
                
            }else{
                
                self.eventListViewDelegate?.presentEventLoadErrorDialog()
                
            }
            
            self.eventListViewDelegate?.hideSpinner()
            
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
    
    //-------------- SingleEventView Methods -------------------
    
    //Sets Single Event View delegate in HomeViewController
    public func setSingleEventViewDelegate(singleEventViewDelegate: SingleEventViewDelegate){
        
        self.singleEventViewDelegate = singleEventViewDelegate
        
    }
    
    //Loads event data
    func populateEventandSpeakers(eventID: String){
        
        //Clears Event and speaker array
        event = nil
        speakerArray.removeAll()
        self.singleEventViewDelegate?.showSpinner()
        
        self.eventService.loadEvent(eventID: eventID, completion: {
            event in
            
            if event != nil {
                
                self.event = event!
                
                self.singleEventViewDelegate?.loadEvent()
                self.populateSpeakers(event: event!)
                 
            }
            self.singleEventViewDelegate?.hideSpinner()
            
        })
        
        
    }
    
    //Populate Speakers
    public func populateSpeakers(event: Event){
        
        //Speakers
        for (index, speakerID) in self.event!.speakers.enumerated() {
            
            self.eventService.loadSpeaker(speakerID: String(speakerID.id), completion: {
                speaker in

                if speaker != nil{
                    
                    self.speakerArray.append(speaker!)
                    
                }
                
                //Loads the speakers after all the speakers been added to array
                if(index == (self.event!.speakers.count - 1)){
                    self.singleEventViewDelegate?.loadSpeakers()
                    
                }
                
            })
            
        }
        
    }
    
    //Get single Event
     public func getEvent() -> Event {
         return event!
         
     }
     
     //Get Speakers
     public func getSpeakersArray() -> [Speaker] {
         
         return speakerArray
     }

}

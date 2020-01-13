//
//  SingleEventPresenter.swift
//  BushelTestProject
//
//  Created by Josh Slebodnik on 1/13/20.
//  Copyright © 2020 Josh Slebodnik. All rights reserved.
//

import Foundation

protocol SingleEventView: class {
    
    func loadEvent(event: Event)
    func loadSpeakers()
    func showSpinner()
    func hideSpinner()
    func presentEventLoadErrorDialog()
    func presentSpeakerLoadErrorDialog()
    func openMaps(url: URL)
}

class SingleEventPresenter {
    
    private let eventService: EventService
    weak private var singleEventView: SingleEventView?
    
    private var speakerArray: [Speaker] = []
    
    private var eventID: String?
    private var event: Event?
    
    init(with view: SingleEventView, eventID: String){
        
        self.singleEventView = view.self
        self.eventID = eventID
        self.eventService = EventService()
        
    }
    
    //Loads event data
    func populateEventandSpeakers(){
        
        self.singleEventView?.showSpinner()
        
        self.eventService.loadEvent(eventID: eventID ?? "", completion: {
            event in
            
            self.singleEventView?.hideSpinner()
            guard let event = event else { self.singleEventView?.presentEventLoadErrorDialog(); return }
            
            self.event = event
            
            self.singleEventView?.loadEvent(event: event)
            
            //Should show spinner then hide in the populate speakers function. This does not seem to be working properly though with that recursive function.
//            self.singleEventView?.showSpinner()
            self.populateSpeakers(speakers: event.speakers)

            
        })
        
        
    }

    public func populateSpeakers(speakers: [SpeakerID]) {
        
//        if speakers.isEmpty == true {
//
//            self.singleEventView?.hideSpinner()
//
//        }
        
        guard let firstSpeaker = speakers.first else { self.singleEventView?.loadSpeakers(); return }

        self.eventService.loadSpeaker(speakerID: String(firstSpeaker.id)) { (speaker) in

            guard let speaker = speaker else { self.singleEventView?.presentSpeakerLoadErrorDialog(); return } //TODO:

            self.speakerArray.append(speaker)

            var newSpeakers = speakers
            newSpeakers.removeFirst()
            self.populateSpeakers(speakers: newSpeakers)
            
        }
    }

     //Get Speakers
     public func getSpeakersArray() -> [Speaker] {
         
         return speakerArray
        
     }
    
    public func openMapsFromEvenLocation(){
        
        //Opens in Apple Maps
        let mapsURL = "http://maps.apple.com/?address=" + (event?.location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        if let locationURL = URL(string: mapsURL) {

            self.singleEventView?.openMaps(url: locationURL)

        }
        
        
    }
    
}

//
//  SingleEventViewController.swift
//  BushelTestProject
//
//  Created by Josh Slebodnik on 1/9/20.
//  Copyright © 2020 Josh Slebodnik. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class SingleEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SingleEventViewDelegate {
    
    private let eventPresenter = EventPresenter(eventService: EventService())

    @IBOutlet var eventImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var locationButton: UIButton!
    @IBOutlet var speakerLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    var eventID: String?
    
    var address: String?
    
    var tableViewHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        
        //Set's height constrait. This will change when data is reloaded.
        self.tableViewHeightConstraint = NSLayoutConstraint(item: tableView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
        
        NSLayoutConstraint.activate([self.tableViewHeightConstraint!])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        eventPresenter.setSingleEventViewDelegate(singleEventViewDelegate: self)
        eventPresenter.populateEventandSpeakers(eventID: eventID!)
    }

    @IBAction func locationBTNPressed(_ sender: UIButton) {
        
        //Opens in Apple Maps
        let mapsURL = "http://maps.apple.com/?address=" + address!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        if let locationURL = URL(string: mapsURL) {

            UIApplication.shared.open(locationURL, options: [:], completionHandler: nil)

        }
 
    }
    
    //Tableview methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return eventPresenter.getSpeakersArray().count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SpeakerTableViewCell
        
        let speaker = eventPresenter.getSpeakersArray()[indexPath.row]
        
        print(indexPath.row)
        
        if let nameLabel = cell.nameLabel {
            
            let speakerFirstName = speaker.first_name
            let speakerLastName = speaker.last_name

            nameLabel.text = "\(speakerFirstName) \(speakerLastName)"
        }
        
        if let bioLabel = cell.bioLabel {
            
            bioLabel.text = speaker.bio
            
        }
        
        return cell
        
    }
    
    //--------------Single Event Delegate methods
    
    func loadEvent(){
        
        self.title = eventPresenter.getEvent().title
        
        eventImageView.sd_setImage(with: URL(string: (eventPresenter.getEvent().image_url)) )
        
        titleLabel.text = eventPresenter.getEvent().event_description
        
        descriptionLabel.text = eventPresenter.getEvent().event_description
        
        //Set Date
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssz"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MM/dd/yyyy ha"
        let dateFormatterPrintHA = DateFormatter()
        dateFormatterPrintHA.dateFormat = "ha"
        
        //Get Start Date
        let startDate = dateFormatterGet.date(from: eventPresenter.getEvent().start_date_time)
        let startDateString = dateFormatterPrint.string(from: startDate!)
        
        //Get End Date
        let endDate = dateFormatterGet.date(from: eventPresenter.getEvent().end_date_time)
        let endDateString = dateFormatterPrintHA.string(from: endDate!)
        
        dateLabel.text = startDateString + " - " + endDateString
        
        locationButton.setTitle(eventPresenter.getEvent().location, for: UIControl.State.normal)
        
        address = eventPresenter.getEvent().location
        
    }
    
    func loadSpeakers(){
        
        //Sets speaker label
        if eventPresenter.getSpeakersArray().count > 1 {
            speakerLabel.text = "Speakers"
        }else{
            speakerLabel.text = "Speaker"
        }
        
        //Reloads tableview with speaker data and sets tableview height based on contents. View will scroll if tableview content overflows device height.
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            self.view.layoutIfNeeded()
            self.tableViewHeightConstraint!.constant = self.tableView.contentSize.height
            self.view.layoutIfNeeded()
            
        }
    }
    
    func showSpinner() {
        showSpinner(onView: self.view)
    }
    
    func hideSpinner() {
        removeSpinner()
    }
    
}

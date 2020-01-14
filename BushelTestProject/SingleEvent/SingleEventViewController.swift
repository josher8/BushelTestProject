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

class SingleEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var presenter: SingleEventPresenter!

    @IBOutlet var eventImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var locationButton: UIButton!
    @IBOutlet var speakerLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    var tableViewHeightConstraint: NSLayoutConstraint?
    
    //Initializer
    static func create(eventID: String) -> SingleEventViewController{
        
        let vc = UIStoryboard(name: "SingleEvent", bundle: nil).instantiateViewController(withIdentifier: "SingleEventViewController") as! SingleEventViewController
        vc.modalPresentationStyle = .fullScreen
        vc.presenter = SingleEventPresenter(with: vc, eventID: eventID)
        return vc
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set's height constrait. This will change when data is reloaded.
        self.tableViewHeightConstraint = NSLayoutConstraint(item: tableView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
        NSLayoutConstraint.activate([self.tableViewHeightConstraint!])
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //Loads the event data and loads speaker
        presenter?.populateEventandSpeakers()
        
    }

    @IBAction func locationBTNPressed(_ sender: UIButton) {
        
        //Opens in Apple Maps
        presenter.openMapsFromEvenLocation()
 
    }
    
    //Tableview methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter.getSpeakersArray().count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SpeakerTableViewCell
        
        let speaker = presenter.getSpeakersArray()[indexPath.row]
        
        print(indexPath.row)
        
        //Speaker Name label
        if let nameLabel = cell.nameLabel {
            
            let speakerFirstName = speaker.first_name
            let speakerLastName = speaker.last_name

            nameLabel.text = "\(speakerFirstName) \(speakerLastName)"
        }
        
        //Bio label
        if let bioLabel = cell.bioLabel {
            
            bioLabel.text = speaker.bio
            
        }
        
        return cell
        
    }
    
}

extension SingleEventViewController: SingleEventView {
    
    //Populates labels from Event object
    func loadEvent(event: Event){
        
        self.title = event.title
               
        eventImageView.sd_setImage(with: URL(string: (event.image_url)) )
        
        titleLabel.text = event.title
        
        descriptionLabel.text = event.event_description
        
        //Set Date
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssz"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MM/dd/yyyy ha"
        let dateFormatterPrintHA = DateFormatter()
        dateFormatterPrintHA.dateFormat = "ha"
        
        //Get Start Date
        let startDate = dateFormatterGet.date(from: event.start_date_time)
        let startDateString = dateFormatterPrint.string(from: startDate!)
        
        //Get End Date
        let endDate = dateFormatterGet.date(from: event.end_date_time)
        let endDateString = dateFormatterPrintHA.string(from: endDate!)
        
        dateLabel.text = startDateString + " - " + endDateString
        
        locationButton.setTitle(event.location, for: UIControl.State.normal)
        
    }
    
    func loadSpeakers(){
        
        //Sets speaker label
        if presenter.getSpeakersArray().count > 1 {
            speakerLabel.text = "Speakers"
        }else{
            speakerLabel.text = "Speaker"
        }
        
        //Reloads tableview with speaker data and sets tableview height based on contents. View will scroll if tableview content overflows device height.
        self.tableView.reloadData()
        self.view.layoutIfNeeded()
        self.tableViewHeightConstraint!.constant = self.tableView.contentSize.height
        self.view.layoutIfNeeded()

    }
    
    func showSpinner() {
        
        //Shows Activity Indicator from UIViewControllerExtensions
        showSpinner(onView: self.view)
        
    }
    
    func hideSpinner() {
        
        //Hides Activity Indicator from UIViewControllerExtensions
        removeSpinner()
        
    }
    
    func presentEventLoadErrorDialog(){
        
        //Error message if unable to get event data
        let alert = UIAlertController.init(title: "Error", message: "There was an error getting the event data.", preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            

        })
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func presentSpeakerLoadErrorDialog(){
        
        //Error if unable to get the speakers
        let alert = UIAlertController.init(title: "Error", message: "There was an error getting the speaker data.", preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            

        })
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func openMaps(url: URL) {
        
        //Opens address in Apple Maps
        UIApplication.shared.open(url, options: [:], completionHandler: nil)

        
    }
    
}

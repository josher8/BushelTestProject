//
//  ViewController.swift
//  BushelTestProject
//
//  Created by Josh Slebodnik on 1/7/20.
//  Copyright © 2020 Josh Slebodnik. All rights reserved.
//

import UIKit
import SDWebImage

protocol reloadEvents {
    func loadEventList()
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EventViewDelegate, reloadEvents {
    
    private let eventPresenter = EventPresenter(eventService: EventService())
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Events"
        
        eventPresenter.setViewDelegate(eventViewDelegate: self)
        
        self.tableView.isHidden = true
        
        loadEventList()

    }
    
    //Tableview methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventPresenter.getEvents().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let event = eventPresenter.getEvents()[indexPath.row]
        
        //Sets Event Image on Cell
        if let eventImageView = cell?.contentView.viewWithTag(1) as? UIImageView {
            
            eventImageView.sd_setImage(with: URL(string: event.image_url) )
            
        }
        
        //Event Title
        if let titleLabel = cell?.contentView.viewWithTag(2) as? UILabel {
            
            titleLabel.text = event.title
            
        }
        
        //Date
        if let dateLabel = cell?.contentView.viewWithTag(3) as? UILabel {
            
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
            
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Pass event object to Single Event
//        let event = eventArray[indexPath.row]
//        self.performSegue(withIdentifier: "eventSegue", sender: event)
//
//        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if segue.identifier == "eventSegue" {
//            let singleEventController = segue.destination as? SingleEventViewController
//            singleEventController?.event = sender as? Event
//        }
        
        //Set self delegate in LoginViewController so can reload table view after authentication
        if segue.identifier == "loginSegue" {
            
            let loginController = segue.destination as? LoginViewController
            loginController?.reloadListDelegate = self
            
        }
        
    }
    
    func loadEventList(){
        
        //If user hasn't logged in, show login view, else load event list
        if UserDefaults.standard.object(forKey: "token") == nil || UserDefaults.standard.object(forKey: "token") as! String == ""{
            
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            
        }else{

            eventPresenter.loadEventList()
            
        }
        
    }

    //Event Presenter Methods
    
    func loadEvents(){
        
        self.tableView.isHidden = false
        self.tableView.reloadData()
        
    }
    
    func presentEventLoadErrorDialog(){
        
        let alert = UIAlertController.init(title: "Error", message: "There was an error getting event data. Please try log in again", preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            
            self.eventPresenter.clearToken()
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        })
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        
    }

}


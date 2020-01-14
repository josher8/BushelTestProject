//
//  ViewController.swift
//  BushelTestProject
//
//  Created by Josh Slebodnik on 1/7/20.
//  Copyright © 2020 Josh Slebodnik. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EventListViewDelegate {
    
    private let eventPresenter = EventPresenter()
    
    @IBOutlet var tableView: UITableView!
    
    //Initializer
    static func create() -> HomeViewController{
        
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        vc.modalPresentationStyle = .fullScreen
//        vc.presenter = SingleEventPresenter(with: vc, eventID: eventID)
        return vc
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Events"
        
        eventPresenter.setEventListViewDelegate(eventListViewDelegate: self)
        
        self.tableView.isHidden = true
        
        loadEventList()

    }
    
    //Tableview methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return eventPresenter.getEvents().count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! EventListTableViewCell
        
        let event = eventPresenter.getEvents()[indexPath.row]
        
        //Sets Event Image on Cell
        if let eventImageView = cell.eventImageView {
            
            eventImageView.sd_setImage(with: URL(string: event.image_url) )
            
        }
        
        //Event Title
        if let titleLabel = cell.titleLabel {
            
            titleLabel.text = event.title
            
        }
        
        //Date
        if let dateLabel = cell.dateLabel {
            
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Pass event object to Single Event
        let event = eventPresenter.getEvents()[indexPath.row]
        
        let eventID = String(event.id)
        self.navigationController?.pushViewController(SingleEventViewController.create(eventID: eventID), animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func loadEventList(){
        
        //If user hasn't logged in, show login view, else load event list
        if UserDefaults.standard.object(forKey: "token") == nil || UserDefaults.standard.object(forKey: "token") as! String == ""{
            
//            eventPresenter.presentLoginScreen()
            
        }else{

            eventPresenter.populateEventList()
            
        }
        
    }
    
    //Removes user token
    @IBAction func signoutBTNPressed(_ sender: UIBarButtonItem) {
        
        eventPresenter.signOut()
        
    }

    //-------------Event Presenter Methods
    
    func loadEvents(){
        
        self.tableView.isHidden = false
        self.tableView.reloadData()
        
    }
    
    func hideTable(){
        
        //Reloads table in case there is data still in view
        tableView.reloadData()
        tableView.isHidden = true
        
        
    }
    
    func presentEventLoadErrorDialog(){
        
        let alert = UIAlertController.init(title: "Error", message: "There was an error getting event data. Please try log in again", preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            
            self.eventPresenter.clearToken()
            self.eventPresenter.presentLoginScreen()
        })
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func presentLoginScreen(){
        
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
        
    }
    
    func showSpinner() {
        showSpinner(onView: self.view)
    }
    
    func hideSpinner() {
        removeSpinner()
    }
    
}


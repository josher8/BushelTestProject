//
//  ViewController.swift
//  BushelTestProject
//
//  Created by Josh Slebodnik on 1/7/20.
//  Copyright © 2020 Josh Slebodnik. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var presenter: EventPresenter!
    
    @IBOutlet var tableView: UITableView!
    
    //Initializer
    static func create() -> HomeViewController{
        
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        vc.modalPresentationStyle = .fullScreen
        vc.presenter = EventPresenter(with: vc)
        vc.navigationItem.hidesBackButton = true
        
        vc.title = "Events"
        return vc
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation bar reappears
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.tableView.isHidden = true        
        
        //Loads Event List
        presenter.populateEventList()

    }
    
    //Tableview methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Get Events from presenter
        return presenter.getEvents().count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! EventListTableViewCell
        
        let event = presenter.getEvents()[indexPath.row]
        
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
        
        //Pass event idto Single Event
        let event = presenter.getEvents()[indexPath.row]
        
        let eventID = String(event.id)
        self.navigationController?.pushViewController(SingleEventViewController.create(eventID: eventID), animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //Removes user token
    @IBAction func signoutBTNPressed(_ sender: UIBarButtonItem) {
        
        //Signout user. Goes back to login screen.
        presenter.signOut()
        
    }
    
}

extension HomeViewController: EventListView {
    
    func loadEvents(){
        
        //Loads event list by unhiding and reloading tableview
        self.tableView.isHidden = false
        self.tableView.reloadData()
        
    }
    
    func hideTable(){
        
        //Reloads table in case there is data still in view
        tableView.reloadData()
        tableView.isHidden = true
        
        
    }
    
    func presentEventLoadErrorDialog(){
        
        //Error dialog if can't get event data
        let alert = UIAlertController.init(title: "Error", message: "There was an error getting event data. Please try log in again", preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            
            self.presenter.clearToken()
            self.presentLoginScreen()
            
        })
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func presentLoginScreen(){
        
        //Goes back to login screen from navigation controller
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func showSpinner() {
        
        //Shows Activity Indicator from UIViewControllerExtensions
        showSpinner(onView: self.view)
        
    }
    
    func hideSpinner() {
        
        //Hides Activity Indicator from UIViewControllerExtensions
        removeSpinner()
        
    }
    
    
    
}


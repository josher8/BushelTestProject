//
//  ViewController.swift
//  BushelTestProject
//
//  Created by Josh Slebodnik on 1/7/20.
//  Copyright © 2020 Josh Slebodnik. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //If user hasn't logged in, show login view, else load event list
        if UserDefaults.standard.object(forKey: "token") == nil || UserDefaults.standard.object(forKey: "token") as! String == ""{
            
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            
        }
        
    }

    
    

}


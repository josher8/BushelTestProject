//
//  UIViewControllerExtensions.swift
//  BushelTestProject
//
//  Created by Josh Slebodnik on 1/10/20.
//  Copyright © 2020 Josh Slebodnik. All rights reserved.
//

import Foundation
import UIKit

var vSpinner : UIView?
 
extension UIViewController {
    
    func showSpinner(onView : UIView) {
        
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center

        spinnerView.addSubview(ai)
        onView.addSubview(spinnerView)

        vSpinner = spinnerView
        
    }
    
    func removeSpinner() {

        vSpinner?.removeFromSuperview()
        vSpinner = nil

    }
}

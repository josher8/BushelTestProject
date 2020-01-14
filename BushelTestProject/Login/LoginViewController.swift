//
//  LoginViewController.swift
//  BushelTestProject
//
//  Created by Josh Slebodnik on 1/7/20.
//  Copyright © 2020 Josh Slebodnik. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate  {
    
    var presenter: LoginPresenter?

    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var loginLabel: UILabel!
    @IBOutlet var appName: UILabel!
    @IBOutlet var stackView: UIStackView!
    
    var textFieldTapRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Init Presenter
        presenter = LoginPresenter(with: self)
        
        //Tryign stuff here. Will change after review
//        stackView.setCustomSpacing(400, after: appName)
        stackView.setCustomSpacing(8, after: usernameField)
//        stackView.setCustomSpacing(50, after: passwordField)
        
        
        //Set Textfield Delegate
        usernameField.delegate = self
        passwordField.delegate = self
        
        //Add Text Field recognizer on view so you can dismiss the textfield
        textFieldTapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.handleTextFieldTap(_:)))
        textFieldTapRecognizer.cancelsTouchesInView = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        presenter?.detectToken()
        
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Return button will go from username to Password, then will login from password
        textField.resignFirstResponder()
        self.view.removeGestureRecognizer(textFieldTapRecognizer)
        
        if textField == self.usernameField {
            passwordField.becomeFirstResponder()
        }
        
        if textField == self.passwordField{
            loginPressed()
        }
        
        return true
    }
    
    @objc func handleTextFieldTap(_ tapGestureRecognizer:UITapGestureRecognizer){
        
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        view.removeGestureRecognizer(textFieldTapRecognizer)
        
    }
    
    func loginPressed() {
        
        //Login User
        presenter?.loginUserSaveToken(username: usernameField.text!, password: passwordField.text!)

    }
    
    @IBAction func loginBTNPressed(_ sender: UIButton) {
        
        loginPressed()
        
    }
    
}

extension LoginViewController: LoginView {
        
    func presentLoginError() {
        
        let alert = UIAlertController.init(title: "Error", message: "There was an error logging in.", preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: {action in })
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func presentInvalidCredentialsError(){
        
        let alert = UIAlertController.init(title: "Error", message: "Please Enter a Valid Username and Password", preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: {action in })
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showSpinner() {
        showSpinner(onView: self.view)
    }
    
    func hideSpinner() {
        removeSpinner()
    }
    
    func presentHome(){
        
        self.navigationController?.pushViewController(HomeViewController.create(), animated: true)
        
    }
    
    
}




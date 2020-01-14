//
//  LoginPresentor.swift
//  BushelTestProject
//
//  Created by Josh Slebodnik on 1/7/20.
//  Copyright © 2020 Josh Slebodnik. All rights reserved.
//

import Foundation


protocol LoginView: class {
    
    func presentLoginError(error: String)
    func presentInvalidCredentialsError()
    func showSpinner()
    func hideSpinner()
    func presentHome()
    
}

class LoginPresenter {
    
    private let loginService: LoginService
    weak private var loginView: LoginView?

    init(with view: LoginView){
        
        self.loginView = view.self
        self.loginService = LoginService()
        
    }
    
    public func loginUserSaveToken(username : String, password : String) {
        
        //If Username and password field don't have an characters, show an alert
        if (username.count > 0) && (password.count > 0){
        
            self.loginView?.showSpinner()
            
            self.loginService.login(username: username, password: password, completion: { token, error in
                
                self.loginView?.hideSpinner()
                
                //Presents error if there is an error, otherwise login.
                guard let error = error else {
                    
                    guard let token = token else { self.loginView?.presentLoginError(error: "There was an error logging in."); return }
                    
                    //Saves Token in UserDefaults.
                    UserDefaults.standard.set(token.token, forKey: "token")

                    //This will login to Homeview
                    self.loginView?.presentHome()
                    
                    return
                    
                }
                
                self.loginView?.presentLoginError(error: error.localizedDescription)
                
                
            })
            
        } else {
            
            self.loginView?.presentInvalidCredentialsError()
            
        }
        
    }
    
    public func detectToken(){
        
        //If token in userdefault, then go to home list view
        if UserDefaults.standard.object(forKey: "token") != nil {
            
            loginView?.presentHome()
            
        }
        
    }
    
    
}

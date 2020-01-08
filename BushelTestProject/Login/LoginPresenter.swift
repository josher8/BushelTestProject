//
//  LoginPresentor.swift
//  BushelTestProject
//
//  Created by Josh Slebodnik on 1/7/20.
//  Copyright © 2020 Josh Slebodnik. All rights reserved.
//

import Foundation


protocol LoginViewDelegate: NSObjectProtocol {
    func dismissView()
    func presentLoginError()
    func presentInvalidCredentialsError()
    func reloadHomeList()
}

class LoginPresenter {
    
    private let loginService: LoginService
    weak private var loginViewDelegate: LoginViewDelegate?

    init(loginService: LoginService){
        self.loginService = loginService
    }
    
    public func setViewDelegate(loginViewDelegate: LoginViewDelegate?){
        self.loginViewDelegate = loginViewDelegate
    }
    
    public func loginUserSaveToken(username : String, password : String) {
        print("Login User Pressed")
        
        self.loginService.login(username: username, password: password, completion: { token in
            
            if token != nil {
                
                //Saves Token in UserDefaults.
                UserDefaults.standard.set(token?.token, forKey: "token")
                //This will retry to login on HomeViewController
                self.loginViewDelegate?.reloadHomeList()
                self.loginViewDelegate?.dismissView()
                
            }else {
                
                self.loginViewDelegate?.presentLoginError()
                
            }
            
        })
        
    }
    
    public func presentInvalidCredentialsError(){

        self.loginViewDelegate?.presentInvalidCredentialsError()
        
    }
    
}

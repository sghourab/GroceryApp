//
//  LoginTableViewController.swift
//  GroceryApp
//
//  Created by Mohammad Azam on 3/7/18.
//  Copyright © 2018 Mohammad Azam. All rights reserved.
//

import Foundation
import UIKit
import Firebase


enum AlertType: String {
    case error = "Error"
    case message = "Success"
}

class LoginTableViewController : UITableViewController {
    
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    @IBOutlet weak var registrationEmailTextField: UITextField!
    @IBOutlet weak var registrationPasswordTextField: UITextField!
    
    
    @IBAction func loginButtonPressed(){
        guard let email = loginEmailTextField.text, let password = loginPasswordTextField.text else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error {
                self.showAlert(with: error.localizedDescription, alertType: .error)
                return
            }
            self.performSegue(withIdentifier: "SuccessfulLoginSegue", sender: self)
        }
    }
    
    @IBAction func registerButtonPressed(){
        guard let email = registrationEmailTextField.text, let password = registrationPasswordTextField.text else {
            return
        }
        Auth.auth().createUser(withEmail: email, password: password){ user, error in
            if let error = error {
                self.showAlert(with: error.localizedDescription, alertType: .error)
            } else {
                self.showAlert(with: "You are now registered", alertType: .message)
            }
            
        }
    }
    
    private func showAlert(with message: String, alertType: AlertType){
        let alertController = UIAlertController(title: alertType.rawValue, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

//
//  AddShoppingListTableViewController.swift
//  GroceryApp
//
//  Created by Mohammad Azam on 3/2/18.
//  Copyright © 2018 Mohammad Azam. All rights reserved.
//

import Foundation
import UIKit

protocol AddShoppingListTableViewControllerDelegate {
    
    func addShoppingListTableViewControllerDidSave(controller: UIViewController, title: String)
    func addShoppingListTableViewControllerDidCancel(controller: UIViewController)
    
}

class AddShoppingListTableViewController : UITableViewController {
    
    @IBOutlet weak var titleTextField :UITextField!
    var delegate: AddShoppingListTableViewControllerDelegate!
    
    @IBAction func save() {
        if let title = titleTextField.text {
            delegate.addShoppingListTableViewControllerDidSave(controller: self, title: title)
        }
      
    }
    
    @IBAction func cancel() {
        delegate.addShoppingListTableViewControllerDidCancel(controller: self)
    }
    
    
   
}

//
//  AddGroceryItemTableViewController.swift
//  GroceryApp
//
//  Created by Mohammad Azam on 3/5/18.
//  Copyright © 2018 Mohammad Azam. All rights reserved.
//

import Foundation
import UIKit

protocol AddGroceryItemTableViewControllerDelegate {
    func addGroceryItemTableViewControllerDidCancel(controller: UIViewController)
    func addGroceryItemTableViewControllerDidSave(controller: UIViewController, groceryItem: GroceryItem)
    
}


class AddGroceryItemTableViewController : UITableViewController {
    
    var delegate: AddGroceryItemTableViewControllerDelegate?
    
    @IBOutlet weak var titleTextField :UITextField! 
    
    @IBAction func save() {
        
        if let title = titleTextField.text {
            let groceryItem = GroceryItem(title: title)
        delegate?.addGroceryItemTableViewControllerDidSave(controller: self, groceryItem: groceryItem)
    
        }
        
    }
    
    @IBAction func cancel(){
        delegate?.addGroceryItemTableViewControllerDidCancel(controller: self)
    }
}

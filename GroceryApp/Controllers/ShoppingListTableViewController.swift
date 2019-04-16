//
//  ShoppingListTableViewController.swift
//  GroceryApp
//
//  Created by Mohammad Azam on 3/2/18.
//  Copyright © 2018 Mohammad Azam. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class ShoppingListTableViewController : UITableViewController, AddShoppingListTableViewControllerDelegate {
   
    private var shoppingLists: [ShoppingList]  = [ShoppingList]()
    
    //MARK:- Firebase step 1: make a property for the database root reference. The root reference is the reference to that initial node with no children in the firebase console
    private var rootRef: DatabaseReference?
    var user: User {
        guard let currentUser = Auth.auth().currentUser else {
            fatalError("no user found")
        }
        return currentUser
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //MARK:- Firebase step 2: Initialize the Root reference
        
        self.rootRef = Database.database().reference()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        //MARK:- Firebase step 4 a: call a function in view did load that retrieves data stored and displays it...
        populateShoppingLists()
    }
    
    //MARK:- Firebase step 4 b: function to retieve/popluate saved/stored data
    
    private func populateShoppingLists(){
        //OBSERVE the root reference. Any changes to any node branches in the root reference, user will be notified.... '.value' below indicates that any change in root reference will cause a notification. 'snapshot' gives the user a snapshot of the data within the root reference.
        self.rootRef?.child(self.user.emailWithoutSpecialCharacters).observe(.value) { snapshot in
            
                // We remove all data in ShoppingList so content is repopulated each time tableview is reloaded. otherwise will have duplicate data displayed in the UI.
                self.shoppingLists.removeAll()
                //Get values out of snapshot
            let shoppingListDictionary = snapshot.value as? [String:Any] ?? [:]
                
                //Now iterate throught the keys of the dictionary. eg: key: title, value: costco.
                for (key, _) in shoppingListDictionary {
                    if let shoppingListDict = shoppingListDictionary[key] as? [String:Any] {
                    
                    //giving each title a value.
                    if let shoppingList = ShoppingList(dictionary: shoppingListDict) {
                    self.shoppingLists.append(shoppingList)
                    }
                
                
                }
        
            }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
        }
    }
    
    func addShoppingListTableViewControllerDidCancel(controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addShoppingListTableViewControllerDidSave(controller: UIViewController, title: String) {
        print(title)
        
        let shoppingList = ShoppingList(title: title)
        shoppingLists.append(shoppingList)
       
        let userRef = rootRef?.child(user.emailWithoutSpecialCharacters)
        //MARK:- Firebase step 3: create a child to the root refences and SAVE in it shopping list.
        //First create reference to child node:
        let shoppingListRef = userRef?.child(shoppingList.title)
        //Next write to (set value of) child node:
        do{
        shoppingListRef?.setValue(try shoppingList.toDictionary())
        } catch {
            print(error)
        }
        controller.dismiss(animated: true, completion: nil)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddShoppingListTableViewController" {
            let dc = segue.destination as! UINavigationController
            let addShoppingListVC = dc.viewControllers.first as! AddShoppingListTableViewController
            addShoppingListVC.delegate = self
        }
        else if segue.identifier == "GroceryItemsTableViewController" {
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            let groceryItemTVC = segue.destination as! GroceryItemsTableViewController
            groceryItemTVC.shoppingList = shoppingLists[indexPath.row]
        }
    }
   
    //MARK:- table view delegate methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListTableViewCell", for: indexPath)
        cell.textLabel?.text = shoppingLists[indexPath.row].title
        return cell
    }
    
    //MARK:- Deleting a ShoppingList
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let shoppingList = shoppingLists[indexPath.row]
            let shoppingListRef = rootRef?.child(shoppingList.title)
            shoppingListRef?.removeValue()
            
        }
    }
   
}

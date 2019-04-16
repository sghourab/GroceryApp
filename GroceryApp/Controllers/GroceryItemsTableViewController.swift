//
//  GroceryItemsTableViewController.swift
//  GroceryApp
//
//  Created by Mohammad Azam on 3/2/18.
//  Copyright © 2018 Mohammad Azam. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class GroceryItemsTableViewController : UITableViewController, AddGroceryItemTableViewControllerDelegate {
    
    var shoppingList: ShoppingList?
    private var rootRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = shoppingList?.title
        self.navigationItem.largeTitleDisplayMode = .never
        //intializing root reference
        rootRef = Database.database().reference()
    }
    func addGroceryItemTableViewControllerDidSave(controller: UIViewController, groceryItem: GroceryItem) {
       
        //this function is called after EACH grocery item is 'saved'
        // to access (or create) the node that contains the shopping list for that grocery item:
        guard let shoppingList = shoppingList else {
            fatalError("No shopping List Property found")
        }
        guard let user = Auth.auth().currentUser, let email = user.email else {
            fatalError("could not access current user in database after saving grocery item")
        }
        
        //////////
        //to add all grocery Items to shoppingList property:
        self.shoppingList?.groceryItems.append(groceryItem)
        
        let userRef = rootRef.child(email.removeSpecialCharacters())
        let shoppingListRef = userRef.child(shoppingList.title)        //to save grocery Items onto Firebase:
        //Go to ShoppingList Class to further understand toDictionary function. It converts the array of grocery items into an array of dictionarys:
        //["title": "Shopping List 1", "groceryItems":[title:"grocery item1"], [title: "grocery item 2"], [title: "grocery item 3"]]
        do {
        shoppingListRef.setValue(try self.shoppingList?.toDictionary())
        } catch {
            print(error)
        }
        controller.dismiss(animated: true, completion: nil)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func addGroceryItemTableViewControllerDidCancel(controller: UIViewController) {
       controller.dismiss(animated: true, completion: nil)
        
        
    }
    
    //MARK:- table view delegage methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList?.groceryItems.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryItemTableViewCell", for: indexPath)
        cell.textLabel?.text = shoppingList?.groceryItems[indexPath.row].title
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            shoppingList?.groceryItems.remove(at: indexPath.row)
//            tableView.reloadData()
//        }
//    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // update in-memory model. delete grocery Item from shopping list
            shoppingList?.groceryItems.remove(at: indexPath.row)
            //update view:
            tableView.reloadData()
            //updaet database model using the updated in-memory model:
            do {
            rootRef.child(shoppingList!.title).setValue(try shoppingList?.toDictionary())
            }
            catch {
                print(error)
            }
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nc = segue.destination as? UINavigationController else {
            return
        }
        guard let addGroceryTVC = nc.viewControllers.first as? AddGroceryItemTableViewController else {
            return
        }
        addGroceryTVC.delegate = self
    }
}

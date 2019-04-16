//
//  User+Extensions.swift
//  GroceryApp
//
//  Created by Summer Crow on 2019-04-15.
//  Copyright © 2019 Mohammad Azam. All rights reserved.
//

import Foundation
import Firebase

extension User {
    var emailWithoutSpecialCharacters: String {
    
        guard let email = self.email else {
            fatalError("Unable to access the email for the user")
        }
        return email.removeSpecialCharacters()
    }
}

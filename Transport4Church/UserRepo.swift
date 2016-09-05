//
//  UserRepo.swift
//  Transport4Church
//
//  Created by mac on 8/20/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import Parse
//
class UserRepo {
//
    func register(userObject: User) -> Void {
        var user = PFUser()
        user.username = userObject.username
        user.password = userObject.password
        user.email = userObject.email
        user["name"] = userObject.name
        user["gender"] = userObject.gender
        user["role"] = userObject.role!.rawValue
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                print(" \(errorString)")
                
            } else {
                // Hooray! Let them use the app now.
                print("saved user")
            }

        }
    }
}
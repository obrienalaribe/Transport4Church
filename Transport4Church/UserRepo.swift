//
//  UserRepo.swift
//  Transport4Church
//
//  Created by mac on 8/20/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import Parse

struct Credentials {
    var username : String
    var password : String
}

struct Profile {
    var image : UIImage?
    var name: String
    var gender: String
    var contact : String
    var role: String
}

class UserRepo {
    
    func updateProfile(profile: Profile, listener: UIViewController){
        let user = PFUser.currentUser()
        
        if let currentUser = user {
            if let image = profile.image {
                let imageData = UIImagePNGRepresentation(image)
                
                if let data = imageData {
                    let avatarObject  = PFObject(className: "Picture")
                    let imageFile = PFFile(name: "image.png", data: data)
                    
                    avatarObject.setObject(currentUser, forKey: "owner")

                    imageFile?.saveInBackgroundWithBlock({ (success, error) in
                        if let error = error {
                            let errorString = error.userInfo["error"] as? NSString
                            print(errorString)
                        } else {
                            avatarObject.setObject(imageFile!, forKey: "image")
                            avatarObject.saveInBackground()

//                            currentUser.setObject(imageFile!, forKey: "avatar")
                        }
                    })
                }
            }
            
            currentUser["name"] = profile.name
            currentUser["gender"] = profile.gender
            currentUser["contact"] = profile.contact
            currentUser["role"] = profile.role

            currentUser.saveInBackgroundWithBlock({ (success, error) in
                if listener.navigationController?.viewControllers.count == 1 {
                    //registration stage
                    
                    if profile.role == UserRoles.Driver.rawValue {
                        
                        listener.navigationController?.pushViewController(DriverRequestListController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
                    }else{
                        listener.navigationController?.setViewControllers([RiderPickupController()], animated: true)
                    }
                }else{
                    //was accessed through settings
                    listener.navigationController?.popViewControllerAnimated(true)
                }
            })
        }
        

    }
    
    func authenticate(credentials: Credentials, listener: UIViewController) {
        let user = PFUser()
        user.username = credentials.username
        user.email = credentials.username
        user.password = credentials.password
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                
                if error.code == 202 {
                    print("user already exist so login and navigate to rider view")
                    
                    print(PFUser.currentUser()!)

                    listener.navigationController?.setViewControllers([RiderPickupController()], animated: true)

                }else{
                    let errorString = error.userInfo["error"] as? NSString
                    print(" \(errorString)")
                }
                
            } else {
                print("saved new user")

                print(PFUser.currentUser()!)                
                listener.navigationController?.setViewControllers([EditProfileViewController()], animated: true)
                
                
            }
            
        }

    }
    
    func fetchAndUpdateProfileImage(user: PFUser, imageView: UIImageView){
        let query = PFQuery(className:"Picture")
        query.whereKey("owner", equalTo: user)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) pics.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        if let userPicture = object.valueForKey("image") {
                            let picture = userPicture as! PFFile
                            //TODO: optimize this to only use and fetch one image object
                            picture.getDataInBackgroundWithBlock({
                                (imageData: NSData?, error: NSError?) -> Void in
                                if (error == nil) {
                                    let image = UIImage(data:imageData!)
                                    imageView.contentMode = .ScaleAspectFit
                                    imageView.clipsToBounds = true
                                    
                                    let size = CGSize(width: imageView.bounds.width, height: imageView.bounds.height)
                                    imageView.image = ProfileViewController.resizeImage(image!, toTheSize: size)
                                }
                            })
                        }
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }

    }
}
//
//  ProfileViewController.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 09/09/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import Eureka
import Parse

class ProfileViewController : FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Profile"
        
        if let user = PFUser.currentUser(){
            form +++ Section()
                <<< TextRow("Name"){ row in
                    row.title = "Fullname"
                    row.value = user["name"] as! String
                }
                <<< ActionSheetRow<String>("Gender") {
                    $0.title = "Gender"
                    $0.selectorTitle = "Select Gender"
                    $0.options = ["Male","Female", "Other"]
                    print(user["gender"] as! String)
                    $0.value = user["gender"] as! String
                }
           
            
                +++ Section() { section in
                    section.header = {
                        var header = HeaderFooterView<UIButton>(.Callback({
                            let button = FormButton(title: "Update")
                            button.addTarget(self, action: "handleFormSubmission:", forControlEvents: .TouchUpInside)
                            return button
                        }))
                        header.height = { 50 }
                        return header
                    }()
            }

        }
        
        
    }
    
    func handleFormSubmission(sender: UIButton!){
        
        let valuesDictionary = form.values()
        
        //TODO: create user struct here to pass on
        
        let listOfEmptyFields = Helper.validateFormInputs(valuesDictionary)
        
        if let user = PFUser.currentUser(){
            user["name"] = valuesDictionary["Name"] as! String
            user["gender"] = valuesDictionary["Gender"] as! String
            user.saveEventually()
        }
        
    }
    
}
//
//  CalendarEventFormViewController.swift
//  Transport4Church
//
//  Created by mac on 8/8/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import Eureka

class RegisterFormViewController : FormViewController {
    
    private var userRepo : UserRepo = UserRepo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Register for Account"
        
        //TODO: Add section for login button and caption
        
        
        form +++ Section("Please fill in the details below")
            <<< TextRow("Name"){ row in
                row.title = "Fullname"
                row.placeholder = "i.e Emma Smith"
            }
            <<< ActionSheetRow<String>("Gender") {
                $0.title = "Gender"
                $0.selectorTitle = "Select Gender"
                $0.options = ["Male","Female", "Other"]
                $0.value = "Other"
            }
            
            <<< EmailRow("Email"){
                $0.title = "Email"
                $0.placeholder = "i.e emmy23@gmail.com"
            }
            
            <<< PasswordRow("Password"){
                $0.title = "Password"
            }
            
            <<< ActionSheetRow<String>("Role") {
                $0.title = "Rider or Driver ?"
                $0.selectorTitle = "Rider or Driver ?"
                $0.options = ["Rider","Driver"]
                $0.value = "Rider"    // initially selected
            }
            
            +++ Section() { section in
                section.header = {
                    var header = HeaderFooterView<UIButton>(.Callback({
                        let button = FormButton(title: "Register")
                        button.addTarget(self, action: "handleFormSubmission:", forControlEvents: .TouchUpInside)
                        return button
                    }))
                    header.height = { 50 }
                    return header
                }()
           }
        
        
    }
    
    func handleFormSubmission(sender: UIButton!){
       
        let valuesDictionary = form.values()

        //TODO: create user struct here to pass on
        
        let listOfEmptyFields = validateFormInputs(valuesDictionary)
        
        if listOfEmptyFields.isEmpty == false {
            print("please provide \(listOfEmptyFields.joinWithSeparator(", "))")

        }else{
            
            if let role = valuesDictionary["Role"] {
                let userRole = role as! String
                
                var user = User(
                    name: valuesDictionary["Name"] as! String,
                    gender: valuesDictionary["Gender"] as! String,
                    email: valuesDictionary["Email"] as! String,
                    role: nil,
                    username: valuesDictionary["Email"] as! String,
                    password: valuesDictionary["Password"] as! String
                )
                
                if userRole == UserRoles.Driver.rawValue {
                    //driver registration
                    user.role = .Driver
                    userRepo.register(user)
                    
                    self.navigationController?.pushViewController(DriverRequestListController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
                }else{
                    //rider registration
                    user.role = .Rider
                    userRepo.register(user)
                    
                    self.navigationController?.setViewControllers([RiderPickupController()], animated: true)
                }
                
            }
        }
        
    }
    
    private func validateFormInputs(valuesDictionary: Dictionary<String, Any?>) -> [String]{
        var emptyFields = [String]()
        for key in valuesDictionary.keys {
            if unwrap(valuesDictionary[key]) == nil {
                emptyFields.append(key)
            }
        }
        
        return emptyFields
    }
    
    private func unwrap(value: Any?) -> String? {
        if let result = value {
            return result as? String
        }
        return nil
    }
    
}
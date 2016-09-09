//
//  EditProfileViewController.swift
//  Transport4Church
//
//  Created by mac on 8/8/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import Eureka

class EditProfileViewController : FormViewController {
    
    private var userRepo : UserRepo = UserRepo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Profile"
        
        ImageRow.defaultCellUpdate = { cell, row in
            cell.accessoryView?.layer.cornerRadius = 17
            cell.accessoryView?.frame = CGRectMake(0, 0, 40, 40)
        }
        
        form +++ Section()
            <<< ImageRow(){
                $0.title = "Select Profile Picture"
                $0.cell.accessoryView = UIImageView(image: UIImage(named: "profile_dp"))

            }
            
            +++ Section("Please fill in your details")
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
            
            +++ Section("Number Driver will to contact you on")
            <<< PhoneRow("Contact"){ row in
                row.title = "Contact"
                row.placeholder = ""
            }
            
            +++ Section("Select your role")
            <<< ActionSheetRow<String>("Role") {
                $0.title = "Rider or Driver ?"
                $0.selectorTitle = "Rider or Driver ?"
                $0.options = ["Rider","Driver"]
                $0.value = "Rider"
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
        
        let listOfEmptyFields = Helper.validateFormInputs(valuesDictionary)
        
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
      
}
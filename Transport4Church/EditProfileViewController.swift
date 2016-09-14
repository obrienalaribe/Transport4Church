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
            cell.accessoryView?.layer.cornerRadius = 25
            cell.accessoryView?.frame = CGRectMake(0, 0, 50, 50)
            row.cell.height = {
                return 60
            }
        }
        
        form +++ Section()
            <<< ImageRow("Picture"){
                $0.title = "Select Profile Picture"
                $0.cell.accessoryView = UIImageView(image: UIImage(named: "profile_dp"))
                }
            
            +++ Section("Please fill in your details")
            <<< TextRow("Name"){ row in
                row.title = "Fullname"
                row.placeholder = "i.e Emma Smith"
                row.value = "Tommy Jack"

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
                row.value = "2342342"

            }
            
            +++ Section()
            <<< ActionSheetRow<String>("Role") {
                $0.title = "Rider or Driver ?"
                $0.selectorTitle = "Rider or Driver ?"
                $0.options = ["Rider","Driver"]
                $0.value = "Rider"
            }
            
            +++ Section() { section in
                section.header = {
                    var header = HeaderFooterView<UIButton>(.Callback({
                        let button = FormButton(title: "Update")
                        button.addTarget(self, action: #selector(EditProfileViewController.handleFormSubmission(_:)), forControlEvents: .TouchUpInside)
                        return button
                    }))
                    header.height = { 50  }
                    return header
                }()
           }
        
        
    }
    
    func handleFormSubmission(sender: UIButton!){
       
        let valuesDictionary = form.values()
        
        print(valuesDictionary)
        
        let listOfEmptyFields = Helper.validateFormInputs(valuesDictionary)
        
        if 1 == 0 {
  
         

        }else{
            
            if let role = valuesDictionary["Role"] {
                let userRole = role as! String
//                
                let profile = Profile(image: valuesDictionary["Picture"] as? UIImage, name: valuesDictionary["Name"] as! String, gender: valuesDictionary["Gender"] as! String, contact: valuesDictionary["Contact"] as! String , role: valuesDictionary["Role"] as! String)
                
                userRepo.updateProfile(profile, listener: self)
                
                if userRole == UserRoles.Driver.rawValue {

//                    self.navigationController?.pushViewController(DriverRequestListController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
                }else{
                    
//                    self.navigationController?.setViewControllers([RiderPickupController()], animated: true)
                }
                
            }
        }
        
    }
      
}
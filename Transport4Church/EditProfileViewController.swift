//
//  EditProfileViewController.swift
//  Transport4Church
//
//  Created by mac on 8/8/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import Eureka
import Parse
import ImageRow

class EditProfileViewController : FormViewController {
    
    fileprivate var userRepo : UserRepo = UserRepo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Profile"
        
        ImageRow.defaultCellUpdate = { cell, row in
            cell.accessoryView?.layer.cornerRadius = 25
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            row.cell.height = {
                return 60
            }
            
        }
        
        form
        //    <<< ImageRow("Picture"){
          //      $0.title = "Select Profile Picture"
                
            //    }.cellSetup({ (cell, row) in
              //      cell.imageView?.image = UIImage(named: "user")
                //    cell.accessoryView = UIImageView(image: UIImage(named:"user"))
               // })
            
            +++ Section("Please fill in your details")
            <<< TextRow("Name"){ row in
                row.title = "Fullname"
                row.placeholder = "i.e Emma Smith"
                row.value = userRepo.extractUserField("name")

                }
            
            <<< ActionSheetRow<String>("Gender") {
                $0.title = "Gender"
                $0.selectorTitle = "Select Gender"
                $0.options = ["Male","Female", "Other"]
                $0.value = userRepo.extractUserField("gender")
            }
            
            +++ Section()
            <<< PushRow<String>("Church") {
                $0.title = "Church"
                $0.selectorTitle = "Choose your church"
                $0.options = ["EFA RCCG Leeds"]
                $0.value = userRepo.extractUserField("church")
            }
            
            +++ Section("Number Driver will to contact you on")
            <<< PhoneRow("Contact"){ row in
                row.title = "Contact"
                row.placeholder = ""
                row.value = userRepo.extractUserField("contact")

            }
            
            +++ Section() { section in
                section.header = {
                    var header = HeaderFooterView<UIButton>(.callback({
                        let button = FormButton(title: "Update")
                        button.addTarget(self, action: #selector(EditProfileViewController.handleFormSubmission(_:)), for: .touchUpInside)
                        return button
                    }))
                    header.height = { 50  }
                    return header
                }()
           }
        
        
    }
    
    func handleFormSubmission(_ sender: UIButton!){
       
        let valuesDictionary = form.values()
        
        let listOfEmptyFields = Helper.validateFormInputs(valuesDictionary)
        
        if 1 == 0 {
           

        }else{

            let profile = Profile(image: valuesDictionary["Picture"] as? UIImage, name: valuesDictionary["Name"] as! String, gender: valuesDictionary["Gender"] as! String, contact: valuesDictionary["Contact"] as! String, church: valuesDictionary["Church"] as! String)
            
            userRepo.updateProfile(profile, listener: self)
        }
        
    }
      
}

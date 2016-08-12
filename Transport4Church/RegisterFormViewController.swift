//
//  CalendarEventFormViewController.swift
//  Transport4Church
//
//  Created by mac on 8/8/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import Eureka

class RegisterFormViewController : FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ImageRow.defaultCellUpdate = { cell, row in
            cell.accessoryView?.layer.cornerRadius = 17
            cell.accessoryView?.frame = CGRectMake(0, 0, 80, 80)
        }
        
        
        form +++ Section("Please fill in the details below")
            <<< TextRow("Name"){ row in
                row.title = "Name"
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
            <<< ActionSheetRow<String>("Role") {
                $0.title = "Passenger or Driver ?"
                $0.selectorTitle = "Pick one"
                $0.options = ["Passenger","Driver"]
                $0.value = "Passenger"    // initially selected
            }
            
            <<< ImageRow(){
                $0.title = "Profile picture"
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

        if let role = valuesDictionary["Role"] {
            let userRole = role as! String
            
            if userRole == "Driver" {
                self.navigationController?.pushViewController(DriverRequestListController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
            }else{
                self.navigationController?.setViewControllers([RiderPickupController()], animated: true)
            }

            
        }

    }
    
}
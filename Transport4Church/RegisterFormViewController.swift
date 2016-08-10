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
        form +++ Section("Profile Details")
            <<< TextRow(){ row in
                row.title = "Name"
                row.placeholder = "i.e Emma Smith"
            }
            
            <<< EmailRow(){
                $0.title = "Email"
                $0.placeholder = "i.e emmy23@gmail.com"
            }
            +++ Section() { section in
                section.header = {
                    var header = HeaderFooterView<UIButton>(.Callback({
                        let button = FormButton(title: "Submit")
                        button.addTarget(self, action: "handleFormSubmission:", forControlEvents: .TouchUpInside)
                        return button
                    }))
                    header.height = { 50 }
                    return header
                }()
                
           }
            
            +++ Section("Section2")
            <<< TimeRow(){
                $0.title = "Pickup Time"
                $0.value = NSDate(timeIntervalSinceReferenceDate: 0)
            }
        
    }
    
    func handleFormSubmission(sender: UIButton!){
        navigationController?.presentViewController(PickupRiderController(), animated: true, completion: { 
            
            print("finished present rider pickup")
        })
    }
    
}
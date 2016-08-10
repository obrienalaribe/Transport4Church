//
//  ConfirmPickupController.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 10/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit
import Eureka

class ConfirmPickupFormController: FormViewController {
    
    var trip : Trip? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        form +++ Section()
            <<< TextRow(){ row in
                row.title = "Name"
                row.value = "Emma Smith"
                row.disabled = true
            }
            
            <<< StepperRow(){ row in
                row.title = "Extra passengers"
                
            }
            +++ Section()
            <<< PostalAddressRow(){
                $0.title = "Address"
                $0.streetPlaceholder = "Street"
                $0.postalCodePlaceholder = "Postcode"
                $0.cityPlaceholder = "City"
                
                $0.value = PostalAddress(
                    street: "12 David Street",
                    state: "Holbeck",
                    postalCode: "LS12 2BB",
                    city: "Leeds",
                    country: nil
                )
                $0.disabled = true
            }
            
            +++ Section()
            <<< TextRow(){ row in
                row.title = "Destination"
                row.value = "RCCG EFA Leeds, LS4 2BB"
                row.disabled = true
            }
            
            +++ Section()
            <<< TimeRow(){
                $0.title = "Choose Pickup Time"
                $0.value = NSDate()
            }
        
            +++ Section() { section in
                section.header = {
                    var header = HeaderFooterView<FormButton>(.Callback({
                        let button = FormButton(title: "Request Pickup")
                        button.addTarget(self, action: "handleFormSubmission:", forControlEvents: .TouchUpInside)
                        return button
                    }))
                    header.height = { 50 }
                    return header
                }()
        }
            
    }
    
    func handleFormSubmission(sender: UIButton!){
       navigationController?.pushViewController(TrackPickupController(), animated: true)
    }


}

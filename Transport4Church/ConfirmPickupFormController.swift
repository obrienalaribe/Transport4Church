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
    
    var trip : Trip?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(trip: Trip?) {
        self.trip = trip
        super.init(nibName: nil, bundle: nil)
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Confirm Pickup"
        
        form +++ Section()
            <<< PostalAddressRow("location"){
                $0.title = "Location"
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
            <<< TextRow("destination"){ row in
                row.title = "Destination"
                row.value = "RCCG EFA Leeds, LS4 2BB"
                row.disabled = true
            }
            
            
            +++ Section()
            <<< PushRow<String>("extraRider") {
                $0.title = "Extra riders"
                $0.selectorTitle = "How many people are with you ?"
                $0.options = ["None", "One","Two","Three", "Four", "Five", "Six"]
                $0.value = "None"    // initially selected
            }
            
            +++ Section()
            <<< TimeRow("pickupTime"){
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
       navigationController?.popViewControllerAnimated(true)
        
        let valuesDictionary = form.values()
        
        print(valuesDictionary)
    }


}

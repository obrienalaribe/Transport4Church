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
    
    var trip : Trip
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(trip: Trip) {
        self.trip = trip
        super.init(nibName: nil, bundle: nil)

    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Confirm Pickup"
        
        form +++ Section()
            <<< PostalAddressRow("location"){
                $0.title = "From"
                $0.streetPlaceholder = ""
                $0.postalCodePlaceholder = ""
                $0.cityPlaceholder = ""
                
                $0.value = PostalAddress(
                    street: self.trip.rider.location.streetName,
                    state: self.trip.rider.location.city,
                    postalCode: self.trip.rider.location.postcode,
                    city: self.trip.rider.location.country,
                    country: ""
                )
                $0.disabled = true
            }
            <<< TextRow("destination"){ row in
                row.title = "To"
                row.value = "RCCG EFA Leeds, LS4 2BB"
                row.disabled = true
            }
            
            +++ Section()
            <<< PushRow<String>("extraRider") {
                $0.title = "Extra riders"
                $0.selectorTitle = ""
                $0.options = ["None", "One","Two","Three"]
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
        self.trip.status = .REQUESTED
        
//        print("\(trip!.getAddress()) \(trip!.getCoordinates())")
        
//        print(valuesDictionary)
    }


}

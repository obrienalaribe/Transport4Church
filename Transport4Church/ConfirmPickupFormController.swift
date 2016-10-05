//
//  ConfirmPickupController.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 10/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit
import Eureka
import Parse

class ConfirmPickupFormController: FormViewController {
    
    var trip : Trip
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(trip: Trip) {
        self.trip = trip
        super.init(nibName: nil, bundle: nil)
        //Use location helper to get location details of PFGeopoint then set in fields

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
                    street: self.trip.rider.address.streetName,
                    state: self.trip.rider.address.city,
                    postalCode: self.trip.rider.address.postcode,
                    city: self.trip.rider.address.country,
                    country: ""
                )
                $0.disabled = true
            }
            <<< TextRow("destination"){ row in
                row.title = "To"
                row.value = "RCCG EFA Leeds, LS4 2BB"
                row.disabled = true
            }
            
            //TODO: check if it is the users first trip then ask for contact
            //try and do test call to verify number given
            <<< TextRow("contact"){ row in
                row.title = "Contact"
                row.value = self.trip.rider.user["contact"] as! String
                row.highlightCell()
            }
            
            +++ Section()
            <<< PushRow<String>("extraRider") {
                $0.title = "Extra riders"
                $0.selectorTitle = ""
                $0.options = ["None", "One","Two","Three"]
                $0.value = "None"
            }
            
            +++ Section()
            <<< TimeRow("pickup_time"){
                $0.title = "Choose Pickup Time"
                $0.value = NSDate()
            }

            +++ Section() { section in
                section.header = {
                    var header = HeaderFooterView<FormButton>(.Callback({
                        let button = FormButton(title: "Request Pickup")
                        button.addTarget(self, action: #selector(ConfirmPickupFormController.handleFormSubmission(_:)), forControlEvents: .TouchUpInside)
                        return button
                    }))
                    header.height = { 50 }
                    return header
                }()
        }
        
    }
    
    func handleFormSubmission(sender: UIButton!){
        
        NotificationHelper.setupNotification()

        let valuesDictionary = form.values()

        self.trip.status = TripStatus.REQUESTED
        
        self.trip.destination = PFGeoPoint(latitude: EFA_Coord.latitude, longitude: EFA_Coord.longitude)
        self.trip.pickupTime = valuesDictionary["pickup_time"] as! NSDate

        self.trip.saveInBackgroundWithBlock({ (success, error) in
            self.navigationController?.popViewControllerAnimated(true)
        })
        
    }
   
}

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
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Confirm Pickup"
        
        form +++ Section()
//            <<< PostalAddressRow("location"){
//                $0.title = "From"
//                $0.streetPlaceholder = ""
//                $0.postalCodePlaceholder = ""
//                $0.cityPlaceholder = ""
//                
//                $0.value = PostalAddress(
//                    street: self.trip.rider.address.streetName,
//                    state: self.trip.rider.address.city,
//                    postalCode: self.trip.rider.address.postcode,
//                    city: self.trip.rider.address.country,
//                    country: ""
//                )
//                $0.disabled = true
//            }
            
            <<< TextRow("location"){ row in
                row.title = "From"
                row.value = "\(self.trip.rider.address.streetName!), \(self.trip.rider.address.postcode!)"
                row.disabled = true
            }
            
            <<< TextRow("destination"){ row in
                row.title = "To"
                row.value = "RCCG EFA Leeds, LS4 2BB"
                row.disabled = true
            }
            
            <<< PhoneRow("contact"){ row in
                row.title = "Contact"
                row.value = self.trip.rider.user["contact"] as! String
            }
            
            +++ Section()
            <<< PushRow<String>("extra_riders") {
                $0.title = "Extra riders"
                $0.selectorTitle = ""
                $0.options = ["None", "One","Two","Three"]
                $0.value = "None"
            }
            
            +++ Section()
            <<< TimeRow("pickup_time"){
                $0.title = "Choose Pickup Time"
                $0.value = Date()
            }

            +++ Section() { section in
                section.header = {
                    var header = HeaderFooterView<FormButton>(.callback({
                        let button = FormButton(title: "Request Pickup")
                        button.addTarget(self, action: #selector(ConfirmPickupFormController.handleFormSubmission(_:)), for: .touchUpInside)
                        return button
                    }))
                    header.height = { 50 }
                    return header
                }()
        }
        
    }
    
    func handleFormSubmission(_ sender: UIButton!){
        
        NotificationHelper.setupNotification()

        let valuesDictionary = form.values()

        self.trip.status = TripStatus.REQUESTED
        
        self.trip.destination = PFGeoPoint(latitude: EFA_Coord.latitude, longitude: EFA_Coord.longitude)
        self.trip.pickupTime = valuesDictionary["pickup_time"] as! Date
        self.trip.extraRiders = getInteger(of: valuesDictionary["extra_riders"] as! String)
        
        if let contactNumber = valuesDictionary["contact"] as? String {
            let user = PFUser.current()
            user?["contact"] = contactNumber
            user?.saveEventually()
        }
        
        self.trip.saveInBackground(block: { (success, error) in
            self.navigationController?.popViewController(animated: true)
        })
        
    }
    
    
    func getInteger(of stringNumber: String) -> Int {
        var values = ["None" : 0, "One": 1, "Two" : 2, "Three" : 3]
        print("Exra riders: \(values[stringNumber]!)")
        return values[stringNumber]!
    }
   
}

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
    
    fileprivate var trip : Trip
    fileprivate var userChurch = ""

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
        
        if let church = ChurchRepo.getCurrentUserChurch() {
            self.userChurch = church.name!
        }
  
        
        form +++ Section()

            <<< TextRow("location"){ row in
                row.title = "From"
                row.value = "\(self.trip.rider.address.streetName!), \(self.trip.rider.address.postcode!)"
                row.disabled = true
            }
            
            <<< PushRow<String>("destination") {
                $0.title = "To"
                $0.selectorTitle = "Nearby Churches"
                $0.options = ChurchRepo.churchNames
                $0.value = userChurch
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
        
        let chosenChurch = ChurchRepo.churchCacheByName[valuesDictionary["destination"] as! String]

        self.trip.destination = chosenChurch!
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

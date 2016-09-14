//
//  Commons.swift
//  Transport4Church
//
//  Created by mac on 9/5/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import SCLAlertView


class Helper {
    
    static func createAlert() -> SCLAlertView {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 17)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 15)!,
            showCloseButton: true
        )
        return SCLAlertView(appearance: appearance)
    }
    
    static func validateFormInputs(valuesDictionary: Dictionary<String, Any?>) -> [String]{
        var emptyFields = [String]()
        for key in valuesDictionary.keys {
            if unwrap(valuesDictionary[key]) == nil {
                emptyFields.append(key)
            }
        }
        
        return emptyFields
    }
    
    static func unwrap(value: Any?) -> String? {
        if let result = value {
            return result as? String
        }
        return nil
    }

    
    static func convertDateToString(date : NSDate) -> String{
        // format the NSDate to a NSString
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "cccc, MMM d, hh:mm aa"
        let dateString = dateFormat.stringFromDate(date)
        return dateString
    }
    
    
    
    static func convertStringToDate (date : String) -> NSDate{
        // format the NSDate to a NSString
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        var dateFromString = NSDate()
        dateFromString = dateFormatter.dateFromString(date)!
        return dateFromString
    }

    
}
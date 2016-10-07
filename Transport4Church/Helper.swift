//
//  Commons.swift
//  Transport4Church
//
//  Created by mac on 9/5/16.
//  Copyright © 2016 rccg. All rights reserved.
//


class Helper {
    
    static func validateFormInputs(_ valuesDictionary: Dictionary<String, Any?>) -> [String]{
        var emptyFields = [String]()
        for key in valuesDictionary.keys {
            if unwrap(valuesDictionary[key]) == nil {
                emptyFields.append(key)
            }
        }
        
        return emptyFields
    }
    
    static func unwrap(_ value: Any?) -> String? {
        if let result = value {
            return result as? String
        }
        return nil
    }

    
    static func convertDateToString(_ date : Date) -> String{
        // format the NSDate to a NSString
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "cccc, MMM d, hh:mm aa"
        let dateString = dateFormat.string(from: date)
        return dateString
    }
    
    
    
    static func convertStringToDate (_ date : String) -> Date{
        // format the NSDate to a NSString
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        var dateFromString = Date()
        dateFromString = dateFormatter.date(from: date)!
        return dateFromString
    }

    static func resizeImage(_ image:UIImage, toTheSize size:CGSize) -> UIImage{
        let scale = CGFloat(max(size.width/image.size.width,
            size.height/image.size.height))
        let width:CGFloat  = image.size.width * scale
        let height:CGFloat = image.size.height * scale;
        
        let rr:CGRect = CGRect( x: 0, y: 0, width: width, height: height);
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        image.draw(in: rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage!
    }
    
  
}

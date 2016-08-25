//
//  MenuItem.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 25/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//



enum MenuItem : CustomStringConvertible {
    case Profile
    case Rate
    case Like
    case Copyright
    case Terms
    case Privacy
    case FAQ
    case Contact
    
    var description : String {
        switch self {
            // Use Internationalization, as appropriate.
            case .Profile : return "Profile"
            case .Rate: return "Rate us in the App Store"
            case .Like: return "Like us on Facebook"
            case .Copyright: return "Copyright"
            case .Terms: return "Terms & Conditions"
            case .Privacy: return "Privacy Policy"
            case .FAQ: return "FAQ"
            case .Contact: return "Contact Us"
        }
    }
    
}
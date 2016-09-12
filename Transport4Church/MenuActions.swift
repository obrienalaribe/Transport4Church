//
//  MenuActions.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 25/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

class MenuActions {
//    "itms://itunes.apple.com/us/app/apple-store/id375380948?mt=8"
    
 
    static func openScheme(hook: String){
        let facebookPageUrl = NSURL(string: hook)
        if UIApplication.sharedApplication().canOpenURL(facebookPageUrl!)
        {
            UIApplication.sharedApplication().openURL(facebookPageUrl!)
        }else{
            print("cannont open")
        }

    }
}

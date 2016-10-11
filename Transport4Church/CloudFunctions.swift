//
//  CloudFunctions.swift
//  Transport4Church
//
//  Created by mac on 10/9/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import Parse

open class CloudFunctions {

    //VERBOSE_PARSE_SERVER_PUSH_ADAPTER = 1
    //VERBOSE = 1
    
    //        let cloudParams : [AnyHashable:Any?] = [:]
    static func notifyRiderForAcceptedTrip(userId: String){
        
        PFCloud.callFunction(inBackground: "notifyRiderForAcceptedTrip", withParameters:  ["userId" : userId], block: {
            (result: Any?, error: Error?) -> Void in
            if error != nil {
                print(error)
            }else{
                print(result)
            }
            
        })

    }

}

//
//  ParseServer.swift
//  Transport4Church
//
//  Created by mac on 8/20/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import Parse

class ParseServer {
    init(){
        registerSubClasses()
        configureServer()
    }
    
    func registerSubClasses(){
        Rider.registerSubclass()
        Trip.registerSubclass()
        Route.registerSubclass()
        Church.registerSubclass()
    }
    
    func configureServer(){
        Parse.enableLocalDatastore()
        
        let parseConfiguration = ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
//            DEV
            ParseMutableClientConfiguration.applicationId = "myAppId"
            ParseMutableClientConfiguration.clientKey = "myMasterKey"
            ParseMutableClientConfiguration.server = "https://insta231.herokuapp.com/parse"
//
//            //PRODUCTION
//            ParseMutableClientConfiguration.applicationId = "a5dee5f93e5dce98effcfb4aa30bf5f1"
//            ParseMutableClientConfiguration.clientKey = "bb054a15cab720e6b3ef4ca890ec1335"
//            ParseMutableClientConfiguration.server = "https://transportforchurch.herokuapp.com/parse"
            


        })
        
        Parse.initialize(with: parseConfiguration)
//        PFUser.logOut()
       
    }
    
   
}

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
            ParseMutableClientConfiguration.applicationId = "myAppId"
            ParseMutableClientConfiguration.clientKey = "myMasterKey"
            ParseMutableClientConfiguration.server = "https://insta231.herokuapp.com/parse"
//            ParseMutableClientConfiguration.server = "http://localhost:1337/parse"

        })
        
        Parse.initialize(with: parseConfiguration)
//        PFUser.logOut()
       
    }
    
   
}

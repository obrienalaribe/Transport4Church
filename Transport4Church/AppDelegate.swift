//
//  AppDelegate.swift
//  Transport4Church
//
//  Created by mac on 8/7/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit
import CoreData
import GooglePlaces
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let googleMapsApiKey = "AIzaSyCRbgOlz9moQ-Hlp65-piLroeMtfpNouck"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        GMSServices.provideAPIKey(googleMapsApiKey)
        
        GMSPlacesClient.provideAPIKey(googleMapsApiKey)

        _ = ParseServer()
        
        if let loggedInUser = PFUser.current(){
            window?.rootViewController = UINavigationController(rootViewController:RiderPickupController())
            
            print("user logged in \(loggedInUser)")
           
        }else{
            print("user not logged in ")

            window?.rootViewController = UINavigationController(rootViewController:AuthViewController())
        }
    
//        window?.rootViewController = UINavigationController(rootViewController:RiderTripDetailController(trip: ModelFactory.makeTrip()))

    
        UserRepo.configureAppLaunchCount()
      
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let installation = PFInstallation.current()
        
        print("You have this person for notifications")
        
        if let deviceInstallation = installation {
            deviceInstallation.setDeviceTokenFrom(deviceToken)
            //register user on a channel with their ID
            if let user = PFUser.current(), let church = ChurchRepo.getCurrentUserChurch() {
                deviceInstallation.channels = [user.objectId!, "\(church.objectId!):Rider"]
            }
            
            deviceInstallation.saveInBackground(block: { (success, error) in
                if error != nil {
                    print(error)
                }else{
                    print("installation done: push notification registered with token \(deviceToken)")
                }
            })
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        if error._code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        if application.applicationState == .background {        }
        
        if let aps = userInfo["aps"] as? [String:Any] {
            if let alert = aps["alert"] as? String {
                if alert.contains("cancelled"){
                    NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.NotificationNamespace.tripUpdate), object: self, userInfo: ["status": TripStatus.CANCELLED, "alert": alert])
                }else if alert.contains("pick you"){
                     NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.NotificationNamespace.tripUpdate), object: self, userInfo: ["status": TripStatus.STARTED, "alert": alert])
                }else if alert.contains("completed"){
                     NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.NotificationNamespace.tripUpdate), object: self, userInfo: ["status": TripStatus.COMPLETED, "alert": alert])
                }else if alert.contains("ready"){
                    Helper.showSuccessMessage(title: nil, subtitle: alert)
                }
            }
        }
        print("RECEIVED REMOTE NOTIFICATION")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        SocketIOManager.sharedInstance.closeConnection()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {

    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        SocketIOManager.sharedInstance.establishConnection()
        _ = ChurchRepo().fetchNearbyChurchesIfNeeded()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "org.rccg.Transport4Church" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Transport4Church", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
}

//
//  ChurchRepo.swift
//  Transport4ChurchDriver
//
//  Created by Obrien Alaribe on 02/11/2016.
//
//

import Parse



class ChurchRepo {
    
    static var churchNames = Set<String>()
    static var churchCacheById = Dictionary<String, Church>()
    static var churchCacheByName = Dictionary<String, Church>()

    func fetchNearbyChurchesIfNeeded() {
        if ChurchRepo.churchNames.isEmpty && ChurchRepo.churchCacheById.isEmpty {
            let query = PFQuery(className: Church.parseClassName())
            query.findObjectsInBackground { (results, error) in
                if let churches = results as? [Church] {
                    for church in churches {
                        ChurchRepo.churchNames.insert(church.name!)
                        ChurchRepo.churchCacheById[church.objectId!] = church
                        ChurchRepo.churchCacheByName[church.name!] = church
                    }
                    print("Finished caching churches \(ChurchRepo.churchCacheById.count)")
                }
            }

        }else{
            print("No need to update church cache")
        }
        
        
    }
    static func getCurrentUserChurch() -> Church? {
        if let churchObject = PFUser.current()?["Church"] as? Church {
            if let church = ChurchRepo.churchCacheById[ churchObject.objectId!] {
                return church
            }
        }
        return nil
    }
    
}

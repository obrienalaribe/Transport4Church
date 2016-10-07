//
//  LocationResultsController.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 09/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit


protocol LocateOnTheMap{
    func locateWithLongitude(_ lon:Double, andLatitude lat:Double, andTitle title: String)
}

class LocationResultsController: UITableViewController {

    var searchResults: [String]!
    var delegate: LocateOnTheMap!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchResults = Array()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        cell.textLabel?.text = self.searchResults[(indexPath as NSIndexPath).row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath){
        // 1
        self.dismiss(animated: true, completion: nil)
        // 2
        let correctedAddress:String! = self.searchResults[(indexPath as NSIndexPath).row].addingPercentEncoding(withAllowedCharacters: CharacterSet.symbols)
        let url = URL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(correctedAddress)&sensor=false")
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
            // 3
            do {
                if data != nil{
                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as!  NSDictionary
                    
                    let lat = ((((dic["results"] as AnyObject).value(forKey: "geometry") as AnyObject).value(forKey: "location") as AnyObject).value(forKey: "lat") as AnyObject).object(at: 0) as! Double
                    let lon = ((((dic["results"] as AnyObject).value(forKey: "geometry") as AnyObject).value(forKey: "location") as AnyObject).value(forKey: "lng") as AnyObject).object(at: 0) as! Double
                    // 4
                    self.delegate.locateWithLongitude(lon, andLatitude: lat, andTitle: self.searchResults[(indexPath as NSIndexPath).row] )
                }
            }catch {
                print("Error")
            }
        }) 
        // 5
        task.resume()
    }
    
    func reloadDataWithArray(_ array:[String]){
        self.searchResults = array
        self.tableView.reloadData()
    }
    
}

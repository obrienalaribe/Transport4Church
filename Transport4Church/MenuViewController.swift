//
//  MenuViewController.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 19/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//


import UIKit

class MenuViewController: UITableViewController {

    private let userSection: [MenuItem] = [.Profile]
    private let enquirySection: [MenuItem] = [.Rate, .Like, .Copyright, .Terms, .Privacy, .FAQ, .Contact]
    private let menuIcons: Dictionary<MenuItem, String> = [.Profile : "user_male", .Rate : "rate", .Like : "like", .Copyright : "copyright", .Terms: "terms", .Privacy: "privacy", .FAQ : "faq", .Contact : "contact"]
    
    private let sections: NSArray = [" ", " "]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        self.tableView.separatorStyle = .SingleLine
        
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
       
        //remove extra cells in footer
        let footer = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 1))
        self.tableView.tableFooterView = footer
        
        //remove sticky header
        let dummyViewHeight : CGFloat = 40;
        let dummyView = UIView(frame:CGRectMake(0, 0, self.tableView.bounds.size.width, dummyViewHeight))
        self.tableView.tableHeaderView = dummyView;
        self.tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0);

        //add close button
        let closeBtn =  UIBarButtonItem(image: UIImage(named: "close"), style: .Plain, target: self, action: #selector(MenuViewController.closeMenu))
        closeBtn.tintColor = .blackColor()
        navigationItem.leftBarButtonItem = closeBtn
        

    }
    
    func closeMenu(){
        navigationController?.dismissViewControllerAnimated(false, completion: nil)
    }
    
    // return the number of sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    // return the title of sections
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return sections[section] as? String
    }
    
       // called when the cell is selected.
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            let editProfileController = ProfileViewController()
            editProfileController.title = "Edit Profile"
            navigationController?.pushViewController(editProfileController, animated: true)
            print("Value: \(userSection[indexPath.row])")
            
        } else if indexPath.section == 1 {
            
            switch(indexPath.row) {
                case 0:
                    MenuActions.openScheme("itms://itunes.apple.com/us/app/apple-store/id375380948?mt=8")
                    break
                case 1:
                    MenuActions.openScheme("fb://page/?id=1177853545619876")
                    break
                case 2:
                    break
                case 3:
                    break
                case 4:
                    break
                case 5:
                    break
                default:
                    return
                }
            
            print("Value: \(enquirySection[indexPath.row])")
            
        }
    }
    
    // MARK: - Tableview Data Source
    
    override  // return the number of cells each section.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return userSection.count
        } else if section == 1 {
            return enquirySection.count
        } else {
            return 0
        }
    }
    
    // return cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "\(userSection[indexPath.row])"
            cell.imageView?.image = UIImage(named: menuIcons[userSection[indexPath.row]]!)
            cell.imageView?.layer.cornerRadius = 40
            cell.imageView?.layer.masksToBounds = true
            cell.imageView?.backgroundColor = UIColor(white: 0.95, alpha: 1)

        } else if indexPath.section == 1 {
            cell.textLabel?.text = "\(enquirySection[indexPath.row])"
            cell.imageView?.image = UIImage(named: menuIcons[enquirySection[indexPath.row]]!)
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return 90;
            }
        }
        return 44;
    }
   
  }
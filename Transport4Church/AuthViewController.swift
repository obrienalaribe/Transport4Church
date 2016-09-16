//
//  AuthViewController.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 09/09/2016.
//  Copyright © 2016 rccg. All rights reserved.
//


import Eureka
import SCLAlertView

class AuthViewController : FormViewController {
    
    private var userRepo : UserRepo = UserRepo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Login/Register"
        
        form +++ Section("")
            <<< EmailRow("Email"){
                $0.title = "Email"
                $0.placeholder = "i.e emmy23@gmail.com"
            }
            
            <<< PasswordRow("Password"){
                $0.title = "Password"
            }
            
            +++ Section("Login as")
            <<< ActionSheetRow<String>("Role") {
                $0.title = "Rider or Driver ?"
                $0.selectorTitle = "Rider or Driver ?"
                $0.options = ["Rider","Driver"]
                $0.value = "Rider"
            }
            
            +++ Section() { section in
                section.header = {
                    var header = HeaderFooterView<UIButton>(.Callback({
                        let button = FormButton(title: "Submit")
                        button.addTarget(self, action: #selector(AuthViewController.handleFormSubmission(_:)), forControlEvents: .TouchUpInside)
                        return button
                    }))
                    header.height = { 50 }
                    return header
                }()
        }
        
    }
    
    func handleFormSubmission(sender: UIButton!){
        let valuesDictionary = form.values()

        let listOfEmptyFields = Helper.validateFormInputs(valuesDictionary)
        
        if listOfEmptyFields.isEmpty == false {
            
          let alertView = Helper.createAlert()
           
           alertView.showTitle(
                "Empty Input", // Title of view
                subTitle: "Please enter an email and password",
                duration: 5.0,
                completeText: "Okay",
                style: .Error,
                colorStyle: 0x00EE00,
                colorTextButton: 0xFFFFFF
            )
            
            
        }else{
            let credentials = Credentials(username: valuesDictionary["Email"] as! String, password: valuesDictionary["Password"] as! String, role: valuesDictionary["Role"] as! String)
           
            userRepo.authenticate(credentials, listener: self)
            
        }
        
    }
    
}
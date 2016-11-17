//
//  AuthViewController.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 09/09/2016.
//  Copyright © 2016 rccg. All rights reserved.
//


import Eureka

class AuthViewController : FormViewController {
    
    fileprivate var userRepo : UserRepo = UserRepo()
    
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
            
            +++ Section() { section in
                section.header = {
                    var header = HeaderFooterView<UIButton>(.callback({
                        let button = FormButton(title: "Submit")
                        button.addTarget(self, action: #selector(AuthViewController.handleFormSubmission(_:)), for: .touchUpInside)
                        return button
                    }))
                    header.height = { 50 }
                    return header
                }()
        }
        
    }
    
    func handleFormSubmission(_ sender: UIButton!){
        let valuesDictionary = form.values()

        if let email = valuesDictionary["Email"] as? String, let password = valuesDictionary["Password"] as? String {
            let credentials = Credentials(username: email.trim(), password: password.trim(), role: "Rider")
            
            userRepo.authenticate(credentials, listener: self)
        }else{
            Helper.showErrorMessage(title: "Invalid Entry", subtitle: "Please enter a username and password to login or register with")
        }
        
    }
    
}

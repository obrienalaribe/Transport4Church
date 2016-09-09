//
//  AuthViewController.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 09/09/2016.
//  Copyright © 2016 rccg. All rights reserved.
//


import Eureka

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
            
            +++ Section() { section in
                section.header = {
                    var header = HeaderFooterView<UIButton>(.Callback({
                        let button = FormButton(title: "Submit")
                        button.addTarget(self, action: "handleFormSubmission:", forControlEvents: .TouchUpInside)
                        return button
                    }))
                    header.height = { 50 }
                    return header
                }()
        }
        
        
    }
    
    func handleFormSubmission(sender: UIButton!){
        
        self.navigationController?.setViewControllers([EditProfileViewController()], animated: true)

        
    }
    
}
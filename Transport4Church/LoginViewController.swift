//
//  ViewController.swift
//  Transport4Church
//
//  Created by mac on 8/7/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    var firstnameField: UITextField!
    var lastnameField: UITextField!
    let mainContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    var emailRegisterStackView : UIStackView!

    var mainContainerFrame : CGRect!
    
    var mainContainerStack : UIStackView!
    
    var socialLoginView : UIView!
    var emailLoginView : UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstnameField = textfieldFactory("Enter firstname")
        lastnameField = textfieldFactory("Enter lastname")
        
        firstnameField.delegate = self
        lastnameField.delegate = self

        socialLoginView = UIView()

        socialLoginView.backgroundColor = UIColor.blackColor()
  
        
        emailLoginView = UIView()
        emailLoginView.backgroundColor = UIColor.orangeColor()
        
        

        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.redColor()
        setupLastNameField()

        setupMainContainer()
//        setupFirstNameField()
    }

    private func setupMainContainer() {
        view.addSubview(mainContainer)
        
        mainContainerFrame = CGRectMake(0, 0, 0, view.frame.height / 2)
        mainContainer.frame = mainContainerFrame
        let margins = view.layoutMarginsGuide

        mainContainer.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor).active = true
        mainContainer.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor).active = true
        mainContainer.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor,
                                                    constant: 8.0).active = true
      
      
        mainContainer.heightAnchor.constraintEqualToConstant(mainContainerFrame.height).active = true
        mainContainer.translatesAutoresizingMaskIntoConstraints = false

        mainContainerStack = UIStackView()
        
        mainContainerStack.axis = .Vertical;
        mainContainerStack.distribution = .EqualSpacing;
        mainContainerStack.spacing = 5;
        
        mainContainer.addSubview(mainContainerStack)
        
        mainContainerStack.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor).active = true
        mainContainerStack.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor).active = true
        mainContainerStack.topAnchor.constraintEqualToAnchor(mainContainer.topAnchor,
                                                        constant: 8.0).active = true

        
                mainContainerStack.heightAnchor.constraintEqualToConstant(mainContainer.frame.height).active = true
                     mainContainerStack.translatesAutoresizingMaskIntoConstraints = false

        mainContainerStack.addArrangedSubview(socialLoginView)
        mainContainerStack.addArrangedSubview(emailLoginView)

        mainContainerStack.addConstraintsWithFormat("H:|[v0]|", views: socialLoginView)
        mainContainerStack.addConstraintsWithFormat("H:|[v0]|", views: emailLoginView)

        mainContainerStack.addConstraintsWithFormat("V:[v0(\(mainContainerFrame.height / 2))][v1(v0)]", views: socialLoginView, emailLoginView)
        
        emailLoginView.addSubview(lastnameField)
        emailLoginView.addConstraintsWithFormat("H:|[v0]|", views: lastnameField)
        emailLoginView.addConstraintsWithFormat("V:|[v0]", views: lastnameField)

    }
    
    private func setupLastNameField(){
//        mainContainer.addSubview(lastnameField)
//        mainContainer.addConstraintsWithFormat("H:|-20-[v0]-20-|", views: lastnameField)
//        mainContainer.addConstraintsWithFormat("V:|[v0]", views: lastnameField)
//
//        lastnameField.centerXAnchor.constraintEqualToAnchor(textFieldContainer.centerXAnchor).active = true
//        lastnameField.centerYAnchor.constraintEqualToAnchor(textFieldContainer.centerYAnchor).active = true
//        lastnameField.widthAnchor.constraintEqualToConstant(textFieldContainer.frame.width - 10).active = true
//        lastnameField.heightAnchor.constraintEqualToConstant(50).active = true
//        lastnameField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupFirstNameField(){
//
    }
    
    // MARK:- ---> Textfield Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        print("TextField did begin editing method called")
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("TextField did end editing method called")
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        print("TextField should begin editing method called")
        return true;
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        print("TextField should clear method called")
        return true;
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("TextField should snd editing method called")
        return true;
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
    // MARK: Textfield Delegates <---
    
    
    func textfieldFactory(placeholder: String) -> UITextField{
        let textfield = UITextField(frame: .zero)
        textfield.placeholder = placeholder
        textfield.font = UIFont.systemFontOfSize(15)
        textfield.borderStyle = UITextBorderStyle.Bezel
        textfield.autocorrectionType = UITextAutocorrectionType.No
        textfield.keyboardType = UIKeyboardType.Default
        textfield.returnKeyType = UIReturnKeyType.Done
        textfield.clearButtonMode = UITextFieldViewMode.WhileEditing;
        textfield.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
//        textfield.layer.cornerRadius = 0
        textfield.layer.masksToBounds = true
        textfield.layer.borderColor = UIColor.grayColor().CGColor
        textfield.layer.borderWidth = 1
    
        textfield.font = UIFont.boldSystemFontOfSize(16)
        return textfield
    }

}


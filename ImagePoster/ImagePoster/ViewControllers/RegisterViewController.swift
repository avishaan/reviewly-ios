//
//  RegisterViewController.swift
//  ImagePoster
//
//  Created by Umair Bhatti on 11/12/2015.
//  Copyright © 2015 ImagePoster. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupView()
        
    }
    
    func setupView() {
    
        self.setBorder(self.headerView)
        self.errorLbl.text = ""
        
    }
    
    func registerProcessing() {
        
        var accessToken:String = ""
        if WebService.registerUserNamePass(self.userNameTxt.text!, password: self.passwordTxt.text!, accessToken: &accessToken) == true {
            
            SVProgressHUD.dismiss()
            Utility.saveObject(accessToken, key: "accessToken")
            Utility.saveObject(self.userNameTxt.text!, key: "userName")
            self.pushViewController("TutorialViewController")
            Utility.showAlert("Success", message: "Registration successfull.")
            
        }
        
        SVProgressHUD.dismiss()
    }
    
    @IBAction func backAct(sender: UIButton) {
        
        self.popViewController()
        
    }
    
    @IBAction func registerAct(sender: UIButton) {
        
        if self.userNameTxt.text?.characters.count == 0 {
            
            self.errorLbl.text = "Username missing."
            
        }else if self.passwordTxt.text?.characters.count == 0 || self.confirmPasswordTxt.text?.characters.count == 0 {
            
            self.errorLbl.text = "Password missing."
            
        }else if self.passwordTxt.text != self.confirmPasswordTxt.text{
            
            self.errorLbl.text = "Passwords don't match."
            
        }else {
            
            SVProgressHUD .showWithStatus("Processing...")
            self.performSelector("registerProcessing", withObject: nil, afterDelay: 0.1)
            
        }
    }
}


//
//  LoginViewController.swift
//  ImagePoster
//
//  Created by Umair Bhatti on 11/12/2015.
//  Copyright © 2015 ImagePoster. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit

class LoginViewController: BaseViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    var token = String()
    var userName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
    }
    
    func setupView() {
    
        self.menuController = self.menuContainerViewController
        self.menuController.panMode = MFSideMenuPanModeNone
        self.setBorder(self.headerView)
        
        let fbBtn = FBSDKLoginButton()
        fbBtn.readPermissions=["email"]
        fbBtn.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width - 40, height: 40)
        fbBtn.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 80);
        fbBtn.delegate = self
        self.view.addSubview(fbBtn)
        
        let twitterBtn = TWTRLogInButton(logInCompletion: { session, error in
            
            if (session != nil) {
                
                self.token = (session?.authToken)!
                self.userName = (session?.userName)!
                SVProgressHUD.showWithStatus("Processing...")
                self.performSelector("loginProcessingFbTwitter", withObject: nil, afterDelay: 0.1)
                
            } else {
                
                Utility.showAlert("Problem", message: "Can't login now. Try later.")
                
            }
        })
        twitterBtn.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width - 40, height: 40)
        twitterBtn.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 40);
        self.view.addSubview(twitterBtn)
        
    }
    
    func loginProcessingFbTwitter() {
        
        var accessToken:String = ""
        if WebService.loginFbTwitter(token, accessToken: &accessToken) == true {
            
            SVProgressHUD.dismiss()
            Utility.saveObject(accessToken, key: "accessToken")
            Utility.saveObject(self.usernameTxt.text!, key: "userName")
            self.pushViewController("TutorialViewController")
            
        }
        
        SVProgressHUD.dismiss()
    }
    
    func loginProcessing() {
    
        var accessToken:String = ""
        if WebService.loginUserNamePass(self.usernameTxt.text!, password: self.passwordTxt.text!, accessToken: &accessToken) == true {
            
            SVProgressHUD.dismiss()
            Utility.saveObject(accessToken, key: "accessToken")
            Utility.saveObject(self.userName, key: "userName")
            self.pushViewController("TutorialViewController")
            
        }
        
        SVProgressHUD.dismiss()
    }
    
    func getFbUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                
                Utility.showAlert("Problem", message: "Can't login now. Try later.")
                
            }else {
                print(result)
                self.token = FBSDKAccessToken.currentAccessToken().tokenString
                self.userName = result["email"] as! String
                SVProgressHUD.showWithStatus("Processing...")
                self.performSelector("loginProcessingFbTwitter", withObject: nil, afterDelay: 0.1)

            }
        })
    }
    
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if ((error) != nil) || result.isCancelled {
            
            Utility.showAlert("Problem", message: "Can't login now. Try later.")
            
        }else if result.grantedPermissions.contains("email") {
            
                getFbUserData()
            
        }else {
        
            Utility.showAlert("Problem", message: "Can't login now. Try later.")
            
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged In")
    }
    
    //actions
    @IBAction func loginAct(sender: UIButton) {
        
        if self.usernameTxt.text?.characters.count == 0 {
            
            Utility.showAlert("Problem", message: "Username missing")
            
        }else if self.passwordTxt.text?.characters.count == 0 {
            
            Utility.showAlert("Problem", message: "Password missing")
            
        }else {
            
            self.userName = self.usernameTxt.text!
            SVProgressHUD.showWithStatus("Processing...")
            self.performSelector("loginProcessing", withObject: nil, afterDelay: 0.1)
            
        }
        
    }
    
    @IBAction func registerAct(sender: UIButton) {
        
        self.pushViewController("RegisterViewController")
        
    }
    
}


//
//  BaseViewController.swift
//  ImagePoster
//
//  Created by Umair Bhatti on 11/12/2015.
//  Copyright © 2015 ImagePoster. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UITextFieldDelegate {
    
    let cornerRadius:CGFloat = 5.0
    let borderWidth:CGFloat = 1.0
    let borderColor = UIColor(red: 0.55, green: 0.64, blue: 1.0, alpha: 1.0).CGColor
    var menuController:MFSideMenuContainerViewController! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.setupFieldsnBtns(self.view)
    }
    
    
    func setupFieldsnBtns(mainView: UIView) {
    
        for subview in mainView.subviews {
            
            if subview.subviews.count > 0 {
            
                self.setupFieldsnBtns(subview)
                
            }
            if subview is UITextField {
            
                let textfield = subview as! UITextField
                self.setBorder(textfield)
                
//                textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: subview.frame.size.height))
//                textfield.leftViewMode = UITextFieldViewMode.Always;
                
                textfield.delegate = self
                
                
            }else if subview is UIButton {
                
                self.setCorner(subview)
                
            }else if subview is UITextView {
                
                
                
            }
            
        }
        
    }
    
    func setBordernCorner(mainView:UIView) {
        
        mainView.layer.borderWidth = borderWidth
        mainView.layer.borderColor = borderColor
        mainView.layer.cornerRadius = cornerRadius
        
    }
    
    func setBorder(mainView:UIView) {
        
        mainView.layer.borderWidth = borderWidth
        mainView.layer.borderColor = borderColor
        
    }
    
    func setCorner(mainView:UIView) {
        
        mainView.layer.cornerRadius = cornerRadius
        
    }
    
    //textfield delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    func pushViewController(identifier:String) {
    
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let viewController = storyboard.instantiateViewControllerWithIdentifier(identifier) as! BaseViewController
        viewController.menuController = self.menuController
        
        self.menuController.centerViewController.pushViewController(viewController, animated: true)
        
    }
    
    func popViewController( ) {
        
        self.menuController.centerViewController.popViewControllerAnimated(true)
        
    }
}


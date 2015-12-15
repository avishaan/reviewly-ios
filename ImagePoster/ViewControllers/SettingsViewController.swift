//
//  SettingsViewController.swift
//  ImagePoster
//
//  Created by Umair Bhatti on 12/12/2015.
//  Copyright © 2015 ImagePoster. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var userDataView: UIView!
    @IBOutlet weak var reviewsCountLbl: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var rankLbl: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupView()
        SVProgressHUD .showWithStatus("Processing...")
        self.performSelector("getSettings", withObject: nil, afterDelay: 0.1)
        
    }
    
    func setupView() {
        
        self.setBorder(self.headerView)
        self.setBorder(self.emailTxt)
        self.setBorder(self.userDataView)
        
        self.emailTxt.text = ""
        self.reviewsCountLbl.text = ""
        self.pointsLbl.text = ""
        self.rankLbl.text = ""
        
    }
    
    func getSettings() {
    
        let userName = Utility.getObject("userName") as! String
        let accessToken = Utility.getObject("accessToken") as! String
        
        var response:[String:NSObject] = [String:NSObject]()
        
        if WebService.getSettings(userName, accessToken: accessToken, response: &response) == true {
        
            self.emailTxt.text = userName
            self.reviewsCountLbl.text = "\(response["reviews"]!)"
            self.pointsLbl.text = "\(response["points"]!)"
            self.rankLbl.text = "\(response["rank"]!)"
        
        }
        
        SVProgressHUD.dismiss()
        
    }
    
    @IBAction func openMenuAct(sender: AnyObject) {
        
        self.menuController.toggleLeftSideMenuCompletion(nil)
        
    }
    
    
}

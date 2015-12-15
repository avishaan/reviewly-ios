//
//  MenuViewController.swift
//  ImagePoster
//
//  Created by Umair Bhatti on 11/12/2015.
//  Copyright © 2015 ImagePoster. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var menuTbl: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //tableview datasource and delegate
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:SimpleCell = tableView.dequeueReusableCellWithIdentifier("SimpleCell") as! SimpleCell
        let selectedBgView = UIView()
        selectedBgView.backgroundColor = UIColor(CGColor:borderColor)
        cell.selectedBackgroundView = selectedBgView
        
        
        switch indexPath.row {
        
        case 0:
            cell.titleLbl.text = "Add New"
        case 1:
            cell.titleLbl.text = "My Reviews"
        case 2:
            cell.titleLbl.text = "Settings"
        default:
            cell.titleLbl.text = "Tutorial"
            
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.menuContainerViewController.menuState = MFSideMenuStateClosed
        
        var identifier: String
        
        switch indexPath.row {
            
        case 0:
            identifier = "AddReviewViewController"
        case 1:
            identifier = "MyReviewsViewController"
        case 2:
            identifier = "SettingsViewController"
        default:
            identifier = "TutorialViewController"
            
        }
        self.pushViewController(identifier)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
}


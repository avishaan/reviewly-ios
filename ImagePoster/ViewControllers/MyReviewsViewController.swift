//
//  MyReviewsViewController.swift
//  ImagePoster
//
//  Created by Umair Bhatti on 12/12/2015.
//  Copyright © 2015 ImagePoster. All rights reserved.
//

import UIKit

class MyReviewsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var reviewsTbl: UITableView!
    
    var myReviews:[NSObject] = [NSObject]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupView()
        SVProgressHUD .showWithStatus("Processing...")
        self.performSelector("getMyReviews", withObject: nil, afterDelay: 0.1)
        
    }
    
    func setupView() {
    
        self.setBorder(self.headerView)
    
    }
    
    func getMyReviews() {
        
        let accessToken = Utility.getObject("accessToken") as! String
        
        var response:[NSObject] = [NSObject]()
        
        if WebService.getMyReviews(accessToken, response: &response) == true {
            
            myReviews = response
            self.reviewsTbl.reloadData()
            
        }
        
        SVProgressHUD.dismiss()
        
    }
    
    //tableview datasource and delegate
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:ReviewCell = tableView.dequeueReusableCellWithIdentifier("ReviewCell") as! ReviewCell
        
        let review = self.myReviews[indexPath.row] as! [String:NSObject]
        
        cell.setTitleLblText(review["company"] as! String)
        cell.descriptionLbl.text = review["description"] as? String
        cell.dateLbl.text = review["datetime"] as? String
        
        return cell
        
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.myReviews.count
        
    }
    
    @IBAction func openMenuAct(sender: UIButton) {
        
        self.menuController.toggleLeftSideMenuCompletion(nil)
        
    }
    
    @IBAction func addReviewAct(sender: UIButton) {
        
        self.pushViewController("AddReviewViewController")
        
    }
}


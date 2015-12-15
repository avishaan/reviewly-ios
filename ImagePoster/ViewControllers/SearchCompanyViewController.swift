//
//  SearchCompanyViewController.swift
//  ImagePoster
//
//  Created by Umair Bhatti on 11/12/2015.
//  Copyright © 2015 ImagePoster. All rights reserved.
//

import UIKit

class SearchCompanyViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var companiesTbl: UITableView!
    var companies:[String] = [String]()
    
    var location = String()
    var callback:((company:String)->Void)! = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setBorder(self.headerView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(location:String, callback:(company:String)->Void) {
    
        self.location = location
        self.callback = callback
        
    }
    
    //tableview datasource and delegate
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:SimpleCell = tableView.dequeueReusableCellWithIdentifier("SimpleCell") as! SimpleCell
        let selectedBgView = UIView()
        selectedBgView.backgroundColor = UIColor(CGColor:borderColor)
        cell.selectedBackgroundView = selectedBgView
        
        cell.titleLbl.text = self.companies[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.searchTxt.text = self.companies[indexPath.row]
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.companies.count
        
    }
    
    //action methods
    
    @IBAction func searchAct(sender: UIButton) {
        
        if self.searchTxt.text?.characters.count > 0 {
            SVProgressHUD.showWithStatus("Processing...")
            self.performSelector("searchProcessing", withObject: nil, afterDelay: 0.1)
        }
        
    }
    
    func searchProcessing() {
    
        let accessToken = Utility.getObject("accessToken") as! String
        
        var response:[String] = [String]()
        
        if WebService.getCompanies(self.searchTxt.text!, location: self.location, radius: "10000", accessToken: accessToken, response: &response) == true {
            
            self.companies = response
            self.companiesTbl.reloadData()
            
        }
        
        SVProgressHUD.dismiss()
        
    }
    
    @IBAction func doneAct(sender: UIButton) {
        
        if self.callback != nil {
            self.callback(company: self.searchTxt.text!)
        }
        self.popViewController()
        
    }
    
    
    
}

//
//  AddReviewViewController.swift
//  ImagePoster
//
//  Created by Umair Bhatti on 11/12/2015.
//  Copyright © 2015 ImagePoster. All rights reserved.
//

import UIKit
import QuartzCore
import CoreLocation

class AddReviewViewController: BaseViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var companyNameTxt: UITextField!
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var remainingCharTxt: UILabel!
    
    @IBOutlet weak var img1View: UIView!
    @IBOutlet weak var img2View: UIView!
    @IBOutlet weak var img3View: UIView!
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var ok1: UILabel!
    
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var ok2: UILabel!
    
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var ok3: UILabel!
    
    @IBOutlet weak var imageSourceSelView: UIView!
    
    @IBOutlet weak var ratingView: UIView!
    
    @IBOutlet weak var whenView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
    let descriptionPlaceholder = "Brief Description (e.g. Laura made my coffee tast so burt today! This is the second in row)"
    let totalChars = 140
    
    var imagePicker:UIImagePickerController! = nil
    var currentImgIndex:Int = 0
    var currentRating = 0
    var location:CLLocation! = nil
    
    var locationManager:CLLocationManager! = nil
    
    var companyViewController:SearchCompanyViewController! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.createStars(self.ratingView)
        
    }
    
    func setupView() {
    
        self.setBorder(self.headerView)
        self.setBorder(self.descriptionTxt)
        self.setBorder(self.companyNameTxt)
        self.setBorder(self.img1View)
        self.setBorder(self.img2View)
        self.setBorder(self.img3View)

        self.descriptionTxt.delegate = self
        self.descriptionTxt.text = descriptionPlaceholder
        self.descriptionTxt.textColor = UIColor(CGColor: borderColor)
        self.remainingCharTxt.text = "0 / \(totalChars)"
        
        self.ok1.layer.cornerRadius = self.ok2.frame.size.height / 2
        self.ok2.layer.cornerRadius = self.ok2.frame.size.height / 2
        self.ok3.layer.cornerRadius = self.ok3.frame.size.height / 2
        
        self.setBordernCorner(self.imageSourceSelView)
        self.setBordernCorner(self.whenView)
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
    }
    
    func createStars(containerView:UIView) {
    
        for subview in containerView.subviews {
        
            if subview is UIButton {
            
                let layer = CAShapeLayer()
                layer.path = createStarPath(subview.frame.size)
                layer.lineWidth = 1
                layer.strokeColor = UIColor.whiteColor().CGColor
                if subview.tag <= self.currentRating {
                    layer.fillColor = UIColor.yellowColor().CGColor
                }else {
                    layer.fillColor = UIColor.clearColor().CGColor
                }
                
                layer.fillRule = kCAFillRuleNonZero
                
                subview.layer.sublayers?.removeAll()
                subview.layer.addSublayer(layer)
                
            }else if subview.subviews.count > 0 {
            
                self.createStars(subview)
                
            }
        }
        
    }
    
    
    func createStarPath(size: CGSize) -> CGPath {
        let numberOfPoints: CGFloat = 5
        
        let starRatio: CGFloat = 0.5
        
        let steps: CGFloat = numberOfPoints * 2
        
        let outerRadius: CGFloat = min(size.height, size.width) / 2
        let innerRadius: CGFloat = outerRadius * starRatio
        
        let stepAngle = CGFloat(2) * CGFloat(M_PI) / CGFloat(steps)
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        
        let path = CGPathCreateMutable()
        
        for i in 0..<Int(steps) {
            let radius = i % 2 == 0 ? outerRadius : innerRadius
            
            let angle = CGFloat(i) * stepAngle - CGFloat(M_PI_2)
            
            let x = radius * cos(angle) + center.x
            let y = radius * sin(angle) + center.y
            
            if i == 0 {
                CGPathMoveToPoint(path, nil, x, y)
            }
            else {
                CGPathAddLineToPoint(path, nil, x, y)
            }
        }
        
        CGPathCloseSubpath(path)
        return path
    }
    
    //location manager delegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.location = locations.last
    
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    
        print("Error \(error.description)")
        
    }
    
    
    
    //uitextview delegate
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        textView.textColor = UIColor.whiteColor()
        if textView.text == descriptionPlaceholder {
        
            textView.text = ""
            
        }
        return true
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        if textView.text == "" {
            
            textView.text = descriptionPlaceholder
            textView.textColor = UIColor(CGColor: borderColor)
            
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text.characters.count == 0 {
            return true
        }
        else if textView.text.characters.count > (totalChars - 1) {
            return false
        }
        
        return true
        
    }
    
    func textViewDidChange(textView: UITextView) {
        
        self.remainingCharTxt.text = "\(textView.text.characters.count) / \(totalChars)"
        
    }
    
    //imagepicker delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        switch self.currentImgIndex {
        
        case 1:
            self.img1.image = chosenImage
            self.ok1.text = "\u{2716}"
            self.ok1.backgroundColor = UIColor.redColor()
            
        case 2:
            self.img2.image = chosenImage
            self.ok2.text = "\u{2716}"
            self.ok2.backgroundColor = UIColor.redColor()
            
        default:
            self.img3.image = chosenImage
            self.ok3.text = "\u{2716}"
            self.ok3.backgroundColor = UIColor.redColor()
            
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    //action methods
    @IBAction func uploadImgAct(sender: UIButton) {
        
        var currentTitle = String()
        switch sender.tag {
        case 1:
            currentTitle = self.ok1.text!
        case 2:
            currentTitle = self.ok2.text!
        default:
            currentTitle = self.ok3.text!
        }
        if currentTitle.containsString("\u{271A}") {
        
            if self.imagePicker == nil {
                
                self.imagePicker = UIImagePickerController()
                self.imagePicker.delegate = self
                self.imagePicker.allowsEditing = false
                
            }
            
            self.imageSourceSelView.hidden = false
            self.currentImgIndex = sender.tag
            
        }else {
        
            switch sender.tag {
                
            case 1:
                self.img1.image = nil
                self.ok1.text = "\u{271A}"
                self.ok1.backgroundColor = UIColor(red: 23.0/255.0, green: 154.0/255.0, blue: 15.0/255.0, alpha: 1.0)
                
            case 2:
                self.img2.image = nil
                self.ok2.text = "\u{271A}"
                self.ok2.backgroundColor = UIColor(red: 23.0/255.0, green: 154.0/255.0, blue: 15.0/255.0, alpha: 1.0)
                
            default:
                self.img3.image = nil
                self.ok3.text = "\u{271A}"
                self.ok3.backgroundColor = UIColor(red: 23.0/255.0, green: 154.0/255.0, blue: 15.0/255.0, alpha: 1.0)
                
            }
            
        }
        
        
        
    }
    
    @IBAction func changeImageSourceAct(sender: UIButton) {
        
        self.imageSourceSelView.hidden = true
        if sender.tag == 1 {// camera button is pressed
            
            if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                
                Utility.showAlert("Problem", message: "Camera not detected.")
                return
                
            }
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera

        }else {
        
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary

        }
        self.presentViewController(self.imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func changeRatingAct(sender: UIButton) {
        
        self.currentRating = sender.tag
        self.createStars(self.ratingView)
        
    }
    
    @IBAction func whenAct(sender: AnyObject) {
        
        self.datePicker.date = NSDate()
        self.timePicker.date = NSDate()
        self.whenView.hidden = false
        
    }
    
    @IBAction func whenSelectionDoneAct(sender: UIButton) {
        
        self.whenView.hidden = true
        
    }
    
    @IBAction func openMenuAct(sender: UIButton) {
        
        self.menuController.toggleLeftSideMenuCompletion(nil)
        
    }
    
    @IBAction func showInfoAct(sender: UIButton) {
    }
    
    @IBAction func submitReviewAct(sender: UIButton) {
        
        
        if self.companyNameTxt.text?.characters.count == 0 {
        
            Utility.showAlert("Problem", message: "Missing company name.")
            
        }else if self.descriptionTxt.text?.characters.count == 0 {
            
            Utility.showAlert("Problem", message: "Missing description.")
            
        }
        
        SVProgressHUD.showWithStatus("Processing...")
        self.performSelector("reviewProcessing", withObject: nil, afterDelay: 0.1)
        
    }
    
    func reviewProcessing() {
    
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var datetime = dateFormatter.stringFromDate(self.datePicker.date)
        dateFormatter.dateFormat = "HH:mm:ss"
        datetime = datetime + "T" + dateFormatter.stringFromDate(self.timePicker.date) + "Z"
        
        var loc = "0.00 0.00"
        if self.location != nil {
            loc = "\(self.location.coordinate.latitude) \(self.location.coordinate.longitude)"
        }
        
        let accessToken = Utility.getObject("accessToken") as! String
        
        let images:NSMutableArray = []
        if self.img1.image != nil {
            
            images.addObject(self.img1.image!)
            
        }
        if self.img2.image != nil {
            
            images.addObject(self.img2.image!)
            
        }
        if self.img3.image != nil {
            
            images.addObject(self.img3.image!)
            
        }
        
        if WebService.newReview(accessToken, company: self.companyNameTxt.text!, description: self.descriptionTxt.text!, rating: self.currentRating, datetime: datetime, location: loc, images: images) == true {
            
            Utility.showAlert("Success", message: "Review added successfully.")
            
        }
        SVProgressHUD.dismiss()
        
    }
    
    @IBAction func openCampanyViewControllerAct(sender: UIButton) {
        
        if self.companyViewController == nil {
            
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            self.companyViewController = storyboard.instantiateViewControllerWithIdentifier("SearchCompanyViewController") as! SearchCompanyViewController
            self.companyViewController.menuController = self.menuController
        
        }
        
        var loc = "0.00 0.00"
        if self.location != nil {
            loc = "\(self.location.coordinate.latitude) \(self.location.coordinate.longitude)"
        }
        
        self.companyViewController.setData(loc) { (company) -> Void in
            
            self.companyNameTxt.text = company
            
        }
        self.menuController.centerViewController.pushViewController(self.companyViewController, animated: true)
        
    }

}

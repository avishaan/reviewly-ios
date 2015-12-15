//
//  TutorialViewConroller.swift
//  ImagePoster
//
//  Created by Umair Bhatti on 11/12/2015.
//  Copyright © 2015 ImagePoster. All rights reserved.
//

import UIKit

class TutorialViewController: BaseViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    @IBAction func startAct(sender: UIButton) {
        
        self.pushViewController("MyReviewsViewController")
        
    }
    
}

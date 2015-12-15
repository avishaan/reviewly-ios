//
//  ReviewCell.swift
//  ImagePoster
//
//  Created by Umair Bhatti on 12/12/2015.
//  Copyright © 2015 ImagePoster. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    func setTitleLblText(text:String) {
        
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: text, attributes: underlineAttribute)
        titleLbl.attributedText = underlineAttributedString
        
    }
}

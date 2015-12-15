//
//  Utility.swift
//  ImagePoster
//
//  Created by Umair Bhatti on 13/12/2015.
//  Copyright © 2015 ImagePoster. All rights reserved.
//

import UIKit

class Utility {
    
    static func isNetworkAvailable() -> Bool {
    
        if Int(Reachability.reachabilityForInternetConnection().currentReachabilityStatus()) == kNotReachable {
            
            return false
            
        }
        return true
        
    }
    
    static func showAlert(title:String, message:String) {
    
        let alert = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "OK")
        alert.show()
    
    }
    
    static func saveObject(object:AnyObject, key:String) {
    
        NSUserDefaults.standardUserDefaults().setObject(object, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    
    static func getObject(key:String) -> AnyObject? {
    
        return NSUserDefaults.standardUserDefaults().objectForKey(key)
        
    }
    
}
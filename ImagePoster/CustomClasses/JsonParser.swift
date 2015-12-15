//
//  JsonParser.swift
//  ImagePoster
//
//  Created by Umair Bhatti on 13/12/2015.
//  Copyright © 2015 ImagePoster. All rights reserved.
//

import Foundation

class JsonParser {
    
    static func parseLoginUserNamePass(jsonResponse:String) -> String {
    
        let json:[String:String] = jsonResponse.JSONValue() as! [String:String]
        return json["token"]!
        
    }
    
    static func parseSettings(jsonResponse:String) -> [String:NSObject] {
        
        let json:[String:NSObject] = jsonResponse.JSONValue() as! [String:NSObject]
        let profile = json["profile"]! as! [String:NSObject]
        
        var response = [String:NSObject]()
        response["rank"] = profile["rank"]
        response["points"] = profile["points"]
        response["reviews"] = profile["reviews"]
        
        return response
        
    }
    
    static func parseMyReviews(jsonResponse:String) -> [NSObject] {
        
        let json = jsonResponse.JSONValue() as! [NSObject]
        var myReviews = [NSObject]()
        
        for jsonReview in json {
        
            let reviewJson = jsonReview as! [String:NSObject]
            var review = [String:NSObject]()
            review["company"] = reviewJson["company"] as! String
            review["description"] = reviewJson["description"] as! String
            review["datetime"] = reviewJson["datetime"] as! String
            myReviews.append(review)
            
        }
        return myReviews
        
    }
    
    static func parseCompanies(jsonResponse:String) -> [String] {
        
        let json = jsonResponse.JSONValue() as! [NSObject]
        var companies = [String]()
        
        for jsonCompany in json {
            
            let companyJson = jsonCompany as! [String:String]
            companies.append(companyJson["name"]!)
            
        }
        return companies
        
    }
    
    static func parseUploadImage(jsonResponse:String) -> String {
        
        let json:[String:NSObject] = jsonResponse.JSONValue() as! [String:NSObject]
        return json["_id"] as! String
        
    }
    
}
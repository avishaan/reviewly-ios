//
//  WebService.swift
//  ImagePoster
//
//  Created by Umair Bhatti on 13/12/2015.
//  Copyright © 2015 ImagePoster. All rights reserved.
//

import Foundation

class WebService {
    
    static let baseUrl = "http://reviewly.herokuapp.com:80/api/v1"
    static let loginuserNamePassUrl = "/auths/basic"
    static let loginFbTwitterUrl = "/auths/facebook"
    static let registeruserNamePassUrl = "/users"
    static let getSettingsUrl = "/users"
    static let myReviewsUrl = "/reviews"
    static let companyUrl = "/search"
    static let uploadImageUrl = "/images"
    static let newReviewUrl = "/reviews"
    
    static func checkNetwork() -> Bool {
    
        if Utility.isNetworkAvailable() == false {
            
            Utility.showAlert("Problem", message: "No network available.")
            return false
            
        }
        
        return true
        
    }
    
    static func getResponsePost(url:String, parameters: [String : NSObject], inout response:String, customMessage:String! = nil) -> Bool{
        
        let jsonParameters = SBJsonWriter().stringWithObject(parameters)
    
        let request = ASIHTTPRequest(URL: NSURL(string:(baseUrl + url)))
        request.requestMethod = "POST"
        request.addRequestHeader("Content-Type", value: "application/json")
        
        
        request.postBody = NSMutableData(data: jsonParameters.dataUsingEncoding(NSASCIIStringEncoding)!)
        request.startSynchronous()
        
        if request.responseStatusCode != 200 {
        
            if customMessage != nil {
                Utility.showAlert("Problem", message: customMessage)
            }else{
                Utility.showAlert("Problem", message: "Cannot process now. Try later")
            }
            return false
            
        }
        
        response = request.responseString()
        return true
        
    }
    
    static func getResponseGet(url:String, parameters: [String : String], inout response:String) -> Bool{
        
        var urlParams = "?"
        for key in parameters.keys {
        
            urlParams = urlParams + key + "=" + parameters[key]! as String + "&"
            
        }
        var url = url + urlParams
        url = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let request = ASIHTTPRequest(URL: NSURL(string:(baseUrl + url)))
        request.requestMethod = "GET"
        request.startSynchronous()
        
        if request.responseStatusCode != 200 {
            
            Utility.showAlert("Problem", message: "Cannot process now. Try later")
            return false
            
        }
        
        response = request.responseString()
        return true
        
    }
    
    static func loginUserNamePass(userName:String, password:String, inout accessToken:String) -> Bool {
    
        if WebService.checkNetwork() == true {
        
            let parameters = ["username" : userName, "password": password]
            var jsonResponse:String = ""
            
            if WebService.getResponsePost(loginuserNamePassUrl, parameters: parameters, response: &jsonResponse, customMessage: "Invalid login credentials.") == true {
            
                accessToken = JsonParser.parseLoginUserNamePass(jsonResponse)
                return true
                
            }
            
        }
        return false
        
    }
    
    static func loginFbTwitter(token:String, inout accessToken:String) -> Bool {
        
        if WebService.checkNetwork() == true {
            
            let parameters = ["access_token" : token]
            var jsonResponse:String = ""
            
            if WebService.getResponsePost(loginFbTwitterUrl, parameters: parameters, response: &jsonResponse) == true {
                
                accessToken = JsonParser.parseLoginUserNamePass(jsonResponse)
                return true
                
            }
            
        }
        return false
        
    }
    
    static func registerUserNamePass(userName:String, password:String, inout accessToken:String) -> Bool {
        
        if WebService.checkNetwork() == true {
            
            let parameters = ["username" : userName, "password": password]
            var jsonResponse:String = ""
            
            if WebService.getResponsePost(registeruserNamePassUrl, parameters: parameters, response: &jsonResponse) == true {
                
                if WebService.getResponsePost(loginuserNamePassUrl, parameters: parameters, response: &jsonResponse) == true {
                    
                    accessToken = JsonParser.parseLoginUserNamePass(jsonResponse)
                    return true
                    
                }
                Utility.showAlert("Problem", message: "Cannot process now. Try later")
                return false
                
            }
            
        }
        return false
        
    }
    
    static func getSettings(userName:String, accessToken:String, inout response:[String:NSObject]) -> Bool {
        
        if WebService.checkNetwork() == true {
            
            let parameters = ["access_token":accessToken]
            
            var jsonResponse = String()
            if self.getResponseGet((getSettingsUrl + "/" + userName), parameters: parameters, response: &jsonResponse) == true {
            
                response = JsonParser.parseSettings(jsonResponse)
                return true
                
            }
            
        }
        return false
        
    }
    
    static func getMyReviews(accessToken:String, inout response:[NSObject]) -> Bool {
        
        if WebService.checkNetwork() == true {
            
            let parameters = ["access_token":accessToken]
            
            var jsonResponse = String()
            if self.getResponseGet(myReviewsUrl, parameters: parameters, response: &jsonResponse) == true {
                
                response = JsonParser.parseMyReviews(jsonResponse)
                return true
                
            }
            
        }
        return false
        
    }
    
    static func getCompanies(term:String, location:String, radius:String, accessToken:String, inout response:[String]) -> Bool {
        
        if WebService.checkNetwork() == true {
            
            let parameters = ["access_token":accessToken, "radius":radius, "loc":location]
            
            var jsonResponse = String()
            if self.getResponseGet((companyUrl + "/" + term), parameters: parameters, response: &jsonResponse) == true {
                
                response = JsonParser.parseCompanies(jsonResponse)
                return true
                
            }
            
        }
        return false
        
    }
    
    static func uploadImage(accessToken:String, image:UIImage) -> String {
    
        var url = uploadImageUrl + "?access_token=" + accessToken
        url = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let request = ASIFormDataRequest(URL: NSURL(string:(baseUrl + url)))
        request.requestMethod = "POST"
        
        request.setData(UIImageJPEGRepresentation(image,0.1), withFileName:"file.png", andContentType: "image/jpeg", forKey: "file")
        request.startSynchronous()
        
        if request.responseStatusCode != 200 {
            
            return ""
            
        }
        
        return JsonParser.parseUploadImage(request.responseString())
        
    }
    
    static func newReview(accessToken:String, company:String, description:String, rating:Int, datetime:String, location:String, images:NSMutableArray) -> Bool {
        
        if WebService.checkNetwork() == true {
            
            let imagesIds:NSMutableArray = []
            for image in images {
            
                let imageId = self.uploadImage(accessToken, image: image as! UIImage)
                if imageId.characters.count == 0 {
                
                    Utility.showAlert("Problem", message: "Image upload failded. Try later")
                    return false
                    
                }
                imagesIds.addObject(imageId)
                
            }
            
            let parameters = ["company" : company, "description": description, "rating": rating, "images" : imagesIds, "datetime" : datetime, "location": location]
            var jsonResponse:String = String()
            
            let url = newReviewUrl + "?access_token=" + accessToken
            if WebService.getResponsePost(url, parameters: parameters, response: &jsonResponse) == true {
                
                return true
                
            }
            
        }
        return false
        
    }
    
    
    
    
}
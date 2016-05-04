//
//  LoginService.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 23/1/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit
import Alamofire

class LoginService: NSObject {

	static let LOGIN_URI : String = "/Login"
	static let LOGIN_METHOD : String = "POST"
	
	class func login(loginRequest : LoginRequest, success: (accessToken: String?) -> Void, failure: ((error: NSError) -> Void)) {
		
		let url = Constants.BASE_URL + LoginService.LOGIN_URI
		
		let request = NSMutableURLRequest(URL: NSURL(string: url)!)
		request.HTTPMethod = LoginService.LOGIN_METHOD
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.HTTPBody = (loginRequest.toJSONString() as NSString).dataUsingEncoding(NSUTF8StringEncoding)
		
		Alamofire.request(request).responseJSON {
			response in switch response.result {
				case .Success(let JSON):
					let response = JSON as! String
					success(accessToken: response)
				case .Failure(let error):
					failure(error: error)
			}
		}
	}
}

//
//  LoginRequest.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 23/1/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

class LoginRequest: NSObject {

	var username : String?
	var password : String?
	
	func toJSONString() -> String {
		let obj:[String:AnyObject] = [
			"Username": self.username == nil ? JSON.null : self.username!,
			"Password": self.password == nil ? JSON.null : self.password!
		]
		return JSON(obj).toString()
	}
}

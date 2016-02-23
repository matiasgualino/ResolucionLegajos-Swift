//
//  PostLegajoRequest.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 23/1/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

class PostLegajoRequest: NSObject {

	var token : String?
	var legajo : Legajo?
	
	func toJSONString() -> String {
		let obj:[String:AnyObject] = [
			"Token": self.token == nil ? JSON.null : self.token!,
			"Legajo": self.legajo == nil ? JSON.null : JSON.parse(self.legajo!.toJSONString()).mutableCopyOfTheObject()
		]
		return JSON(obj).toString()
	}
}

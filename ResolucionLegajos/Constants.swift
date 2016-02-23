//
//  Constants.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 23/1/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

class Constants: NSObject {

	static let PRODUCTION_BASE_URL = "http://servicios.tech-mind.com/apiLegajo/api"
	static let TEST_BASE_URL = "http://servicios.tech-mind.com/apiLegajo/api"
	static let BASE_URL = Constants.TEST_BASE_URL
	
	static let YELLOW_COLOR = UIColor(rgba: "#FFD300")
	static let DARK_COLOR = UIColor(rgba: "#272000")
	static let CLEAR_COLOR = UIColor(rgba: "#EBEBF0")
	
	private static let ACCESS_TOKEN_KEY : String = "ACCESS_TOKEN"
	
	class func getAccessToken() -> String? {
		return NSUserDefaults.standardUserDefaults().valueForKey(self.ACCESS_TOKEN_KEY) as? String
	}
	
	class func setAccessToken(accessToken: String) {
		NSUserDefaults.standardUserDefaults().setValue(accessToken, forKey: self.ACCESS_TOKEN_KEY)
		NSUserDefaults.standardUserDefaults().synchronize()
	}
	
	class func getDateAndHourFromString(string: String!) -> NSDate! {
		if string == nil {
			return nil
		}
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'"
		var dateArr = string.characters.split {$0 == "."}.map(String.init)
		let d = dateFormatter.dateFromString(dateArr[0])
		if d != nil {
			return d
		} else {
			dateFormatter.dateFormat = "dd/MM/yyyy"
			dateArr = string.characters.split {$0 == "."}.map(String.init)
			return dateFormatter.dateFromString(dateArr[0])
		}
	}
	
	class func getDateStringFromDate(date: NSDate) -> String! {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"
		return dateFormatter.stringFromDate(date)
	}

}

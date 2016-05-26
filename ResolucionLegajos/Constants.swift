//
//  Constants.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 23/1/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

class Constants: NSObject {

	static let PRODUCTION_BASE_URL = "http://preproduccion.tech-mind.com/apiLegajo/api"
	static let TEST_BASE_URL = "http://private-975e4-legajos.apiary-mock.com/apiLegajo/api"
	static let BASE_URL = Constants.TEST_BASE_URL
	
	static let YELLOW_COLOR = UIColor(rgba: "#FFD300")
	static let DARK_COLOR = UIColor(rgba: "#272000")
	static let CLEAR_COLOR = UIColor(rgba: "#EBEBF0")
	static let UNSOLVE_COLOR = UIColor(rgba: "#E41C1C")
	
	private static let ACCESS_TOKEN_KEY : String = "ACCESS_TOKEN"
	private static let USERNAME_KEY : String = "USERNAME"
	
	class func getAccessToken() -> String? {
		return NSUserDefaults.standardUserDefaults().valueForKey(self.ACCESS_TOKEN_KEY) as? String
	}
	
	class func setAccessToken(accessToken: String) {
		NSUserDefaults.standardUserDefaults().setValue(accessToken, forKey: self.ACCESS_TOKEN_KEY)
		NSUserDefaults.standardUserDefaults().synchronize()
	}
	
	class func getUsername() -> String? {
		return NSUserDefaults.standardUserDefaults().valueForKey(self.USERNAME_KEY) as? String
	}
	
	class func setUsername(username: String) {
		NSUserDefaults.standardUserDefaults().setValue(username, forKey: self.USERNAME_KEY)
		NSUserDefaults.standardUserDefaults().synchronize()
	}
	
	class func isUserLogged() -> Bool {
		return getUsername() != nil && getAccessToken() != nil
	}
	
	class func logout() {
		self.removeLegajoGuardado()
		NSUserDefaults.standardUserDefaults().removeObjectForKey(self.USERNAME_KEY)
		NSUserDefaults.standardUserDefaults().removeObjectForKey(self.ACCESS_TOKEN_KEY)
		NSUserDefaults.standardUserDefaults().synchronize()
	}
	
	class func setLegajoGuardado(legajo: Legajo) {
		NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(legajo), forKey: "LegajoGuardado")
		NSUserDefaults.standardUserDefaults().synchronize()
	}
	
	class func getLegajoGuardado() -> Legajo? {
		if let data = NSUserDefaults.standardUserDefaults().objectForKey("LegajoGuardado") as? NSData {
			let unarc = NSKeyedUnarchiver(forReadingWithData: data)
			return unarc.decodeObjectForKey("root") as? Legajo
		} else {
			return nil
		}
	}
	
	class func removeLegajoGuardado() {
		NSUserDefaults.standardUserDefaults().removeObjectForKey("LegajoGuardado")
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
	
	class func showResolucionDialog(ii : InfraccionInfo, navigationController: UINavigationController, callback: ((acta: Acta) -> Void)) -> UIAlertController {
		
		if ii.infraccion?.resolucion != nil {
			for sancion in ii.infraccion!.sanciones! {
				if sancion.codigo == ii.infraccion!.resolucion!.codigo {
					showResolucion(ii, sancion: sancion, callback: callback)
				}
			}
		}
		
		let resolucionAlertView = UIAlertController(title: "Resoluciones posibles", message: "", preferredStyle: .Alert)
		
		for sancion in ii.infraccion!.sanciones! {
			resolucionAlertView.addAction(UIAlertAction(title: sancion.descripcion!, style: .Default, handler: { (action) -> Void in
				showResolucion(ii, sancion: sancion, callback: callback)
			}))
		}
		resolucionAlertView.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))
		return resolucionAlertView
	}

	class func showResolucion(ii: InfraccionInfo, sancion: Sancion, callback: ((acta: Acta) -> Void)) {
		let alertView = CustomIOS8AlertView()
		
		let resolucionView = ResolucionView(frame: CGRect(x: 0, y: 0, width: 500, height: 320))
		resolucionView.setInfraccionInfo(ii, sancion: sancion, callback: { (acta) -> Void in
			alertView.close()
			callback(acta: acta)
		})
		
		alertView.buttonColor = Constants.YELLOW_COLOR
		alertView.containerView = resolucionView
		alertView.onButtonTouchUpInside = resolucionView.onButtonTouchUpInside()
		alertView.show(nil)
	}
	

}

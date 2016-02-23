//
//  ActaService.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 23/1/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit
import Alamofire

class ActaService: NSObject {

	static let FINALIZAR_RESOLUCION_URI : String = "/Legajo"
	static let FINALIZAR_RESOLUCION_METHOD : String = "POST"
	
	static let SUSPENDER_RESOLUCION_URI : String = "/Suspender"
	static let SUSPENDER_RESOLUCION_METHOD : String = "POST"
	
	static let GET_LEGAJO_URI : String = "/Legajo"
	static let GET_LEGAJO_METHOD : String = "GET"
	
	static let GET_ALL_LEGAJOS_URI : String = "/Legajos"
	static let GET_ALL_LEGAJOS_METHOD : String = "GET"
	
	class func finalizarResolucion(postLegajoRequest : PostLegajoRequest, success: (accessToken: String?) -> Void, failure: ((error: NSError) -> Void)) {
		
		let url = Constants.BASE_URL + ActaService.FINALIZAR_RESOLUCION_URI
		
		let request = NSMutableURLRequest(URL: NSURL(string: url)!)
		request.HTTPMethod = ActaService.FINALIZAR_RESOLUCION_METHOD
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.HTTPBody = (postLegajoRequest.toJSONString() as NSString).dataUsingEncoding(NSUTF8StringEncoding)
		
		Alamofire.request(request).responseJSON {
			response in switch response.result {
			case .Success(let JSON):
				let response = JSON as! NSDictionary
				let accessToken = response.objectForKey("access_token") as? String
				success(accessToken: accessToken)
			case .Failure(let error):
				failure(error: error)
			}
		}
	}
	
	class func suspenderResolucion(postLegajoRequest : PostLegajoRequest, success: (accessToken: String?) -> Void, failure: ((error: NSError) -> Void)) {
		
		let url = Constants.BASE_URL + ActaService.SUSPENDER_RESOLUCION_URI
		
		let request = NSMutableURLRequest(URL: NSURL(string: url)!)
		request.HTTPMethod = ActaService.SUSPENDER_RESOLUCION_METHOD
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.HTTPBody = (postLegajoRequest.toJSONString() as NSString).dataUsingEncoding(NSUTF8StringEncoding)
		
		Alamofire.request(request).responseJSON {
			response in switch response.result {
			case .Success(let JSON):
				let response = JSON as! NSDictionary
				let accessToken = response.objectForKey("access_token") as? String
				success(accessToken: accessToken)
			case .Failure(let error):
				failure(error: error)
			}
		}
	}
	
	class func getLegajo(accessToken: String, legajoId: String, success: (legajo: Legajo?) -> Void, failure: ((error: NSError) -> Void)) {
		
		let url = Constants.BASE_URL + ActaService.GET_LEGAJO_URI + "?token=" + accessToken + "&legajo=" + legajoId
		
		let request = NSMutableURLRequest(URL: NSURL(string: url)!)
		request.HTTPMethod = ActaService.GET_LEGAJO_METHOD
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")

		Alamofire.request(request).responseJSON {
			response in switch response.result {
			case .Success(let JSON):
				let response = JSON as? NSDictionary
				var legajo : Legajo? = nil
				if response != nil {
					legajo = Legajo.fromJSON(response!)
				}
				success(legajo: legajo)
			case .Failure(let error):
				failure(error: error)
			}
		}
	}
	
	class func getAllLegajos(accessToken: String, success: (legajos: [Legajo]?) -> Void, failure: ((error: NSError) -> Void)) {
		
		let url = Constants.BASE_URL + ActaService.GET_ALL_LEGAJOS_URI + "?token=" + accessToken
		
		let request = NSMutableURLRequest(URL: NSURL(string: url)!)
		request.HTTPMethod = ActaService.GET_ALL_LEGAJOS_METHOD
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")

		Alamofire.request(request).responseJSON {
			response in switch response.result {
			case .Success(let JSON):
				var legajos : [Legajo]? = nil
				let response = JSON as? NSArray
				if response != nil {
					legajos = [Legajo]()
					for resp in response! {
						let JSONDic = resp as? NSDictionary
						if JSONDic != nil {
							legajos!.append(Legajo.fromJSON(JSONDic!))
						}
					}
				}
				success(legajos: legajos)
			case .Failure(let error):
				failure(error: error)
			}
		}
	}
	
}

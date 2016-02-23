//
//  Acta.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 23/1/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

class Acta: NSObject {

	var numero : String?
	var descripcion : String?
	var ufcosto : Double?
	var importeminimo : Double?
	var imagen : String?
	var infracciones : [Infraccion]?
	
	class func fromJSON(json : NSDictionary) -> Acta {
		let acta : Acta = Acta()
		if json["numero"] != nil {
			acta.numero = JSON(json["numero"]!).asString
		}
		if json["descripcion"] != nil {
			acta.descripcion = JSON(json["descripcion"]!).asString
		}
		if json["ufcosto"] != nil {
			acta.ufcosto = JSON(json["ufcosto"]!).asDouble
		}
		if json["importeminimo"] != nil {
			acta.importeminimo = JSON(json["importeminimo"]!).asDouble
		}
		if json["imagen"] != nil {
			acta.imagen = JSON(json["imagen"]!).asString
		}
		var infracciones : [Infraccion] = [Infraccion]()
		if let infraccionesArray = json["infracciones"] as? NSArray {
			for i in 0..<infraccionesArray.count {
				if let infraccion = infraccionesArray[i] as? NSDictionary {
					infracciones.append(Infraccion.fromJSON(infraccion))
				}
			}
		}
		acta.infracciones = infracciones
		return acta
	}
	
	func toJSONString() -> String {
		var infraccionesArray : [AnyObject]? = nil
		if infracciones != nil {
			for infraccion in infracciones! {
				infraccionesArray?.append(JSON.parse(infraccion.toJSONString()).mutableCopyOfTheObject())
			}
		}
		let obj:[String:AnyObject] = [
			"numero": self.numero == nil ? JSON.null : self.numero!,
			"descripcion" : self.descripcion == nil ? JSON.null : self.descripcion!,
			"ufcosto" : self.ufcosto == nil ? JSON.null : self.ufcosto!,
			"importeminimo" : self.importeminimo == nil ? JSON.null : self.importeminimo!,
			"imagen" : self.imagen == nil ? JSON.null : self.imagen!,
			"infracciones" : infraccionesArray == nil ? JSON.null : infraccionesArray!
		]
		return JSON(obj).toString()
	}
	
}

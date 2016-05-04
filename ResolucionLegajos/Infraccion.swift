//
//  Infraccion.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 23/1/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

class Infraccion: NSObject, NSCopying {

	var codigo : String?
	var descripcion : String?
	var sanciones : [Sancion]?
	var resolucion : Resolucion?

	init(codigo: String?, descripcion: String?, sanciones: [Sancion]?, resolucion: Resolucion?) {
		self.codigo = codigo
		self.descripcion = descripcion
		self.sanciones = sanciones
		self.resolucion = resolucion
	}
	
	override init() {
		
	}
	
	class func fromJSON(json : NSDictionary) -> Infraccion {
		let infraccion : Infraccion = Infraccion()
		if json["codigo"] != nil {
			infraccion.codigo = JSON(json["codigo"]!).asString
		}
		if json["descripcion"] != nil {
			infraccion.descripcion = JSON(json["descripcion"]!).asString
		}
		if  let resolucion = json["resolucion"] as? NSDictionary {
			infraccion.resolucion = Resolucion.fromJSON(resolucion)
		}
		var saciones : [Sancion] = [Sancion]()
		if let sacionesArray = json["sanciones"] as? NSArray {
			for i in 0..<sacionesArray.count {
				if let sacion = sacionesArray[i] as? NSDictionary {
					saciones.append(Sancion.fromJSON(sacion))
				}
			}
		}
		infraccion.sanciones = saciones
		return infraccion
	}
	
	func toJSONString() -> String {
		var sancionesArray : [AnyObject]? = nil
		if sanciones != nil {
			for sancion in sanciones! {
				sancionesArray?.append(JSON.parse(sancion.toJSONString()).mutableCopyOfTheObject())
			}
		}
		let obj:[String:AnyObject] = [
			"codigo": self.codigo == nil ? JSON.null : self.codigo!,
			"descripcion" : self.descripcion == nil ? JSON.null : self.descripcion!,
			"resolucion" : self.resolucion == nil ? JSON.null : JSON.parse(resolucion!.toJSONString()).mutableCopyOfTheObject(),
			"sanciones" : sancionesArray == nil ? JSON.null : sancionesArray!
		]
		return JSON(obj).toString()
	}
	
	func copyWithZone(zone: NSZone) -> AnyObject {
		let copy = Infraccion(codigo: codigo, descripcion: descripcion, sanciones: sanciones, resolucion: resolucion)
		return copy
	}
	
}

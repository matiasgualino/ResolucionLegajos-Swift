//
//  Sancion.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 23/1/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

class Sancion: NSObject, NSCopying {

	var codigo : String?
	var descripcion : String?
	var ufmin : Double?
	var ufmax : Double?
	var puntosmin : Int?
	var puntosmax : Int?
	
	init(codigo: String?, descripcion: String?, ufmin: Double?, ufmax: Double?, puntosmin: Int?, puntosmax: Int?) {
		self.codigo = codigo
		self.descripcion = descripcion
		self.ufmin = ufmin
		self.ufmax = ufmax
		self.puntosmin = puntosmin
		self.puntosmax = puntosmax
	}
	
	override init() {
		
	}
	
	required init(coder aDecoder: NSCoder) {
		if let codigo = aDecoder.decodeObjectForKey("SancionCodigo") as? String {
			self.codigo = codigo
		}
		if let descripcion = aDecoder.decodeObjectForKey("SancionDescripcion") as? String {
			self.descripcion = descripcion
		}
		if let ufmin = aDecoder.decodeObjectForKey("SancionUfmin") as? Double {
			self.ufmin = ufmin
		}
		if let ufmax = aDecoder.decodeObjectForKey("SancionUfmax") as? Double {
			self.ufmax = ufmax
		}
		if let puntosmin = aDecoder.decodeObjectForKey("SancionPuntosmin") as? Int {
			self.puntosmin = puntosmin
		}
		if let puntosmax = aDecoder.decodeObjectForKey("SancionPuntosmax") as? Int {
			self.puntosmax = puntosmax
		}
	}
	
	func encodeWithCoder(aCoder: NSCoder) {
		if let codigo = self.codigo {
			aCoder.encodeObject(codigo, forKey: "SancionCodigo")
		}
		if let descripcion = self.descripcion {
			aCoder.encodeObject(descripcion, forKey: "SancionDescripcion")
		}
		if let ufmin = self.ufmin {
			aCoder.encodeObject(ufmin, forKey: "SancionUfmin")
		}
		if let ufmax = self.ufmax {
			aCoder.encodeObject(ufmax, forKey: "SancionUfmax")
		}
		if let puntosmin = self.puntosmin {
			aCoder.encodeObject(puntosmin, forKey: "SancionPuntosmin")
		}
		if let puntosmax = self.puntosmax {
			aCoder.encodeObject(puntosmax, forKey: "SancionPuntosmax")
		}
	}
	
	class func fromJSON(json : NSDictionary) -> Sancion {
		let sancion : Sancion = Sancion()
		if json["codigo"] != nil {
			sancion.codigo = JSON(json["codigo"]!).asString
		}
		if json["descripcion"] != nil {
			sancion.descripcion = JSON(json["descripcion"]!).asString
		}
		if json["ufmin"] != nil {
			sancion.ufmin = JSON(json["ufmin"]!).asDouble
		}
		if json["ufmax"] != nil {
			sancion.ufmax = JSON(json["ufmax"]!).asDouble
		}
		if json["puntosmin"] != nil {
			sancion.puntosmin = JSON(json["puntosmin"]!).asInt
		}
		if json["puntosmax"] != nil {
			sancion.puntosmax = JSON(json["puntosmax"]!).asInt
		}
		return sancion
	}
	
	func toJSONString() -> String {
		let obj:[String:AnyObject] = [
			"codigo": self.codigo == nil ? JSON.null : self.codigo!,
			"descripcion" : self.descripcion == nil ? JSON.null : self.descripcion!,
			"ufmin" : self.ufmin == nil ? JSON.null : self.ufmin!,
			"ufmax" : self.ufmax == nil ? JSON.null : self.ufmax!,
			"puntosmin" : self.puntosmin == nil ? JSON.null : self.puntosmin!,
			"puntosmax" : self.puntosmax == nil ? JSON.null : self.puntosmax!
		]
		return JSON(obj).toString()
	}
	
	func copyWithZone(zone: NSZone) -> AnyObject {
		let copy = Sancion(codigo: codigo, descripcion: descripcion, ufmin: ufmin, ufmax: ufmax, puntosmin: puntosmin, puntosmax: puntosmax)
		return copy
	}
}

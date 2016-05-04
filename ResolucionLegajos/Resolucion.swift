//
//  Resolucion.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 23/1/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

class Resolucion: NSObject, NSCopying {

	var codigo : String?
	var uf : Double?
	var importe : Double?
	var nota : String?
	var puntos : Int?
	
	init(codigo: String?, uf: Double?, importe: Double?, nota: String?, puntos: Int?) {
		self.codigo = codigo
		self.uf = uf
		self.importe = importe
		self.nota = nota
		self.puntos = puntos
	}
	
	override init() {
		
	}
	
	class func fromJSON(json : NSDictionary) -> Resolucion {
		let resolucion : Resolucion = Resolucion()
		if json["codigo"] != nil {
			resolucion.codigo = JSON(json["codigo"]!).asString
		}
		if json["nota"] != nil {
			resolucion.nota = JSON(json["nota"]!).asString
		}
		if json["uf"] != nil {
			resolucion.uf = JSON(json["uf"]!).asDouble
		}
		if json["importe"] != nil {
			resolucion.importe = JSON(json["importe"]!).asDouble
		}
		if json["puntos"] != nil {
			resolucion.puntos = JSON(json["puntos"]!).asInt
		}
		return resolucion
	}
	
	func toJSONString() -> String {
		let obj:[String:AnyObject] = [
			"codigo": self.codigo == nil ? JSON.null : self.codigo!,
			"uf" : self.uf == nil ? JSON.null : self.uf!,
			"importe" : self.importe == nil ? JSON.null : self.importe!,
			"nota" : self.nota == nil ? JSON.null : self.nota!,
			"puntos" : self.puntos == nil ? JSON.null : self.puntos!
		]
		return JSON(obj).toString()
	}
	
	func copyWithZone(zone: NSZone) -> AnyObject {
		let copy = Resolucion(codigo: codigo, uf: uf, importe: importe, nota: nota, puntos: puntos)
		return copy
	}
}

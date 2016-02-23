//
//  Resolucion.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 23/1/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

class Resolucion: NSObject {

	var codigo : String?
	var uf : Double?
	var importe : Double?
	var nota : String?
	var puntos : Int?
	
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
}

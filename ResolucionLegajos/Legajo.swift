//
//  Legajo.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 23/1/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

class Legajo: NSObject, NSCopying {

	var numero : String?
	var fecha : String?
	var dominio : String?
	var nombrecompleto : String?
	var du : String?
	var observaciones : String?
	var id : String?
	var actas : [Acta]?
	
	init(numero: String?, fecha: String?, dominio: String?, nombrecompleto: String?, du: String?, observaciones: String?, id: String?, actas: [Acta]?) {
		self.numero = numero
		self.fecha = fecha
		self.dominio = dominio
		self.nombrecompleto = nombrecompleto
		self.du = du
		self.observaciones = observaciones
		self.id = id
		self.actas = actas
	}
	
	override init() {
		
	}
	
	required init(coder aDecoder: NSCoder) {
		if let numero = aDecoder.decodeObjectForKey("LegajoNumero") as? String {
			self.numero = numero
		}
		if let fecha = aDecoder.decodeObjectForKey("LegajoFecha") as? String {
			self.fecha = fecha
		}
		if let dominio = aDecoder.decodeObjectForKey("LegajoDominio") as? String {
			self.dominio = dominio
		}
		if let nombrecompleto = aDecoder.decodeObjectForKey("LegajoNombrecompleto") as? String {
			self.nombrecompleto = nombrecompleto
		}
		if let du = aDecoder.decodeObjectForKey("LegajoDU") as? String {
			self.du = du
		}
		if let observaciones = aDecoder.decodeObjectForKey("LegajoObservaciones") as? String {
			self.observaciones = observaciones
		}
		if let id = aDecoder.decodeObjectForKey("LegajoId") as? String {
			self.id = id
		}
		if let cantidadActas = aDecoder.decodeObjectForKey("LegajoActasCantidad") as? Int {
			self.actas = [Acta]()
			for i in 0...cantidadActas {
				let acta = aDecoder.decodeObjectForKey("LegajoActa" + String(format: "%d", i)) as? Acta
				if acta != nil {
					self.actas!.append(acta!)
				}
			}
		}
	}
	
	func encodeWithCoder(aCoder: NSCoder) {
		if let numero = self.numero {
			aCoder.encodeObject(numero, forKey: "LegajoNumero")
		}
		if let fecha = self.fecha {
			aCoder.encodeObject(fecha, forKey: "LegajoFecha")
		}
		if let dominio = self.dominio {
			aCoder.encodeObject(dominio, forKey: "LegajoDominio")
		}
		if let nombrecompleto = self.nombrecompleto {
			aCoder.encodeObject(nombrecompleto, forKey: "LegajoNombrecompleto")
		}
		if let du = self.du {
			aCoder.encodeObject(du, forKey: "LegajoDU")
		}
		if let observaciones = self.observaciones {
			aCoder.encodeObject(observaciones, forKey: "LegajoObservaciones")
		}
		if let id = self.id {
			aCoder.encodeObject(id, forKey: "LegajoId")
		}
		if let actas = self.actas {
			var i = 0
			aCoder.encodeObject(actas.count, forKey: "LegajoActasCantidad")
			for acta in actas {
				aCoder.encodeObject(acta, forKey: "LegajoActa" + String(format: "%d", i))
				i = i + 1
			}
		}
	}

	class func fromJSON(json : NSDictionary) -> Legajo {
		let legajo : Legajo = Legajo()
		if json["numero"] != nil {
			legajo.numero = JSON(json["numero"]!).asString
		}
		if json["fecha"] != nil {
			let dateString : String? = JSON(json["fecha"]!).asString
			let date : NSDate! = Constants.getDateAndHourFromString(dateString)
			legajo.fecha = Constants.getDateStringFromDate(date)
		}
		if json["dominio"] != nil {
			legajo.dominio = JSON(json["dominio"]!).asString
		}
		if json["nombrecompleto"] != nil {
			legajo.nombrecompleto = JSON(json["nombrecompleto"]!).asString
		}
		if json["DU"] != nil {
			legajo.du = JSON(json["DU"]!).asString
		}
		if json["id"] != nil {
			let st = JSON(json["id"]!).asString
			if st != nil {
				legajo.id =	st
			} else {
				let intS = JSON(json["id"]!).asInt
				if intS != nil {
					legajo.id =	String(format:"%d", intS!)
				}
			}
		}
		var actas : [Acta] = [Acta]()
		if let actasArray = json["actas"] as? NSArray {
			for i in 0..<actasArray.count {
				if let acta = actasArray[i] as? NSDictionary {
					actas.append(Acta.fromJSON(acta))
				}
			}
		}
		legajo.actas = actas
		return legajo
	}
	
	func toJSONString() -> String {
		var actasArray : [AnyObject]? = nil
		if actas != nil {
			actasArray = [AnyObject]()
			for acta in actas! {
				actasArray!.append(JSON.parse(acta.toJSONString()).mutableCopyOfTheObject())
			}
		}
		let obj:[String:AnyObject] = [
			"numero": self.numero == nil ? JSON.null : self.numero!,
			"fecha": self.fecha == nil ? JSON.null : self.fecha!,
			"dominio": self.dominio == nil ? JSON.null : self.dominio!,
			"nombrecompleto" : self.nombrecompleto == nil ? JSON.null : self.nombrecompleto!,
			"DU" : self.du == nil ? JSON.null : self.du!,
			"id" : self.id == nil ? JSON.null : self.id!,
			"observaciones" : self.observaciones == nil ? JSON.null : self.observaciones!,
			"actas" : actasArray == nil ? JSON.null : actasArray!
		]
		return JSON(obj).toString()
	}
	
	func copyWithZone(zone: NSZone) -> AnyObject {
		let copy = Legajo(numero: numero, fecha: fecha, dominio: dominio, nombrecompleto: nombrecompleto, du: du, observaciones: observaciones, id: id, actas: actas)
		return copy
	}
	
}

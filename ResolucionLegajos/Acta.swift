//
//  Acta.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 23/1/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

class Acta: NSObject, NSCopying {

	var numero : String?
	var descripcion : String?
	var ufcosto : Double?
	var importeminimo : Double?
	var imagen : String?
	var infracciones : [Infraccion]?
	
	init(numero: String?, descripcion: String?, ufcosto: Double?, importeminimo: Double?, imagen: String?, infracciones: [Infraccion]?) {
		self.numero = numero
		self.descripcion = descripcion
		self.ufcosto = ufcosto
		self.importeminimo = importeminimo
		self.imagen = imagen
		self.infracciones = infracciones
	}
	
	override init() {
		
	}
	
	required init(coder aDecoder: NSCoder) {
		if let numero = aDecoder.decodeObjectForKey("ActaNumero") as? String {
			self.numero = numero
		}
		if let descripcion = aDecoder.decodeObjectForKey("ActaDescripcion") as? String {
			self.descripcion = descripcion
		}
		if let ufcosto = aDecoder.decodeObjectForKey("ActaUfcosto") as? Double {
			self.ufcosto = ufcosto
		}
		if let importeminimo = aDecoder.decodeObjectForKey("ActaImporteminimo") as? Double {
			self.importeminimo = importeminimo
		}
		if let imagen = aDecoder.decodeObjectForKey("ActaImagen") as? String {
			self.imagen = imagen
		}
		if let cantidadInfracciones = aDecoder.decodeObjectForKey("ActaInfraccionesCantidad") as? Int {
			self.infracciones = [Infraccion]()
			for i in 0...cantidadInfracciones {
				let infraccion = aDecoder.decodeObjectForKey("ActaInfraccion" + String(format: "%d", i)) as? Infraccion
				if infraccion != nil {
					self.infracciones!.append(infraccion!)
				}
			}
		}
	}
	
	func encodeWithCoder(aCoder: NSCoder) {
		if let numero = self.numero {
			aCoder.encodeObject(numero, forKey: "ActaNumero")
		}
		if let descripcion = self.descripcion {
			aCoder.encodeObject(descripcion, forKey: "ActaDescripcion")
		}
		if let ufcosto = self.ufcosto {
			aCoder.encodeObject(ufcosto, forKey: "ActaUfcosto")
		}
		if let importeminimo = self.importeminimo {
			aCoder.encodeObject(importeminimo, forKey: "ActaImporteminimo")
		}
		if let imagen = self.imagen {
			aCoder.encodeObject(imagen, forKey: "ActaImagen")
		}
		if let infracciones = self.infracciones {
			var i = 0
			aCoder.encodeObject(infracciones.count, forKey: "ActaInfraccionesCantidad")
			for infraccion in infracciones {
				aCoder.encodeObject(infraccion, forKey: "ActaInfraccion" + String(format: "%d", i))
				i = i + 1
			}
		}
	}
	
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
			infraccionesArray = [AnyObject]()
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
	
	func copyWithZone(zone: NSZone) -> AnyObject {
		let copy = Acta(numero: numero, descripcion: descripcion, ufcosto: ufcosto, importeminimo: importeminimo, imagen: imagen, infracciones: infracciones)
		return copy
	}
	
}

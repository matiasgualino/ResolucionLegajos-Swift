//
//  LegajoViewController.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 23/1/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

class LegajoViewController: MasterViewController, UITableViewDataSource, UITableViewDelegate, InfraccionTableViewCellDelegate {
	
	var infracciones : Array<InfraccionInfo>!
	@IBOutlet weak private var infraccionesTableView : UITableView!

	@IBOutlet weak var lblTitle: UILabel!
	@IBOutlet weak var lblDominio: UILabel!
	@IBOutlet weak var lblFecha: UILabel!
	@IBOutlet weak var lblCantidadActas: UILabel!
	@IBOutlet weak var lblCantidadInfracciones: UILabel!
	@IBOutlet weak var lblPuntosResueltos: UILabel!
	@IBOutlet weak var lblImporteResuelto: UILabel!
	@IBOutlet weak var lblInfraccionesResueltas: UILabel!
	@IBOutlet weak var lblCaratula: UILabel!
	@IBOutlet weak var lblFinalizar: UILabel!
	
	var legajo : Legajo?
	var legajoId : String?
	
	init(legajoId: String?) {
		super.init(nibName: "LegajoViewController", bundle: nil)
		self.legajoId = legajoId
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.lblFinalizar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LegajoViewController.finalizarLegajo)))
		self.lblFinalizar.userInteractionEnabled = true

		self.lblCaratula.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LegajoViewController.caratula)))
		self.lblCaratula.userInteractionEnabled = true
		
		let infraccionNib = UINib(nibName: "InfraccionTableViewCell", bundle: nil)
		self.infraccionesTableView.registerNib(infraccionNib, forCellReuseIdentifier: "infraccionCell")
		let infraccionHeaderNib = UINib(nibName: "InfraccionesHeaderTableViewCell", bundle: nil)
		self.infraccionesTableView.registerNib(infraccionHeaderNib, forCellReuseIdentifier: "infraccionHeaderCell")
		
		self.infraccionesTableView.delegate = self
		self.infraccionesTableView.dataSource = self
		
		self.infraccionesTableView.backgroundView = UIView()
		self.infraccionesTableView.backgroundView?.backgroundColor = Constants.CLEAR_COLOR
		
		self.infraccionesTableView.backgroundColor = Constants.CLEAR_COLOR
		
		self.showLoadingMessage()
		let accessToken = Constants.getAccessToken()
		if legajoId != nil && accessToken != nil {
			ActaService.getLegajo(accessToken!, legajoId: legajoId!, success: { (legajo) -> Void in
				self.legajo = legajo
				self.cargarLegajo()
				self.hideLoadingMessage()
				}) { (error) -> Void in
					
			}
		}
    }

	func cargarLegajo() {
		var cantidadInfracciones = 0
		var puntosResueltos = 0
		var importeResuelto = 0.0
		var infraccionesResueltas = 0
		
		if legajo != nil {
			if legajo!.numero != nil && legajo!.nombrecompleto != nil {
				self.lblTitle.text = "Nro: " + legajo!.numero! + " - " + legajo!.nombrecompleto!
			}
			if legajo!.dominio != nil {
				self.lblDominio.text = legajo!.dominio
			}
			if legajo!.fecha != nil {
				self.lblFecha.text = legajo!.fecha
			}
			if legajo!.actas != nil {
				self.lblCantidadActas.text = String(format: "%d", legajo!.actas!.count)
				infracciones = [InfraccionInfo]()
				for acta in legajo!.actas! {
					if acta.infracciones != nil {
						cantidadInfracciones += acta.infracciones!.count
						for infraccion in acta.infracciones! {
							infracciones!.append(InfraccionInfo(infraccion: infraccion, acta: acta))
							
							if infraccion.resolucion != nil {
								if infraccion.resolucion!.puntos != nil {
									puntosResueltos += infraccion.resolucion!.puntos!
								}
								if infraccion.resolucion!.importe != nil {
									importeResuelto += infraccion.resolucion!.importe!
								}
								infraccionesResueltas += 1
							}
						}
					}
				}
			} else {
				self.lblCantidadActas.text = "0"
			}
			self.lblCantidadInfracciones.text = String(format: "%d", cantidadInfracciones)
			self.lblInfraccionesResueltas.text = String(format: "%d", infraccionesResueltas)
			if cantidadInfracciones == infraccionesResueltas {
				self.lblFinalizar.text = "FINALIZAR"
				self.lblInfraccionesResueltas.textColor = UIColor.greenColor()
			} else {
				self.lblFinalizar.text = "SUSPENDER"
				self.lblInfraccionesResueltas.textColor = UIColor.redColor()
			}
			self.lblImporteResuelto.text = String(format: "%.2f", importeResuelto)
			self.lblPuntosResueltos.text = String(format: "%d", puntosResueltos)
			if puntosResueltos >= 10 {
				self.lblPuntosResueltos.text = "10"
				self.lblPuntosResueltos.textColor = UIColor.redColor()
			}
		}
		self.infraccionesTableView.reloadData()
	}
	
	func finalizarLegajo() {
		if self.lblFinalizar.text == "FINALIZAR" {
			self.navigationController?.pushViewController(FinishViewController(legajo: legajo!), animated: true)
		} else {
			let postLegajoRequest = PostLegajoRequest()
			postLegajoRequest.legajo = self.legajo
			postLegajoRequest.token = Constants.getAccessToken()
			ActaService.suspenderResolucion(postLegajoRequest, success: { () -> Void in
				let suspensionAlertView = UIAlertController(title: "INFORMACION", message: "Se ha suspendido el legajo exitosamente! Será redireccionado al inicio.", preferredStyle: .Alert)
				suspensionAlertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
					
				}))
				self.presentViewController(suspensionAlertView, animated: true, completion: nil)
				}, failure: { (error) -> Void in
					
			})
		}
	}
	
	
	func caratula() {
		self.navigationController?.pushViewController(CaratulaViewController(legajoId: self.legajoId), animated: true)
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return infracciones == nil ? 0 : infracciones.count + 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if section == 0 {
			return nil
		} else {
			let v = UIView()
			v.backgroundColor = UIColor.clearColor()
			return v
		}
	}
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 0 {
			return 0
		} else {
			return 10
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let infraccionHeaderCell : InfraccionesHeaderTableViewCell = self.infraccionesTableView.dequeueReusableCellWithIdentifier("infraccionHeaderCell") as! InfraccionesHeaderTableViewCell
			infraccionHeaderCell.backgroundColor = Constants.CLEAR_COLOR
			return infraccionHeaderCell
		} else {
			let infraccionCell : InfraccionTableViewCell = self.infraccionesTableView.dequeueReusableCellWithIdentifier("infraccionCell") as! InfraccionTableViewCell
			
			let infraccionInfo : InfraccionInfo = infracciones[indexPath.section - 1]
			infraccionCell._setInfraccionInfo(infraccionInfo)
			infraccionCell.delegate = self
			infraccionCell.backgroundColor = UIColor.whiteColor()
			return infraccionCell
		}
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.section == 0 {
			return 35
		} else {
			return 215
		}
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let infraccionSelected : InfraccionInfo = self.infracciones![indexPath.row]
		self.navigationController?.pushViewController(ActaViewController(legajo: legajo!, infraccion: infraccionSelected), animated: true)
	}
	
	func resolverClicked(ii: InfraccionInfo) {
		let vc = Constants.showResolucionDialog(ii, navigationController: self.navigationController!, callback: {(acta) -> Void in
			
			if self.legajo != nil && self.legajo!.actas != nil && ii.acta != nil {
				let index = self.legajo!.actas!.indexOf(ii.acta!)
				if index != nil {
					self.legajo!.actas!.removeAtIndex(index!)
					self.legajo!.actas!.insert(acta, atIndex: index!)
					self.cargarLegajo()
				}
			}
			
		})
		self.presentViewController(vc, animated: true, completion: nil)
	}
	
	
	func visualizarClicked(ii: InfraccionInfo) {
		self.navigationController?.pushViewController(ActaViewController(legajo: legajo!, infraccion: ii), animated: true)
	}
	
}

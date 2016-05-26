//
//  FinishViewController.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 23/1/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

class FinishViewController: MasterViewController, UITableViewDataSource, UITableViewDelegate, ResumenTableViewCellDelegate {

	var legajo : Legajo
	
	var infraccionInfoList : [InfraccionInfo]?
	
	@IBOutlet weak var lblLegajoTitle: UILabel!
	@IBOutlet weak var lblPuntosResueltos: UILabel!
	@IBOutlet weak var lblImporteResuelto: UILabel!
	@IBOutlet weak var lblUFResueltas: UILabel!
	
	@IBOutlet weak var lblConfirmar: UILabel!

	@IBOutlet weak var resumenTableView : UITableView!
	
	init(legajo: Legajo) {
		self.legajo = legajo
		super.init(nibName: "FinishViewController", bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		let resumenNib = UINib(nibName: "ResumenTableViewCell", bundle: nil)
		self.resumenTableView.registerNib(resumenNib, forCellReuseIdentifier: "resumenCell")
		let resumenHeaderNib = UINib(nibName: "ResumenHeaderTableViewCell", bundle: nil)
		self.resumenTableView.registerNib(resumenHeaderNib, forCellReuseIdentifier: "resumenHeaderCell")
		
		self.resumenTableView.delegate = self
		self.resumenTableView.dataSource = self
		
		self.resumenTableView.backgroundView = UIView()
		self.resumenTableView.backgroundView?.backgroundColor = Constants.CLEAR_COLOR
		
		self.resumenTableView.backgroundColor = Constants.CLEAR_COLOR

		self.lblConfirmar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FinishViewController.finish)))
		self.lblConfirmar.userInteractionEnabled = true
		
        loadResumen()
    }
	
	func loadResumen() {
		
		var importeRes : Double = 0.0
		var puntosRes : Int = 0
		var ufRes : Double = 0.0
		var puntosColor : UIColor = UIColor.whiteColor()
		for acta in legajo.actas! {
			for infraccion in acta.infracciones! {
				if infraccion.resolucion != nil {
					if infraccion.resolucion!.importe != nil {
						importeRes = importeRes + infraccion.resolucion!.importe!
					}
					if infraccion.resolucion!.puntos != nil {
						puntosRes = puntosRes + infraccion.resolucion!.puntos!
					}
					if infraccion.resolucion!.uf != nil {
						ufRes = ufRes + infraccion.resolucion!.uf!
					}
				}
			}
		}
		
		self.lblLegajoTitle.text = "Nro: " + legajo.numero! + " - " + legajo.nombrecompleto!
		if puntosRes >= 10 {
			puntosRes = 10
			puntosColor = Constants.UNSOLVE_COLOR
		}
		lblPuntosResueltos.text = String(format: "%d", puntosRes)
		lblPuntosResueltos.textColor = puntosColor
		
		lblImporteResuelto.text = String(format: "%.2f", importeRes)
		lblUFResueltas.text = String(format: "%.2f", ufRes)
		
		infraccionInfoList = [InfraccionInfo]()
		
		for acta in legajo.actas! {
			if acta.infracciones != nil {
				for infraccion in acta.infracciones! {
					infraccionInfoList!.append(InfraccionInfo(infraccion: infraccion, acta: acta))
				}
			}
		}
		
		self.resumenTableView.reloadData()

	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.infraccionInfoList == nil ? 0 : self.infraccionInfoList!.count + 1
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
			let infraccionHeaderCell : ResumenHeaderTableViewCell = self.resumenTableView.dequeueReusableCellWithIdentifier("resumenHeaderCell") as! ResumenHeaderTableViewCell
			infraccionHeaderCell.backgroundColor = Constants.CLEAR_COLOR
			return infraccionHeaderCell
		} else {
			let resumenCell : ResumenTableViewCell = self.resumenTableView.dequeueReusableCellWithIdentifier("resumenCell") as! ResumenTableViewCell
			
			let infraccionInfo : InfraccionInfo = self.infraccionInfoList![indexPath.section - 1]
			resumenCell._setInfraccionInfo(infraccionInfo)
			resumenCell.delegate = self
			resumenCell.backgroundColor = UIColor.whiteColor()
			return resumenCell
		}
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.section == 0 {
			return 35
		} else {
			return 280
		}
	}
	
		
	func modificarResolucion(ii: InfraccionInfo) {
		let vc = Constants.showResolucionDialog(ii, navigationController: self.navigationController!, callback: {(acta) -> Void in
			
			if self.legajo.actas != nil && ii.acta != nil {
				let index = self.legajo.actas!.indexOf(ii.acta!)
				if index != nil {
					self.legajo.actas!.removeAtIndex(index!)
					self.legajo.actas!.insert(acta, atIndex: index!)
					Constants.setLegajoGuardado(self.legajo)
					self.loadResumen()
				}
			}
			
		})
		self.presentViewController(vc, animated: true, completion: nil)
	}
	
	func finish() {
		let postLegajoRequest = PostLegajoRequest()
		postLegajoRequest.legajo = self.legajo
		postLegajoRequest.token = Constants.getAccessToken()
		self.showLoadingMessage()
		ActaService.finalizarResolucion(postLegajoRequest, success: { () -> Void in
			self.hideLoadingMessage()
			let finalizarAlertView = UIAlertController(title: "INFORMACION", message: "Se ha cerrado el legajo exitosamente! Será redireccionado al inicio.", preferredStyle: .Alert)
			finalizarAlertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
				Constants.removeLegajoGuardado()
				self.navigationController?.pushViewController(MainViewController(), animated: true)
			}))
			self.presentViewController(finalizarAlertView, animated: true, completion: nil)
			}, failure: { (error) -> Void in
				
		})
	}
}

//
//  LegajoView.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 5/3/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

class LegajoView: UIView {
	@IBOutlet var view:UIView!
	
	@IBOutlet weak var lblNombreCompleto: UILabel!
	@IBOutlet weak var lblFecha: UILabel!
	@IBOutlet weak var lblDU: UILabel!
	@IBOutlet weak var lblDominio: UILabel!
	@IBOutlet weak var lblNumero: UILabel!
	@IBOutlet weak var lblActaNumero: UILabel!
	@IBOutlet weak var lblImporteMinimo: UILabel!
	@IBOutlet weak var lblActaDescripcion: UILabel!
	@IBOutlet weak var lblInfraccionDescripcion: UILabel!
	@IBOutlet weak var lblInfraccionCodigo: UILabel!

	@IBOutlet weak var btnResolver: UIButton!
	
	var legajo : Legajo?
	var infraccionInfo : InfraccionInfo?
	
	var resolverDelegate : (() -> Void)?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		NSBundle.mainBundle().loadNibNamed("LegajoView", owner: self, options: nil)
		self.view.backgroundColor = UIColor.clearColor()
		self.view.frame = UIScreen.mainScreen().bounds
		self.view.userInteractionEnabled = true
		
		self.addSubview(self.view)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func resolver() {
		self.resolverDelegate?()
	}
	
	func loadData(legajo: Legajo, ii: InfraccionInfo) {

		self.btnResolver.addTarget(self, action: #selector(LegajoView.resolver), forControlEvents: .TouchUpInside)
		
		self.legajo = legajo
		self.lblNombreCompleto.text = self.legajo!.nombrecompleto
		self.lblFecha.text = self.legajo!.fecha
		self.lblDU.text = self.legajo!.du
		self.lblDominio.text = self.legajo!.dominio
		self.lblNumero.text = self.legajo!.numero
		
		self.infraccionInfo = ii
		self.lblActaNumero.text = self.infraccionInfo!.acta!.numero
		self.lblActaDescripcion.text = self.infraccionInfo!.acta!.descripcion
		self.lblImporteMinimo.text = String(format: "%.2f", self.infraccionInfo!.acta!.importeminimo!)
		
		self.lblInfraccionCodigo.text = self.infraccionInfo!.infraccion!.codigo
		self.lblInfraccionDescripcion.text = self.infraccionInfo!.infraccion!.descripcion
	}
}

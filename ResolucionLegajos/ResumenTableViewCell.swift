//
//  ResumenTableViewCell.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 4/5/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

class ResumenTableViewCell: CardTableViewCell {

	var delegate : ResumenTableViewCellDelegate?
	var infraccionInfo : InfraccionInfo?
	
	@IBOutlet weak var lblTitle: UILabel!
	@IBOutlet weak var lblActa: UILabel!
	@IBOutlet weak var lblResolucion: UILabel!
	@IBOutlet weak var lblNota: UILabel!
	@IBOutlet weak var lblPuntos: UILabel!
	@IBOutlet weak var lblImporte: UILabel!
	@IBOutlet weak var lblUnidadesFijas: UILabel!
	@IBOutlet weak var lblModificar: UILabel!
	
	func _setInfraccionInfo(ii: InfraccionInfo) {
		self.infraccionInfo = ii
		
		self.lblModificar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ResumenTableViewCell.modificarResolucion)))
		self.lblModificar.userInteractionEnabled = true
		
		lblTitle.text = ii.infraccion!.descripcion! + " - " + ii.infraccion!.codigo!
		lblActa.text = ii.acta!.numero! + " - " + ii.acta!.descripcion!
		
		var nombreResolucion = ""
		for sancion in ii.infraccion!.sanciones! {
			if sancion.codigo == ii.infraccion!.resolucion!.codigo {
				nombreResolucion = sancion.descripcion!
			}
		}
		
		lblResolucion.text = nombreResolucion + " (" + ii.infraccion!.resolucion!.codigo! + ")"
		lblNota.text = ii.infraccion!.resolucion!.nota != nil ? ii.infraccion!.resolucion!.nota : "Sin nota"
		
		lblPuntos.text = String(format: "%d", ii.infraccion!.resolucion!.puntos!)
		
		if ii.infraccion!.resolucion!.puntos >= 10 {
			self.lblPuntos.textColor = UIColor.redColor()
		}
		
		lblUnidadesFijas.text = String(format: "%.2f", ii.infraccion!.resolucion!.uf!) + " (Costo UF: $" + String(format: "%.2f", ii.acta!.ufcosto!) + "). Total: $" + String(format: "%.2f", ii.acta!.ufcosto! * ii.infraccion!.resolucion!.uf!)
		
		lblImporte.text = "$" + String(format: "%.2f", ii.infraccion!.resolucion!.importe!)
		
	}
	
	func modificarResolucion() {
		self.delegate?.modificarResolucion(self.infraccionInfo!)
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}

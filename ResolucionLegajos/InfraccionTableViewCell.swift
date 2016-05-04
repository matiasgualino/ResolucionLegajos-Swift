//
//  InfraccionTableViewCell.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 21/2/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

class InfraccionTableViewCell: CardTableViewCell {

	@IBOutlet weak var lblTitle: UILabel!
	@IBOutlet weak var lblActa: UILabel!
	@IBOutlet weak var lblImporteMinimo: UILabel!
	@IBOutlet weak var lblCostoUF: UILabel!
	@IBOutlet weak var lblCodigo: UILabel!
	
	@IBOutlet weak var lblVisualizar: UILabel!
	@IBOutlet weak var lblResolver: UILabel!
	
	@IBOutlet weak var imgState: UIImageView!
	
	var delegate : InfraccionTableViewCellDelegate?
	var infraccionInfo : InfraccionInfo?
	
	func _setInfraccionInfo(ii: InfraccionInfo) {
		self.infraccionInfo = ii
		if ii.infraccion != nil {
			self.lblTitle.text = ii.infraccion?.descripcion
			self.lblCodigo.text = ii.infraccion?.codigo
			let imageNamed = ii.infraccion!.resolucion != nil ? "solve" : "unsolve"
			self.imgState.image = UIImage(named: imageNamed)
		}
		if ii.acta != nil {
			self.lblActa.text = ii.acta!.numero! + " - " + ii.acta!.descripcion!
			self.lblCostoUF.text = String(format: "%.2f", ii.acta!.ufcosto!)
			self.lblImporteMinimo.text = String(format: "%.2f", ii.acta!.importeminimo!)
		}
		
		self.lblVisualizar.userInteractionEnabled = true
		self.lblVisualizar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(InfraccionTableViewCell.visualizar)))
		self.lblResolver.userInteractionEnabled = true
		self.lblResolver.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(InfraccionTableViewCell.resolver)))
	}
	
	func visualizar() {
		self.delegate?.visualizarClicked(self.infraccionInfo!)
	}

	func resolver() {
		self.delegate?.resolverClicked(self.infraccionInfo!)
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

//
//  LegajoTableViewCell.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 31/1/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

class LegajoTableViewCell: CardTableViewCell {

	@IBOutlet weak var lblTitle: UILabel!
	@IBOutlet weak var lblDominio: UILabel!
	@IBOutlet weak var lblFecha: UILabel!
	
	var id : String?
	
	func setLegajo(legajo: Legajo) {
		self.lblDominio.text = legajo.dominio
		self.lblFecha.text = legajo.fecha
		self.lblTitle.text = "Nro: " + legajo.numero! + " - " + legajo.nombrecompleto!
		self.lblTitle.numberOfLines = 0
		self.lblTitle.sizeToFit()
		self.id = legajo.id
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

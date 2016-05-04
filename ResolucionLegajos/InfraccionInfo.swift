//
//  InfraccionInfo.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 21/2/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import Foundation

class InfraccionInfo : NSObject {
	var acta : Acta?
	var infraccion : Infraccion?
	
	init(infraccion: Infraccion, acta: Acta) {
		self.acta = acta
		self.infraccion = infraccion
	}
}
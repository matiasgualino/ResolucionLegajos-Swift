//
//  ResolucionTableViewCellDelegate.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 5/5/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import Foundation

protocol ResumenTableViewCellDelegate : NSObjectProtocol {
	func modificarResolucion(ii: InfraccionInfo)
}

//
//  InfraccionTableViewCellDelegate.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 23/2/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import Foundation

protocol InfraccionTableViewCellDelegate : NSObjectProtocol {
	func visualizarClicked(ii: InfraccionInfo)
	func resolverClicked(ii: InfraccionInfo)
}
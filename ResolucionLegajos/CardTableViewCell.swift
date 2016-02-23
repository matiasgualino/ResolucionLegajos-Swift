//
//  CardTableViewCell.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 21/2/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import Foundation
import UIKit

class CardTableViewCell: UITableViewCell {
	
	@IBInspectable var cornerRadius: CGFloat = 2
	@IBInspectable var shadowOffsetWidth: Int = 0
	@IBInspectable var shadowOffsetHeight: Int = 3
	@IBInspectable var shadowColor: UIColor? = UIColor.blackColor()
	@IBInspectable var shadowOpacity: Float = 0.5
	
	override func layoutSubviews() {
		layer.cornerRadius = cornerRadius
		let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
		
		layer.masksToBounds = false
		layer.shadowColor = shadowColor?.CGColor
		layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
		layer.shadowOpacity = shadowOpacity
		layer.shadowPath = shadowPath.CGPath
	}
}

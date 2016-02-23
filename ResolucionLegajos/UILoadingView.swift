//
//  UILoadingView.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 23/1/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

public class UILoadingView : UIView {
	
	public init(frame rect: CGRect, text: NSString = "Cargando...") {
		super.init(frame: rect)
		self.backgroundColor = UIColor.blackColor()
		self.label.text = text as String
		self.spinner.color = Constants.YELLOW_COLOR
		self.label.textColor = Constants.YELLOW_COLOR
		self.spinner.startAnimating()
		
		self.addSubview(self.label)
		self.addSubview(self.spinner)
		
		self.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
		
		self.setNeedsLayout()
		
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	var label : UILabel = {
		var l = UILabel()
		l.font = UIFont(name: "HelveticaNeue", size: 15)
		return l
	}()
	var spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
	
	public func getText() -> String? {
		return self.label.text
	}
	
	override public func layoutSubviews() {
		self.label.sizeToFit()
		let labelSize: CGSize = self.label.frame.size
		var labelFrame: CGRect = CGRect()
		labelFrame.size = labelSize
		self.label.frame = labelFrame
		
		// center label and spinner
		self.label.center = self.center
		self.spinner.center = self.center
		
		// horizontally align
		labelFrame = self.label.frame
		var spinnerFrame: CGRect = self.spinner.frame
		let totalWidth: CGFloat = spinnerFrame.size.width + 5 + labelSize.width
		spinnerFrame.origin.x = self.bounds.origin.x + (self.bounds.size.width - totalWidth) / 2
		labelFrame.origin.x = spinnerFrame.origin.x + spinnerFrame.size.width + 5
		self.label.frame = labelFrame
		self.spinner.frame = spinnerFrame
		super.layoutSubviews()
	}
	
}

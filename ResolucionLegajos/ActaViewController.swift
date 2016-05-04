//
//  ActaViewController.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 23/1/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

class ActaViewController: MasterViewController {

	var legajo : Legajo?
	var infraccion : InfraccionInfo?
	
	var btnInfo : UIBarButtonItem?
	var btnCaratula : UIBarButtonItem?
	
	var caratulaView : CaratulaView?
	var legajoView : LegajoView?
	
	init(legajo: Legajo, infraccion: InfraccionInfo) {
		super.init(nibName: "ActaViewController", bundle: nil)
		self.legajo = legajo
		self.infraccion = infraccion
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.showLoadingMessage()
		
		self.btnInfo = UIBarButtonItem(title: "Ver Información", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ActaViewController.infoLegajo))
		self.btnCaratula = UIBarButtonItem(title: "Ver Carátula", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ActaViewController.caratulaLegajo))
		
		self.caratulaView = CaratulaView(frame: self.view.frame)
		self.caratulaView!.loadLegajo(self.legajo?.id)
		self.caratulaView!.finishLoadingDelegate = { () -> Void in
			self.hideLoadingMessage()
		}
		
		self.legajoView = LegajoView(frame: self.view.frame)
		self.legajoView!.loadData(self.legajo!, ii: infraccion!)
		self.legajoView!.resolverDelegate = { () -> Void in
			let vc = Constants.showResolucionDialog(self.infraccion!, navigationController: self.navigationController!, callback: {
				(acta) -> Void in
				if self.legajo != nil && self.legajo!.actas != nil && self.infraccion!.acta != nil {
					let index = self.legajo!.actas!.indexOf(self.infraccion!.acta!)
					if index != nil {
						self.legajo!.actas!.removeAtIndex(index!)
						self.legajo!.actas!.insert(acta, atIndex: index!)
						self.infraccion!.acta = acta
						self.legajoView!.loadData(self.legajo!, ii: self.infraccion!)
					}
				}
			})
			self.presentViewController(vc, animated: true, completion: nil)
		}
		
		self.view = caratulaView
		self.navigationItem.rightBarButtonItem = btnInfo
		self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
		
		let newBackButton = UIBarButtonItem(title: "Atras", style: .Bordered, target: self, action: #selector(ActaViewController.back(_:)))
		self.navigationItem.leftBarButtonItem = newBackButton
    }
	
	func back(sender: UIBarButtonItem) {
		if 	self.navigationItem.rightBarButtonItem == btnCaratula {
			self.caratulaLegajo()
		} else {
			self.navigationController?.popViewControllerAnimated(true)
		}
	}
	
	
	func infoLegajo() {
		self.navigationItem.rightBarButtonItem = btnCaratula
		UIView.transitionFromView(caratulaView!, toView: legajoView!, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
	}
	
	func caratulaLegajo() {
		self.navigationItem.rightBarButtonItem = btnInfo
		UIView.transitionFromView(legajoView!, toView: caratulaView!, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
	}

}

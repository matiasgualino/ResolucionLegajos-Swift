//
//  ReminderViewController.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 31/1/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

class ReminderViewController: UIViewController {

	@IBOutlet weak private var lblInfo : UILabel!
	@IBOutlet weak private var btnResolver : UIButton!
	@IBOutlet weak private var btnOlvidar : UIButton!
	
	var legajo : Legajo
	var cancelCallback : (() -> Void)
	var resolverCallback : (() -> Void)
	
	init(legajo: Legajo, cancelCallback: (() -> Void), resolverCallback: (() -> Void)) {
		self.legajo = legajo
		self.cancelCallback = cancelCallback
		self.resolverCallback = resolverCallback
		super.init(nibName: "ReminderViewController", bundle: nil)
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.lblInfo.text = "Nro: " + self.legajo.numero! + " - " + self.legajo.nombrecompleto!
		self.btnOlvidar.addTarget(self, action: #selector(ReminderViewController.olvidar), forControlEvents: .TouchUpInside)
		self.btnResolver.addTarget(self, action: #selector(ReminderViewController.resolver), forControlEvents: .TouchUpInside)
    }

	func olvidar() {
		
		let olvidarAlertView = UIAlertController(title: "ATENCIÓN", message: "Se va a eliminar el legajo actual y todas las resoluciones hechas en él hasta el momento. Desea continuar?", preferredStyle: .Alert)
		olvidarAlertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
			Constants.removeLegajoGuardado()
			self.dismissViewControllerAnimated(true, completion: nil)
			self.cancelCallback()
		}))
		self.showViewController(olvidarAlertView, sender: self)
	}
	
	func resolver() {
		self.dismissViewControllerAnimated(true, completion: nil)
		self.resolverCallback()
	}
	
}

//
//  ResolucionViewController.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 6/3/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

class ResolucionView: UIView, UITextViewDelegate {
	
	@IBOutlet var view:UIView!
	
	@IBOutlet var notaTextView: UITextView!
	@IBOutlet var importeTextField: UITextField!
	@IBOutlet var puntosTextField: UITextField!
	@IBOutlet var segmentedControl: UISegmentedControl!
	@IBOutlet var tituloLabel: UILabel!
	
	@IBOutlet var importeLabel: UILabel!
	
	var sancion : Sancion?
	var infraccion : Infraccion?
	var acta : Acta?
	
	var finishLoadingDelegate : (() -> Void)?
	
	let notaPlaceholder : String = "Haz clic para agregar una nota..."
	
	// Segmented
	let IMPORTE_INDEX = 0
	let UF_INDEX = 1
	
	// Alert
	let CONFIRMAR_INDEX = 0
	let CERRAR_INDEX = 1
	
	
	var callback: ((acta: Acta) -> Void)?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		NSBundle.mainBundle().loadNibNamed("ResolucionView", owner: self, options: nil)
		self.view.backgroundColor = UIColor.whiteColor()
		self.view.frame = frame
		self.view.layer.cornerRadius = 7
		
		self.notaTextView.text = notaPlaceholder
		self.notaTextView.textColor = UIColor.lightGrayColor()
		self.notaTextView.delegate = self
		
		self.segmentedControl.addTarget(self, action: #selector(ResolucionView.segmentedControlAction(_:)), forControlEvents: .ValueChanged)

		self.addSubview(self.view)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setInfraccionInfo(ii: InfraccionInfo, sancion: Sancion, callback: ((acta: Acta) -> Void)) {
		self.acta = ii.acta
		self.infraccion = ii.infraccion
		self.sancion = sancion
		
		self.callback = callback
		
		self.tituloLabel.text = "Resolución - " + sancion.descripcion! + " (" + sancion.codigo! + ")"
		
		if self.infraccion != nil {
			
			if self.sancion?.puntosmax == 0 && self.sancion?.puntosmin == 0 {
				self.puntosTextField.text = "0"
				self.puntosTextField.enabled = false
			}
			
			if self.infraccion!.resolucion != nil {
				self.notaTextView.text = self.infraccion!.resolucion!.nota
				self.puntosTextField.text = String(format: "%d", self.infraccion!.resolucion!.puntos!)
				
				if self.infraccion!.resolucion!.importe != nil {
					self.importeTextField.text = String(format: "%.2f", self.infraccion!.resolucion!.importe!)
					self.importeLabel.text = "Importe ($): "
					self.segmentedControl.selectedSegmentIndex = self.IMPORTE_INDEX
				} else if self.infraccion!.resolucion!.uf != nil {
					self.importeTextField.text = String(format: "%.2f", self.infraccion!.resolucion!.uf!)
					self.importeLabel.text = "UF (" + String(format: "%.2f", self.sancion!.ufmin!) + " - " + String(format: "%.2f", self.sancion!.ufmax!) + "): "
					self.segmentedControl.selectedSegmentIndex = self.UF_INDEX
				}
				
			}
		}
		
	}
	
	func textViewDidBeginEditing(textView: UITextView) {
		if textView.textColor == UIColor.lightGrayColor() {
			textView.text = nil
			textView.textColor = UIColor.blackColor()
		}
	}
	
	func textViewDidEndEditing(textView: UITextView) {
		if textView.text.isEmpty {
			textView.text = notaPlaceholder
			textView.textColor = UIColor.lightGrayColor()
		}
	}
	
	func onButtonTouchUpInside() -> ((alertView: CustomIOS8AlertView, buttonIndex: Int) -> Void) {
		return ({(alertView: CustomIOS8AlertView, buttonIndex: Int) -> Void in
			
			if buttonIndex == self.CONFIRMAR_INDEX {
				
				if self.validInputs() {
					let infraccionResuelta = self.infraccion?.copy() as? Infraccion
					
					if infraccionResuelta != nil {
						let resolucion = Resolucion()
						resolucion.codigo = self.sancion!.codigo
						if self.notaTextView.text != self.notaPlaceholder {
							resolucion.nota = self.notaTextView.text
						}
						
						if (self.puntosTextField.text == nil) || (self.sancion?.puntosmax == 0 && self.sancion?.puntosmin == 0) {
							resolucion.puntos = 0
						} else {
							resolucion.puntos = Int(self.puntosTextField.text!)
						}
						
						if self.segmentedControl.selectedSegmentIndex == self.IMPORTE_INDEX {
							resolucion.uf = 0.0
							resolucion.importe = self.importeTextField.text == nil ? 0.0 : Double(self.importeTextField.text!)
						} else {
							resolucion.importe = 0.0
							resolucion.uf = self.importeTextField.text == nil ? 0.0 : Double(self.importeTextField.text!)
						}
						
						resolucion.codigo = self.sancion?.codigo
						
						infraccionResuelta!.resolucion = resolucion
						
						let actaNueva = self.acta?.copy() as? Acta
						
						if actaNueva != nil {
							let index = actaNueva!.infracciones?.indexOf(self.infraccion!)
							if index != nil {
								actaNueva!.infracciones?.removeAtIndex(index!)
								actaNueva!.infracciones?.insert(infraccionResuelta!, atIndex: index!)
							}
							self.callback?(acta: actaNueva!)
						} else {
							self.callback?(acta: self.acta!)
						}
						
					}
				} else {
					let alertController = UIAlertView(title: "ERROR", message: "Falta completar alguno de los campos requeridos. Verifica los campos puntos y valor", delegate: nil, cancelButtonTitle: "OK")
					alertController.show()
				}
			} else if buttonIndex == self.CERRAR_INDEX {
				self.callback?(acta: self.acta!)
			}
			
		})
		
	}
	
	func validInputs() -> Bool {
		
		var valid = true
		
		let puntosStr = self.puntosTextField.text
		if (puntosStr != nil || puntosStr != "") {
			let puntosInt = Int(puntosStr!)
			if puntosInt != nil {
				if self.sancion!.puntosmin > puntosInt || self.sancion?.puntosmax < puntosInt {
					valid = false
				}
			} else {
				valid = false
			}
		} else {
			valid = false
		}
		
		if self.segmentedControl.selectedSegmentIndex == self.IMPORTE_INDEX {
			let importeStr = self.importeTextField.text
			if (importeStr != nil || importeStr != "") {
				let importeDouble = Double(importeStr!)
				if importeDouble == nil {
					valid = false
				}
			} else {
				valid = false
			}
		} else if self.segmentedControl.selectedSegmentIndex == self.UF_INDEX {
			let ufStr = self.puntosTextField.text
			if (ufStr != nil || ufStr != "") {
				let ufDouble = Double(ufStr!)
				if ufDouble != nil {
					if self.sancion!.ufmin > ufDouble || self.sancion?.ufmax < ufDouble {
						valid = false
					}
				} else {
					valid = false
				}
			} else {
				valid = false
			}
		}
		
		return valid
	}
	
	func segmentedControlAction(sender: AnyObject) {
		if segmentedControl.selectedSegmentIndex == self.IMPORTE_INDEX {
			
			self.importeLabel.text = "Importe ($): "
			if self.infraccion != nil && self.infraccion!.resolucion != nil && self.infraccion!.resolucion!.importe != nil {
				self.importeTextField.text = String(format: "%.2f", self.infraccion!.resolucion!.importe!)
			}
		} else if segmentedControl.selectedSegmentIndex == self.UF_INDEX {
			let ufminStr = String(format: "%.2f", self.sancion!.ufmin!)
			
			self.importeLabel.text = "UF (" + ufminStr + " - " + String(format: "%.2f", self.sancion!.ufmax!) + "): "
			if self.infraccion != nil && self.infraccion!.resolucion != nil && self.infraccion!.resolucion!.uf != nil {
				self.importeTextField.text = String(format: "%.2f", self.infraccion!.resolucion!.uf!)
			} else {
				self.importeTextField.text = ufminStr
			}
			
		}
	}
}
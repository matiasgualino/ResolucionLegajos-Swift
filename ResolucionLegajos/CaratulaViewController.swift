//
//  CaratulaViewController.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 23/1/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

class CaratulaViewController: MasterViewController, UIScrollViewDelegate {
	
	var caratulaView: CaratulaView!
	var legajoId : String?
	
	init(legajoId: String?) {
		super.init(nibName: "CaratulaViewController", bundle: nil)
		self.legajoId = legajoId
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.showLoadingMessage()
		let caratulaView = CaratulaView(frame: self.view.frame)
		caratulaView.loadLegajo(self.legajoId)
		caratulaView.finishLoadingDelegate = { () -> Void in
			self.hideLoadingMessage()
		}
		self.view = caratulaView
	}
	
	// Update zoom scale and constraints with animation.
	@available(iOS 8.0, *)
	override func viewWillTransitionToSize(size: CGSize,
		withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
			
			super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
			
			coordinator.animateAlongsideTransition({ [weak self] _ in
				self?.caratulaView.updateZoom()
    }, completion: nil)
	}

}

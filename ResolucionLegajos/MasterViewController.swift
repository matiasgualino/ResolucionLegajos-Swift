//
//  MasterViewController.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 31/1/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import Foundation
import UIKit

class MasterViewController : UIViewController {
	
	var isLoadingMessageShowing : Bool = false
	var loadingView : UILoadingView!
	
	var accessToken : String? = Constants.getAccessToken()
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = Constants.CLEAR_COLOR
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		self.hidesBottomBarWhenPushed = true
	}
	
	func showLoadingMessage() {
		self.showLoadingMessage("Cargando...")
	}
	
	func hideLoadingMessage() {
		self.isLoadingMessageShowing = false
		self.loadingView.removeFromSuperview()
		self.navigationItem.backBarButtonItem?.enabled = true
		self.navigationItem.rightBarButtonItem?.enabled = true
	}
	
	func showLoadingMessage(message: String) {
		self.navigationItem.backBarButtonItem?.enabled = false
		self.navigationItem.rightBarButtonItem?.enabled = false
		self.isLoadingMessageShowing = true
		self.loadingView = UILoadingView(frame: self.view.bounds, text: message)
		self.view.addSubview(self.loadingView)
	}
}

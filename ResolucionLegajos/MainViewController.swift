//
//  MainViewController.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 23/1/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

class MainViewController: MasterViewController, UITableViewDataSource, UITableViewDelegate {

	var legajos : [Legajo]!
	@IBOutlet weak private var legajosTableView : UITableView!
	
	override init() {
		super.init(nibName: "MainViewController", bundle: nil)
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.title = "Inicio"
		
		if self.accessToken != nil {
			self.showLoadingMessage()
			let legajosNib = UINib(nibName: "LegajoTableViewCell", bundle: nil)
			self.legajosTableView.registerNib(legajosNib, forCellReuseIdentifier: "legajoCell")
			let legajosHeaderNib = UINib(nibName: "LegajosHeaderTableViewCell", bundle: nil)
			self.legajosTableView.registerNib(legajosHeaderNib, forCellReuseIdentifier: "legajosHeaderCell")
			
			self.legajosTableView.delegate = self
			self.legajosTableView.dataSource = self
			
			self.legajosTableView.backgroundView = UIView()
			self.legajosTableView.backgroundView?.backgroundColor = Constants.CLEAR_COLOR
			
			self.legajosTableView.backgroundColor = Constants.CLEAR_COLOR
			
			ActaService.getAllLegajos(self.accessToken!, success: { (legajos) -> Void in
				self.legajos = legajos
				self.legajosTableView.reloadData()
				self.hideLoadingMessage()
				}) { (error) -> Void in
					// TODO: ERROR
			}
		} else {
			// TODO: ERROR
		}
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return legajos == nil ? 0 : legajos.count + 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if section == 0 {
			return nil
		} else {
			let v = UIView()
			v.backgroundColor = UIColor.clearColor()
			return v
		}
	}
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 0 {
			return 0
		} else {
			return 10
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let legajoHeaderCell : LegajosHeaderTableViewCell = self.legajosTableView.dequeueReusableCellWithIdentifier("legajosHeaderCell") as! LegajosHeaderTableViewCell
			legajoHeaderCell.backgroundColor = Constants.CLEAR_COLOR
			return legajoHeaderCell
		} else {
			let legajoCell : LegajoTableViewCell = self.legajosTableView.dequeueReusableCellWithIdentifier("legajoCell") as! LegajoTableViewCell
			
			let legajo : Legajo = legajos[indexPath.section - 1]
			legajoCell.setLegajo(legajo)
			legajoCell.backgroundColor = UIColor.blackColor()
			return legajoCell
		}
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.section == 0 {
			return 35
		} else {
			return 145
		}
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let legajoSelected : Legajo = self.legajos![indexPath.row]
		self.navigationController?.pushViewController(LegajoViewController(legajoId: legajoSelected.id), animated: true)
	}

}

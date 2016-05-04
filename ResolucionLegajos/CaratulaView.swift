//
//  CaratulaView.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 5/3/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

class CaratulaView: UIView, UIScrollViewDelegate {
	
	@IBOutlet var view:UIView!
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var imageView: UIImageView!
	
	@IBOutlet weak var imageConstraintTop: NSLayoutConstraint!
	@IBOutlet weak var imageConstraintRight: NSLayoutConstraint!
	@IBOutlet weak var imageConstraintLeft: NSLayoutConstraint!
	@IBOutlet weak var imageConstraintBottom: NSLayoutConstraint!
	
	var lastZoomScale: CGFloat = -1
	
	var legajoId : String?
	
	var finishLoadingDelegate : (() -> Void)?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		NSBundle.mainBundle().loadNibNamed("CaratulaView", owner: self, options: nil)
		self.view.backgroundColor = UIColor.clearColor()
		self.view.frame = UIScreen.mainScreen().bounds
		self.addSubview(self.view)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func loadLegajo(legajoId: String?) {
		self.legajoId = legajoId
		let imgURL: NSURL = NSURL(string: Constants.BASE_URL + "/Caratula?token=" + Constants.getAccessToken()! + "&legajo=" + legajoId!)!
		let request: NSURLRequest = NSURLRequest(URL: imgURL)
		NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
			if error == nil {
				self.imageView.image = UIImage(data: data!)
				self.scrollView.delegate = self
				self.updateZoom()
				self.finishLoadingDelegate?()
			}
		})
	}
	
	override func updateConstraints() {
		super.updateConstraints()
		if let image = imageView.image {
			let imageWidth = image.size.width
			let imageHeight = image.size.height
			
			let viewWidth = scrollView.bounds.size.width
			let viewHeight = scrollView.bounds.size.height
			
			// center image if it is smaller than the scroll view
			var hPadding = (viewWidth - scrollView.zoomScale * imageWidth) / 2
			if hPadding < 0 { hPadding = 0 }
			
			var vPadding = (viewHeight - scrollView.zoomScale * imageHeight) / 2
			if vPadding < 0 { vPadding = 0 }
			
			imageConstraintLeft.constant = hPadding
			imageConstraintRight.constant = hPadding
			
			imageConstraintTop.constant = vPadding
			imageConstraintBottom.constant = vPadding
			
			layoutIfNeeded()
		}
	}
	
	// Zoom to show as much image as possible unless image is smaller than the scroll view
	func updateZoom() {
		if let image = imageView.image {
			var minZoom = min(scrollView.bounds.size.width / image.size.width,
				scrollView.bounds.size.height / image.size.height)
			
			if minZoom > 1 { minZoom = 1 }
			
			scrollView.minimumZoomScale = minZoom
			
			// Force scrollViewDidZoom fire if zoom did not change
			if minZoom == lastZoomScale { minZoom += 0.000001 }
			
			scrollView.zoomScale = minZoom
			lastZoomScale = minZoom
		}
	}
	
	// UIScrollViewDelegate
	// -----------------------
	
	func scrollViewDidZoom(scrollView: UIScrollView) {
		updateConstraints()
	}
	
	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
		return imageView
	}
}

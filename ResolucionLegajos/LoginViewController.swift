//
//  LoginViewController.swift
//  ResolucionLegajos
//
//  Created by Matias Gualino on 23/1/16.
//  Copyright © 2016 MatiasGualino. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	
	var loadingView : UILoadingView!
	
	@IBOutlet weak var usernameTextField : UITextField!
	@IBOutlet weak var passwordTextField : UITextField!
	@IBOutlet weak var btnLogin: UIButton!
	
	init() {
		super.init(nibName: "LoginViewController", bundle: nil)
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Actas - Login"
		
		var f = self.view.frame
		f.origin.y = self.navigationController != nil ? self.navigationController!.navigationBar.frame.origin.y +  self.navigationController!.navigationBar.frame.size.height : 0
		f.size.height = self.heightForView()
		f.size.width = UIScreen.mainScreen().bounds.width
		self.view.frame = f
		
		self.loadingView = UILoadingView(frame: self.view.bounds, text: "Cargando...")
		
		self.btnLogin.layer.cornerRadius = 4
		self.btnLogin.setTitle("Ingresar", forState: UIControlState.Normal)
		
		self.usernameTextField.placeholder = "Nombre de usuario"
		self.passwordTextField.placeholder = "Clave"
		self.passwordTextField.secureTextEntry = true
		
		let paddingViewUsername = UIView(frame: CGRectMake(0, 0, 20, self.usernameTextField.frame.height))
		self.usernameTextField.leftView = paddingViewUsername
		self.usernameTextField.leftViewMode = UITextFieldViewMode.Always
		self.usernameTextField.autocorrectionType = UITextAutocorrectionType.No
		self.usernameTextField.autoresizingMask = UIViewAutoresizing.FlexibleWidth
		self.usernameTextField.autocapitalizationType = UITextAutocapitalizationType.None
		self.usernameTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
		
		let paddingViewPassword = UIView(frame: CGRectMake(0, 0, 20, self.passwordTextField.frame.height))
		self.passwordTextField.leftView = paddingViewPassword
		self.passwordTextField.leftViewMode = UITextFieldViewMode.Always
		self.passwordTextField.autocorrectionType = UITextAutocorrectionType.No
		self.passwordTextField.autoresizingMask = UIViewAutoresizing.FlexibleWidth
		self.passwordTextField.autocapitalizationType = UITextAutocapitalizationType.None
		self.passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
		
		self.usernameTextField.becomeFirstResponder()
		
		self.usernameTextField.text = "admin"
		self.passwordTextField.text = "admin"
		
		self.btnLogin.addTarget(self, action: #selector(LoginViewController.login), forControlEvents: UIControlEvents.TouchUpInside)
		
    }
	
	func login() {
		self.usernameTextField.resignFirstResponder()
		self.passwordTextField.resignFirstResponder()
		var error : String? = nil
		
		if self.usernameTextField.text == nil || self.usernameTextField.text == "" {
			error = "Debes ingresar un nombre de usuario."
		}

		if self.passwordTextField.text == nil || self.passwordTextField.text == "" {
			error = "Debes ingresar una clave."
		}
		
		if error != nil {
			self.showErrorLoginAlert(error!)
		} else {
			self.view.addSubview(self.loadingView)
			let loginRequest = LoginRequest()
			loginRequest.username = self.usernameTextField.text
			loginRequest.password = self.passwordTextField.text
			LoginService.login(loginRequest, success: { (accessToken) -> Void in
				if accessToken != nil && accessToken != "" {
					Constants.setAccessToken(accessToken!)
					Constants.setUsername(loginRequest.username!)
					self.loadingView.removeFromSuperview()
					self.dismissViewControllerAnimated(false, completion: nil)
					self.navigationController?.pushViewController(MainViewController(), animated: true)
				} else {
					self.loginError()
				}
				
				}, failure: { (error) -> Void in
					self.loginError()
			})
		}
	}
	
	func loginError() {
		self.loadingView.removeFromSuperview()
		self.showErrorLoginAlert("Ocurrió un error al ingresar. Intenta nuevamente o verifica tus credenciales.")
	}
	
	func heightForView() -> CGFloat {
		return CGRectGetHeight(UIScreen.mainScreen().bounds)
	}
	
	private func showErrorLoginAlert(message: String) {
		let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
		let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
		alertController.addAction(defaultAction)
		presentViewController(alertController, animated: true, completion: nil)
	}

}

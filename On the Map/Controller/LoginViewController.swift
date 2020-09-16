//
//  LoginViewController.swift
//  On the Map
//
//  Created by Aditya Rana on 02.09.20.
//  Copyright © 2020 Aditya Rana. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         DispatchQueue.main.async {
                  self.emailTextField.becomeFirstResponder()
              }
              activityIndicator.hidesWhenStopped = true
              
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
              view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    @IBAction func loginButton(_ sender: UIButton) {
        
       LocationModel.login(with: emailTextField.text!, password: passwordTextField.text!, completion: handleLoginResponse(success:error:))
        
         }

         

         func setLoggingIn(_ loggingIn: Bool) {
             if loggingIn {
                 activityIndicator.startAnimating()
             } else {
                 activityIndicator.stopAnimating()
             }
         }
         
         func showLoginFailure(message: String) {
             let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
             alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
             show(alertVC, sender: nil)
         }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        
    UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
    }
    
    func handleLoginResponse(success: Bool, error: Error?){
     
         if success {
             performSegue(withIdentifier: "loginSuccess", sender: nil)
             setLoggingIn(true)
         }
         else {
       
            showLoginFailure(message: error?.localizedDescription ?? "Wrong Email or Password!!")
            setLoggingIn(false)
         }
       }
    @objc override func dismissKeyboard() {
           view.endEditing(true)
       }
   
}


//
//  ViewController.swift
//  onTheMap
//
//  Created by Mohamad Elaraby on 3/16/19.
//  Copyright © 2019 Mohamad Elaraby. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailtextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    let activityIndecator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardWillShow))
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardWillHide))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.activityIndicator(isProcessing: false)
    }
    
    // MARK: Login
    
    @IBAction func loginButton(_ sender: AnyObject) {
        
        activityIndicator(isProcessing: true)
        if emailtextField.text == "" || passwordTextField.text == "" {
            displayError(error: "Username or Password Empty.")
            activityIndicator(isProcessing: false)
        } else {
            UdacityAPI.shared.login(email: emailtextField.text!, password: passwordTextField.text!) {(successful, error) in
                DispatchQueue.main.async {
                    // for any error not expeceted
                    if let error = error {
                        self.displayError(error: error)
                    }
                    
                    // for invalid email or password
                    if !successful {
                        self.displayError(error: "Invalid email or password")
                        self.accessibilityAssistiveTechnologyFocusedIdentifiers()
                        self.activityIndicator(isProcessing: false)
                    } else {
                        
                        self.displayError(error: "Login Successful")
                        self.performSegue(withIdentifier: "showTabBarController", sender: self)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            self.displayError(error: " ")
                            self.activityIndecator.stopAnimating()
                        })

                    }
                }
            }
           
        }
    }
    
    func displayError (error : String! ){
        let text = error
        debugTextLabel.text = text
    }
    @IBAction func signupButton(_ sender: Any) {
        let url = URL(string: "https://www.udacity.com/account/auth#!/signup")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if keyboardHeight(notification) > 400 {
            view.frame.origin.y = -keyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    func activityIndicator (isProcessing : Bool){
        
        if isProcessing == true {
            activityIndecator.style = UIActivityIndicatorView.Style.gray
            activityIndecator.center = self.view.center
            activityIndecator.hidesWhenStopped = true
            activityIndecator.startAnimating()
            self.view.addSubview(activityIndecator)
            activityIndecator.startAnimating()
        }else {
            activityIndecator.stopAnimating()
        }

    }
    
}
    




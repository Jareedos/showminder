//
//  ViewController.swift
//  showminder
//
//  Created by Jared Sobol on 8/16/16.
//  Copyright © 2016 Appmaker. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var emailTextField: MaterialTextField!
    @IBOutlet weak var passwordTextField: MaterialTextField!
  

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginBtnClicked(sender: AnyObject) {
        
        if let email = emailTextField.text where email != "", let pwd = passwordTextField.text where pwd != "" {
            
            
            FIRAuth.auth()?.createUserWithEmail(emailTextField.text!, password: passwordTextField.text!, completion: {
                user, error in

            })
        } else {
            showErrorAlert("Email & Password Required", msg: "You must enter an email and a password")
        }
        
    }
    
//    func login(){
//        FIRAuth.auth()?.signInWithEmail(emailTextField.text!, password: passwordTextField.text!, completion: {
//            user,error in
//            
//            if error != nil{
//                print("error")
//            } else {
//                print("It Worked")
//            }
//            
//            
//        })
//    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
        
    }
    


}


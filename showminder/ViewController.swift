//
//  ViewController.swift
//  showminder
//
//  Created by Jared Sobol on 8/16/16.
//  Copyright © 2016 Appmaker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase



class ViewController: UIViewController {
    @IBOutlet weak var emailTextField: MaterialTextField!
    @IBOutlet weak var passwordTextField: MaterialTextField!
    
    var typeMode = false
    

  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let tapgestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTapOnBackground))
        self.view.addGestureRecognizer(tapgestureRecognizer)
    
    }
    
    override func awakeFromNib() {
//        FIRApp.configure()
//        callApi(completed: {
//          
//        })
    }
    
    func didTapOnBackground() {
        self.view.endEditing(true)
    }
    

    
    @IBAction func attemptLogin(_ sender: UIButton!) {
        
        if let email = emailTextField.text , email != "", let pwd = passwordTextField.text , pwd != "" {
           
     
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: {
                user, error in
            
                if let error = error as? NSError {
                    print(error)
                  
                    
                  if error.code == STATUS_ACCOUNT_NONEXIST {
                         FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: {
                            user, error in
                    
                        
                            
                            if error != nil {
                                print(error)
                                self.showErrorAlert("Could not create account", msg: "Server error, Please try again. Password must be 6 characters or longer")
                            } else {
            
                                
                                FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: {
                                    user, error in
                                
                                        self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
                                    
                                    let userEmail = ["userEmal": email]
                                    let cableProvider = ["cableProvider": "nil"]
                                    let timeZone = ["timeZone": "nil"]
                                    
                        
                                    DataService.ds.createFirebaseDBUser(uid: (user?.uid)!, userEmail: userEmail, cableProvider: cableProvider, timeZone: timeZone)
                                    
                                    
                                   
                               })
                            }
                            
                       })
                  } else if error.code == INVALID_EMAIL_ADDRESS {
                        self.showErrorAlert("Could not login", msg: "Please enter a valid email")
                  } else if error.code == PASSWORD_ISNT_LONG_ENOUGH {
                        self.showErrorAlert("Could not login", msg: "Please enter a vaild password of 6 characters or longer")
                  } else {
                        self.showErrorAlert("Could not login", msg: "Please check your username or password")
//                    print(error)
//                    print(error!.code)
                   }
                
                } else {
                    self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
                }
                
            })
            
            
        } else {
            showErrorAlert("Email and Password Required", msg: "You must enter an email and a password")

         
        }
    }

        
        func showErrorAlert(_ title: String, msg: String) {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default , handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        
        }
}


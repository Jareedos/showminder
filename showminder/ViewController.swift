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


    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
    }
    
 
    
    @IBAction func attemptLogin(sender: UIButton!) {
        
        if let email = emailTextField.text where email != "", let pwd = passwordTextField.text where pwd != "" {
           
     
            FIRAuth.auth()?.signInWithEmail(email, password: pwd, completion: {
                user, error in
            
                if error != nil {
                    
                  
                    
                  if error!.code == STATUS_ACCOUNT_NONEXIST {
                          FIRAuth.auth()?.createUserWithEmail(email, password: pwd, completion: {
                            user, error in
                    
                        
                            if error != nil {
                                print(error)
                                print(error!.code)
                                self.showErrorAlert("Could not create account", msg: "Problem creating account. Try something else")
                            } else {
            
                                
                                FIRAuth.auth()?.signInWithEmail(email, password: pwd, completion: {
                                    user, error in
                                
                                        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                                    

                                    NSUserDefaults.standardUserDefaults().setObject(user?.uid, forKey: KEY_UID)
                                })
                            }
                            
                        })
                  } else if error!.code == INVALID_EMAIL_ADDRESS {
                        self.showErrorAlert("Could not login", msg: "Please enter a valid email")
                  } else if error!.code == PASSWORD_ISNT_LONG_ENOUGH {
                        self.showErrorAlert("Could not login", msg: "Please enter a vaild password of 6 characters or greater")
                  } else {
                        self.showErrorAlert("Could not login", msg: "Please check your username or password")
//                    print(error)
//                    print(error!.code)
                    }
                    
                } else {
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    NSUserDefaults.standardUserDefaults().setObject(user?.uid, forKey: KEY_UID)
                }
                
            })
            
            
        } else {
            showErrorAlert("Email and Password Required", msg: "You must enter an email and a password")

         
        }
    }

        
        func showErrorAlert(title: String, msg: String) {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default , handler: nil)
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
            
        }


}


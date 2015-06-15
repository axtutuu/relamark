//
//  LoginViewController.swift
//  relamark
//
//  Created by mac on 2015/06/04.
//  Copyright (c) 2015年 AtsushiKawasaki. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var uid = NSUserDefaults.standardUserDefaults().stringForKey("token")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        password.secureTextEntry = true
        if ((uid) != nil) {
            self.performSegueWithIdentifier("toMapView", sender: nil)
        }
                
        println(uid)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sumitButton(sender: AnyObject) {
        if (email.text.isEmpty) || (password.text.isEmpty) {
            var alertController = UIAlertController(title: "Error", message: "Email or Password is empty", preferredStyle: UIAlertControllerStyle.Alert)
            var action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(action)
            presentViewController(alertController, animated: true, completion: nil)
            
        } else {
            var request = "http://localhost:3000/api/v1/user_sessions.json"
            var parameters = [
                "email" : email.text,
                "password" : password.text
            ]
            
            Alamofire.request(.POST, request, parameters: parameters).responseJSON
                {
                    (request, response, json, errors) in
                    var jsonData = JSON(json!)
                    if jsonData["results"]["status"] == 1 {
                        NSUserDefaults.standardUserDefaults().setObject(jsonData["results"]["token"].string!, forKey: "token")
                        self.performSegueWithIdentifier("toMapView", sender: nil)
                    } else {
                        
                    }
                    println(jsonData)
            }
        }
    }
    
}

//
//  SignUpViewController.swift
//  relamark
//
//  Created by mac on 2015/06/04.
//  Copyright (c) 2015年 AtsushiKawasaki. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    
    
    var jsonData : JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password.secureTextEntry = true
        passwordConfirm.secureTextEntry = true
        
        // place holder用
        let attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // placeHolderカラー変更
        email.attributedPlaceholder = NSAttributedString(string: "Email", attributes: attributesDictionary)
        password.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributesDictionary)
        passwordConfirm.attributedPlaceholder = NSAttributedString(string: "Password Confirm", attributes: attributesDictionary)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tappedSubmitButton(sender: AnyObject) {
        if (email.text.isEmpty) || (password.text.isEmpty) || (passwordConfirm.text.isEmpty) {
            var alertController = UIAlertController(title: "Error", message: "Email or Password is empty", preferredStyle: UIAlertControllerStyle.Alert)
            var action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(action)
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            var requestURL = Const().URL_API + "/api/v1/users.json"

            var parametars = [
                "email" : email.text,
                "password" : password.text,
                "password_confirmation": passwordConfirm.text
            ]
            
            Alamofire.request(.POST, requestURL, parameters: parametars).responseJSON {
                (request, response, json, errors) in
                self.jsonData = JSON(json!)
                if (self.jsonData["results"]["status"] == 0) {
                    // TODO エラー表示
                    var alertController = UIAlertController(title: "Error", message: "Error", preferredStyle: UIAlertControllerStyle.Alert)
                    var action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(action)
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    self.performSegueWithIdentifier("toMapView", sender: nil)
                }
                println(self.jsonData)
            }
            
        }
        println(email.text)
        println(password.text)
        println(passwordConfirm.text)
    }
}

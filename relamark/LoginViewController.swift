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
    
    // place holder用
    let attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    
    var uid = NSUserDefaults.standardUserDefaults().stringForKey("token")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        password.secureTextEntry = true
        if ((uid) != nil) {
            self.performSegueWithIdentifier("toMapView", sender: nil)
        }
        
        // placeholderのテキストカラー変更
        email.attributedPlaceholder = NSAttributedString(string: "Email", attributes: attributesDictionary)
        
        password.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributesDictionary)
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
            var requestUrl = Const().URL_API + "/api/v1/user_sessions.json"
            var parameters = [
                "email" : email.text,
                "password" : password.text
            ]
            
            Alamofire.request(.POST, requestUrl, parameters: parameters).responseJSON
                {
                    (request, response, json, errors) in
                    var jsonData = JSON(json!)
                    println(jsonData)
                    if jsonData["results"]["status"] == 1 {
                        NSUserDefaults.standardUserDefaults().setObject(jsonData["results"]["token"].string!, forKey: "token")
                        self.performSegueWithIdentifier("toMapView", sender: nil)
                    } else {
                        // ログイン失敗アラート画面
                        let alertController = UIAlertController(title: "Error", message: "Couldn't find user.\nPlease Sign Up before use this App", preferredStyle: UIAlertControllerStyle.Alert)
                        var action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                        alertController.addAction(action)
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                    println(jsonData)
            }
        }
    }
}

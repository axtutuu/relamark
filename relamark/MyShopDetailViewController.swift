//
//  MyShopDetailViewController.swift
//  relamark
//
//  Created by mac on 2015/06/16.
//  Copyright (c) 2015年 AtsushiKawasaki. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class MyShopDetailViewController: UIViewController {
    var myShopData : JSON!
    

    // view定義
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    var isShopExist : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // メイン画像コンバート
        var mainImageUrl = NSURL(string: myShopData["image_url"].string!)
        var mainImageData : NSData = NSData(contentsOfURL: mainImageUrl!)!
        
        mainImage.image = UIImage(data: mainImageData)
        
        // ラベル
        titleLabel.text = myShopData["name"].string!
        addressLabel.text = myShopData["address"].string!
        
        // ボタン色変更
        changeButtonColor()
    }
    
    // actionシート マップの表示
    @IBAction func goButton(sender: AnyObject) {
        
        var name : String! = myShopData["address"].string!
        var latitude : String! = myShopData["latitude"].string!
        var longitude : String! = myShopData["longitude"].string!
        
        var replaceName : String! = name.stringByReplacingOccurrencesOfString(" ", withString: "+", options: nil, range: nil)
        
        println(replaceName)
        
        // 日本語対応のエスケープ
        var escapeName : String! = replaceName.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        var currentLocation = "Current Location"
        var currentLocationEscape : String! = currentLocation.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        let alertController = UIAlertController(title: "Select App", message: "",preferredStyle: .ActionSheet)
        
        // Google Mapの起動
        let googleMap = UIAlertAction(title: "Open with Google Map", style: .Default) {
            action in
            var url : NSURL! = NSURL(string: "comgooglemaps://?q=\(escapeName)&center=\(latitude),\(longitude)")
            
            if UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
            } else {
                // オープンできない場合の対処法
                self.alerView()
            }
        }

        let defaultMap = UIAlertAction(title: "Open with Default Map", style: .Default) {
            action in
            var defaultUrl: NSURL! = NSURL(string: "http://maps.apple.com/?q=\(latitude),\(longitude)")

            if UIApplication.sharedApplication().canOpenURL(defaultUrl) {
                UIApplication.sharedApplication().openURL(defaultUrl)
            } else {
                // オープンできない場合の対処法
                self.alerView()
            }
            
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            action in
            println("Cancel")
        }
        
        alertController.addAction(googleMap)
        alertController.addAction(defaultMap)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    

    
    @IBAction func tappedGoBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    func changeButtonColor() {
        var parameters = [
            "shop_id" : myShopData["shop_id"].string!
        ]
        var requestUrl = Const().URL_API + "/api/v1/shops/find_shop.json"
        
        Alamofire.request(.GET, requestUrl, parameters: parameters).responseJSON {
            (request, response, json, error) in
            println("***************2********************")
            var saveResultJson : JSON = JSON(json!)
            
            self.isShopExist = saveResultJson["results"]["status"].intValue
            
            if (self.isShopExist == 1) {
                self.saveButton.backgroundColor = UIColor.grayColor()
            } else {
                self.saveButton.backgroundColor = UIColor.redColor()
            }
            println(json)
            println("***************2********************")
        }
    }

    
    @IBAction func tappedSaveButton(sender: AnyObject) {
        var loginView = LoginViewController()
        
        if (self.isShopExist == 0) {
            var requestUrl = Const().URL_API + "/api/v1/shops.json"
            var parameters = [
                "token" : "\(loginView.uid)",
                "shop_id"  : myShopData["shop_id"].string!,
            ]
            
            Alamofire.request(.POST, requestUrl, parameters: parameters).responseJSON {
                (request, response, json, errors) in
                println(json!)
                println(errors)
                var results = JSON(json!)
                println(results["results"]["status"].number!)
                
                if (results["results"]["status"].number! == 1) {
                    self.changeButtonColor()
                    
                } else {
                    
                    // TODO エラー処理
                    var alertController = UIAlertController(title: "Error", message: "Fail", preferredStyle: UIAlertControllerStyle.Alert)
                    var action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(action)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
            
        } else {
            var requestUrl = Const().URL_API + "/api/v1/shops/destroy.json"
            var parameters = [
                "token" : "\(loginView.uid)",
                "shop_id" : self.myShopData["shop_id"].string!,
            ]
            
            Alamofire.request(.POST, requestUrl, parameters: parameters).responseJSON {
                (request, response, json, error) in
                var resultJson : JSON = JSON(json!)
                
                if (resultJson["results"]["status"].intValue == 1) {
                    self.changeButtonColor()
                } else {
                    
                }
            }
        }
    }
    
    // alert View
    func alerView() {
        var alertController = UIAlertController(title: "Error", message: "Couldn't find Map", preferredStyle: UIAlertControllerStyle.Alert)
        var action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
//
//  ShopDetailViewController.swift
//  relamark
//
//  Created by mac on 2015/05/27.
//  Copyright (c) 2015年 AtsushiKawasaki. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ShopDetailViewController: UIViewController {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    var shopDetail : JSON = []
    var types : String?
    var imageUrl : String!
    
    // save済み判定変数
    var isShopExist : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTitle.text = self.shopDetail["name"].string
        address.text = self.shopDetail["vicinity"].string
        typesLabel.text = types
        
        
        // URLから画像データの生成
        var iconUrl = NSURL(string: self.shopDetail["icon"].string!)!
        var iconData : NSData = NSData(contentsOfURL: iconUrl)!
        
        icon.image = UIImage(data: iconData)
        icon.layer.cornerRadius = 3
        icon.layer.masksToBounds = true
        
        println("***************1********************")
        println(self.shopDetail)
        println("***************1********************")


        var url = ""
        if self.shopDetail["photos"] != nil {
            url = shopDetail["place_id"].string!
            getShopImage(url)
        } else {
            mainImage.image = UIImage(named: "na_61_02")
        }
        
        //saveボタンデザイン出し分け
        changeButtonColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 画像取得API
    func getShopImage(url: String){
        var requestUrl = Const().URL_API + "/api/v1/spots/show.json"
        var parameters = [
            "place_id" : url,
        ]
        
        Alamofire.request(.GET, requestUrl, parameters: parameters).responseJSON
            {
                (request, response, json, errors) in
                var jsonData = JSON(json!)
                self.imageUrl = jsonData["results"].string!
                
                // URLから画像データの生成
                var shopUrl = NSURL(string: self.imageUrl)
                var shopData : NSData = NSData(contentsOfURL: shopUrl!)!
                self.mainImage.image = UIImage(data: shopData)
        }
    }
    
    @IBAction func tappedSave(sender: AnyObject) {
        // TODO 画像読み込み待ちの必要あり
        // すでにセーブされている場合は削除を行う
        
        var loginView = LoginViewController()
        
        if (self.isShopExist == 0) {
            var requestUrl = Const().URL_API + "/api/v1/shops.json"

            var parameters = [
                "token" : loginView.uid,
                "name"  : self.shopDetail["name"].string,
                "shop_id"  : self.shopDetail["id"].string,
                "image_url" : self.imageUrl,
                "icon_url"  : self.shopDetail["icon"].string,
                "address"   : self.shopDetail["vicinity"].string,
                "latitude"  : String(stringInterpolationSegment: self.shopDetail["lat"].double!),
                "longitude" : String(stringInterpolationSegment: self.shopDetail["lng"].double!),
                "types"     : typesLabel.text
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
                "shop_id" : self.shopDetail["id"].string!,
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
    
    func changeButtonColor() {
        var parameters = [
            "shop_id" : shopDetail["id"].string!
        ]
        var request = Const().URL_API + "/api/v1/shops/find_shop.json"
        
        Alamofire.request(.GET, request, parameters: parameters).responseJSON {
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
    
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

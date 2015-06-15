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
    
    
    
    var shopDetail : JSON = []
    var types : String?
    var imageUrl : String!
    
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
        
        println(self.shopDetail)
        var url = ""
        if self.shopDetail["photos"] != nil {
            url = shopDetail["place_id"].string!
            getShopImage(url)
        } else {
            mainImage.image = UIImage(named: "na_61_02")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 画像取得API
    func getShopImage(url: String){
        var request = "http://relamark.link/api/v1/spots/show.json"
        var parameters = [
            "place_id" : url,
        ]
        Alamofire.request(.GET, request, parameters: parameters).responseJSON
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
        var loginView = LoginViewController()
        var requestUrl = "http://localhost:3000/api/v1/shops.json"

        
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
                var alertController = UIAlertController(title: "Sucess", message: "Success", preferredStyle: UIAlertControllerStyle.Alert)
                var action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                alertController.addAction(action)
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                var alertController = UIAlertController(title: "Error", message: "Fail", preferredStyle: UIAlertControllerStyle.Alert)
                var action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                alertController.addAction(action)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        println(parameters)

    }
    
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

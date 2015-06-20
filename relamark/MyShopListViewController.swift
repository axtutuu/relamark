//
//  MyShopListViewController.swift
//  relamark
//
//  Created by mac on 2015/06/15.
//  Copyright (c) 2015年 AtsushiKawasaki. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyShopListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    // uidのメンバー読み込み
    var loginView = LoginViewController()
    
    //JSONレスポンス格納用
    var shopsDataArray : NSArray! = []
    
    var shopsDataJSON : JSON!
    
    // タップ時のデータ格納
    var shopDetail : JSON!


    // 背景カラーの調整
    var alpha = 0.3
    
    // menuボタンの生成 / サイズ指定
    var menuButton:UIButton! = UIButton(frame: CGRectMake(0, 0, 100, 100))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // テーブルビューdelegateの設定
        tableView.dataSource = self
        tableView.delegate = self

        // パラメータ/Url設定
        var requestUrl = Const().URL_API + "/api/v1/shops.json"
        var parameters = [
            "token" : "\(loginView.uid!)",
        ]
        
        Alamofire.request(.GET, requestUrl, parameters: parameters).responseJSON {
            (request, response, json, errors) in
            var shopsDic = json as! NSDictionary
            self.shopsDataArray = shopsDic["results"] as! NSArray
            self.shopsDataJSON = JSON(json!)
            println(self.shopsDataJSON)
            self.tableView.reloadData()
        }
        
        // ボタンの表示
        menuButton.layer.position = CGPoint(x: self.view.frame.width - 40, y: self.view.frame.height - 100)
        menuButton.setImage(UIImage(named: "menu.png"), forState: .Normal)
        menuButton.addTarget(self, action: "tappedMenuButton:", forControlEvents:.TouchUpInside)
        self.view.addSubview(menuButton)

    }
    
    
    //返却セル数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shopsDataArray.count
    }
    
    // セルの内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        // tagからメンバーの取得
        var icon = cell.viewWithTag(1) as! UIImageView
        var name = cell.viewWithTag(2) as! UILabel
        var types = cell.viewWithTag(3) as! UILabel
        
        // 値の挿入
        name.text = self.shopsDataJSON["results"][indexPath.row]["name"].string
        
        // URLから画像データの挿入
        var iconUrl = NSURL(string: self.shopsDataJSON["results"][indexPath.row]["icon_url"].string!)
        var iconData : NSData = NSData(contentsOfURL: iconUrl!)!
        icon.image = UIImage(data: iconData)
        icon.layer.cornerRadius = 3
        icon.layer.masksToBounds = true


        alpha += 0.1
        cell.backgroundColor = UIColor.hex("F32800", alpha: CGFloat(alpha))
        
        return cell
    }

    // セルの高さ
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    // セルタップ時のアクション
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.shopDetail = self.shopsDataJSON["results"][indexPath.row]
        
        // 遷移
        performSegueWithIdentifier("toMyShopDetailView", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // 遷移先のメンバ取得
        var myShopDetailView = segue.destinationViewController as! MyShopDetailViewController
        
        myShopDetailView.myShopData = self.shopDetail
    }
    
    func tappedMenuButton(sender: AnyObject) {
        let menuView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Menu") as! UIViewController;()
        menuView.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(menuView, animated: true, completion: nil)
        println("メニュータップ")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

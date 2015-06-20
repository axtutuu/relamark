//
//  MenuViewController.swift
//  relamark
//
//  Created by mac on 2015/06/15.
//  Copyright (c) 2015年 AtsushiKawasaki. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    // menuボタンの生成 / サイズ指定
    var menuButton:UIButton! = UIButton(frame: CGRectMake(0, 0, 100, 100))

    override func viewDidLoad() {
        super.viewDidLoad()

        // ボタンの表示
        menuButton.layer.position = CGPoint(x: self.view.frame.width - 40, y: self.view.frame.height - 100)
        menuButton.setImage(UIImage(named: "menu.png"), forState: .Normal)
        menuButton.addTarget(self, action: "tappedMenuButton:", forControlEvents:.TouchUpInside)
        self.view.addSubview(menuButton)
    }

    func tappedMenuButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tappedMapButton(sender: AnyObject) {
        let mapView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MapView") as! UIViewController;()
        
        self.presentViewController(mapView, animated: true, completion: nil)
    }
    

    @IBAction func tappedSignOut(sender: AnyObject) {

        // tokenの削除
        var login = LoginViewController()
        login.uid = nil

        // ログイン画面へ遷移
        let loginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login") as! UIViewController;()
        
        self.presentViewController(loginView, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

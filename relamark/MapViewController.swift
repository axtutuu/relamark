//
//  MapViewController.swift
//  relamark
//
//  Created by mac on 2015/05/26.
//  Copyright (c) 2015年 AtsushiKawasaki. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    // マップ
    @IBOutlet weak var mapView: MKMapView!
    
    // 現在地
    var myLocationManager:CLLocationManager!
    
    // 緯度表示用のラベル.
    var ido : Double = 0
    var kedo : Double = 0
    
    // menuボタンの生成 / サイズ指定
    var menuButton:UIButton! = UIButton(frame: CGRectMake(0, 0, 100, 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 現在地の取得
        myLocationManager = CLLocationManager()
        
        myLocationManager.delegate = self
        
        // セキュリティ認証ステータスを取得
        let status = CLLocationManager.authorizationStatus()
        
        // 認証が得られていない場合は、認証ダイアログを表示
        if(status == CLAuthorizationStatus.NotDetermined) {
            println("didChangeAuthorizationStatus:\(status)")
            // ダイアログの表示
            self.myLocationManager.requestAlwaysAuthorization()
        }
        
        // 取得精度の設定
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 取得頻度
        myLocationManager.distanceFilter = 100
        
        // 位置情報取得を開始
        myLocationManager.startUpdatingLocation()
        
        
        // マップの設定
        // マップにフレームサイズを設定
        self.mapView.delegate = self
        
        // ボタンの表示
        menuButton.layer.position = CGPoint(x: self.view.frame.width - 40, y: self.view.frame.height - 100)
        menuButton.setImage(UIImage(named: "button.png"), forState: .Normal)
        menuButton.addTarget(self, action: "tappedMenuButton:", forControlEvents:.TouchUpInside)
        self.view.addSubview(menuButton)
    }
    
    
    // 位置情報取得に成功したときに呼び出されるデリゲート.
    func locationManager(manager: CLLocationManager!,didUpdateLocations locations: [AnyObject]!){
        // 緯度・経度の表示.
        //        myLatitudeLabel.text = "緯度：\(manager.location.coordinate.latitude)"
        //        myLongitudeLabel.text = "経度：\(manager.location.coordinate.longitude)"
        ido = manager.location.coordinate.latitude
        kedo = manager.location.coordinate.longitude
        
        println("\n---------------------------\n")
        println("\(manager.location.coordinate.latitude)")
        println("\(manager.location.coordinate.longitude)")
        println("\n---------------------------\n")
        
        //初期位置を設定
        //経度、緯度からメルカトル図法の点に変換する
        var centerCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(ido, kedo)
        let span = MKCoordinateSpanMake(0.003, 0.003) //小さい値であるほど近づく
        //任意の場所を表示する場合、MKCoordinateRegionを使って表示する -> (中心位置、表示領域)
        var centerPosition = MKCoordinateRegionMake(centerCoordinate, span)
        self.mapView.setRegion(centerPosition,animated:true)
        
        // ピンを生成
        var myPin : MKPointAnnotation = MKPointAnnotation()
        
        // ピンの座標を指定
        myPin.coordinate = centerCoordinate
        
        // タイトル
        myPin.title = "ほれ〜〜"
        
        // サブタイトル
        myPin.subtitle = "おらおら〜〜"
        
        // ピンの追加
        mapView.addAnnotation(myPin)
    }
    
    
    
    // 位置情報取得に失敗した時に呼び出されるデリゲート.
    func locationManager(manager: CLLocationManager!,didFailWithError error: NSError!){
        print("error")
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 遷移時にデータの受け渡し
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var svc = segue.destinationViewController as! ShopsViewController
        svc.lat = ido
        svc.lon = kedo
    }
    
    @IBAction func tappedMenuButton(sender: AnyObject) {
//        var menu : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("Menu")
//        self.presentViewController(menu as! UIViewController, animated: true, completion: nil)
        let menuView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Menu") as! UIViewController;()
        menuView.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController(menuView, animated: true, completion: nil)
        println("メニュータップ")
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

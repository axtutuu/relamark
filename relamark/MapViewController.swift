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
    var mapView : MKMapView = MKMapView()
    
    // 現在地
    var myLocationManager:CLLocationManager!

    // 緯度表示用のラベル.
    var ido : Double = 0
    var kedo : Double = 0
    
    
    
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
        self.mapView.frame = CGRectMake(0, 20, view.bounds.size.width, view.bounds.size.height)
        self.mapView.delegate = self
        self.view.addSubview(mapView)
        
        
        //初期位置を設定
        //経度、緯度からメルカトル図法の点に変換する
        var centerCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(ido, kedo)
        let span = MKCoordinateSpanMake(0.003, 0.003) //小さい値であるほど近づく
        //任意の場所を表示する場合、MKCoordinateRegionを使って表示する -> (中心位置、表示領域)
        var centerPosition = MKCoordinateRegionMake(centerCoordinate, span)
        self.mapView.setRegion(centerPosition,animated:true)
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
        
        // もう一回マップを呼ぶ
        var centerCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(ido, kedo)
        let span = MKCoordinateSpanMake(0.003, 0.003) //小さい値であるほど近づく
        //任意の場所を表示する場合、MKCoordinateRegionを使って表示する -> (中心位置、表示領域)
        var centerPosition = MKCoordinateRegionMake(centerCoordinate, span)
        self.mapView.setRegion(centerPosition,animated:true)
    }
    
    
    
    // 位置情報取得に失敗した時に呼び出されるデリゲート.
    func locationManager(manager: CLLocationManager!,didFailWithError error: NSError!){
        print("error")
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

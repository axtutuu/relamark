import UIKit
import Alamofire
import SwiftyJSON

class LaunchViewController: UIViewController {
    
    let loginView = LoginViewController()
    
    // ログイン判定の値
    var authResult : Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {

        // uid取得
        if (loginView.uid != nil) {
            var parameters = [
                "token" : "\(loginView.uid!)"
            ]
            
            var requestUrl = Const().URL_API + "/api/v1/users/token_auth.json"
            Alamofire.request(.POST, requestUrl, parameters: parameters).responseJSON {
                (request, response, json, error) in
                var jsonResult : JSON = JSON(json!)
                println(json)
                println(jsonResult["results"]["status"].intValue)
                self.authResult = jsonResult["results"]["status"].intValue
                println(self.authResult)
                
                // 画面遷移判定
                if self.authResult! == 1 {
                    self.toMapView()
                } else {
                    self.toLoginView()
                }

            }
        } else {
            self.toLoginView()
        }
        
    }

    // ログイン画面への遷移
    func toLoginView() {
        let loginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login") as! UIViewController;()
        self.presentViewController(loginView, animated: true, completion: nil)
    }
    
    // Mapへの遷移
    func toMapView() {
        let mapView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MapView") as! UIViewController;()
        self.presentViewController(mapView, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
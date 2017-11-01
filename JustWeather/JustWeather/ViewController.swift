//
//  ViewController.swift
//  JustWeather
//
//  Created by 许吉中 on 2017/10/17.
//  Copyright © 2017年 xujizhong. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController , CLLocationManagerDelegate{
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var describtion: UILabel!
    @IBOutlet weak var lastUpdate: UILabel!
    @IBOutlet weak var errorMassage: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    let locationManager : CLLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.contents = UIImage(named: "bg.jpeg")?.cgImage
//        let background = UIImage(named:"background.jpeg")
//        self.view.backgroundColor = UIColor(patternImage : background!)
        
        //设置定位服务管理器代理
        locationManager.delegate = self
        //设置定位进度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //更新距离
        locationManager.distanceFilter = 100
        ////发送授权申请
        locationManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled())
        {
            //允许使用定位服务的话，开启定位服务更新
            locationManager.startUpdatingLocation()
        }else{
            self.errorMassage.text = "请打开您的定位服务"
        }
    }
   
    //定位改变执行，可以得到新位置、旧位置
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //获取最新的坐标
        let currLocation:CLLocation = locations.last!
        
        let lat = currLocation.coordinate.latitude
        let lon = currLocation.coordinate.longitude
        
        let weatherUrl = "https://api.seniverse.com/v3/weather/now.json?key=epk9vltm4rs01rl7&location=\(lat):\(lon)"
        
        Alamofire.request(weatherUrl, method: .get).responseJSON {
            response in
            
            guard let jsonData = response.result.value else { return }
            
            let weatherData = JSON(jsonData)["results"][0]
            //获取城市名称
            let name = weatherData["location"]["name"].stringValue
            //获取天气描述
            let describtion = weatherData["now"]["text"].stringValue
            //获取天气温度
            let temperature = weatherData["now"]["temperature"].stringValue
            //获取天气图标
            let icon = weatherData["now"]["code"].stringValue
            //获取最后更新时间
            let last_update = weatherData["last_update"].stringValue
            let timeIndex = last_update.index(of: "+")
            let Tindex = last_update.index(of: "T")
            var lastUpdate = last_update[..<timeIndex!].description
            lastUpdate.remove(at: Tindex!)
            lastUpdate.insert(" ", at: Tindex!)
            
            self.cityName.text = name
            self.describtion.text = describtion
            self.temperature.text = "\(temperature)°C"
            self.lastUpdate.text = "天气信息更新时间：\(lastUpdate)"
            self.weatherImage.image = UIImage(named:icon)
            
        }
        
        locationManager.stopUpdatingLocation()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


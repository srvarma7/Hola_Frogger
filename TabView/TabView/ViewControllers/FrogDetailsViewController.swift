//
//  FrogDetailsViewController.swift
//  TabView
//
//  Created by Varma on 14/04/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import MapKit

struct WeatherJsonResponse: Codable {
    let name: String
    let id: Int
    let weather: [Weather]
    let main: TempPressure
}

struct Weather: Codable {
    let description: String
    let icon: String
}

struct TempPressure: Codable {
    let temp: Double
    let pressure: Double
    let humidity: Int
}

class FrogDetailsViewController: UIViewController, MKMapViewDelegate {

    
    
    @IBOutlet weak var wLocName: UILabel!
    @IBOutlet weak var wTemp: UILabel!
    @IBOutlet weak var wCondition: UILabel!
    @IBOutlet weak var wHumidity: UILabel!
    @IBOutlet weak var wHumidityLabel: UILabel!
    @IBOutlet weak var wImage: UIImageView!
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var comNameLbl: UILabel!
    @IBOutlet weak var scNameLbl: UILabel!
    @IBOutlet weak var descLbl: UITextView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    
    var receivedFrog: FrogEntity?
    
    
    var lat: Double = 0
    var long: Double = 0
    let favButton = UIButton()
    let closeButton = UIButton()
    var localIsFav: Bool = false
    var focusLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 1000, longitudinalMeters: 1000)
    var annotaion = FrogAnnotation(title: "", subtitle: "", latitude: 0, longitude: 0)
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromUrl()
        
        mapView.delegate = self
        // When the Map is loaded the Map will focus to the following location.
        annotaion = FrogAnnotation(title: receivedFrog!.cname!, subtitle: receivedFrog!.sname!, latitude: receivedFrog!.latitude, longitude: receivedFrog!.longitude)
        // Do any additional setup after loading the view.
        comNameLbl.text = receivedFrog?.cname
        scNameLbl.text = receivedFrog?.sname
        descLbl.text = receivedFrog?.desc
        descLbl.isEditable = false
        locationLbl.text = "\(String(describing: receivedFrog!.uncertainty)) meters"
        statusLbl.text = receivedFrog?.threatnedStatus
        countLbl.text = "\(String(describing: receivedFrog!.frogcount))"
        favButton.frame = CGRect(x: self.view.center.x - 10, y: self.view.center.y - 240, width: 30, height: 30)
        favButton.center.x = view.center.x
        closeButton.frame = CGRect(x: view.center.x, y: view.frame.maxY + 30, width: 50, height: 50)
        closeButton.center.x = view.center.x
        closeButton.setBackgroundImage(UIImage(systemName: "xmark.circle.fill"), for: UIControl.State.normal)
        closeButton.tintColor = UIColor.red
        localIsFav = receivedFrog!.isFavourite
        if localIsFav {
            favButton.setBackgroundImage(UIImage(systemName: "suit.heart.fill"), for: UIControl.State.normal)
        } else {
            favButton.setBackgroundImage(UIImage(systemName: "suit.heart"), for: UIControl.State.normal)
        }
        favButton.addTarget(self, action: #selector(favButtonAction), for: .touchUpInside)
        self.view.addSubview(favButton)
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        self.view.addSubview(closeButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIView.animate(withDuration: 1, delay: 0.3, animations: {
            self.focusLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self.receivedFrog!.latitude, longitude: self.receivedFrog!.longitude), latitudinalMeters: 1000, longitudinalMeters: 1000)
            self.mapView.setRegion(self.focusLocation, animated: true)
            self.mapView.addAnnotation(self.annotaion)
            self.closeButton.transform = CGAffineTransform(translationX: 0, y: -230)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)

    }
    
    @objc func closeButtonAction(sender: UIButton!) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        dismiss(animated: true)
    }
    
    @objc func favButtonAction(sender: UIButton!) {
        localIsFav.toggle()
        if localIsFav {
            favButton.setBackgroundImage(UIImage(systemName: "suit.heart.fill"), for: UIControl.State.normal)
        } else {
            favButton.setBackgroundImage(UIImage(systemName: "suit.heart"), for: UIControl.State.normal)
        }
        CoreDataHandler.updateFrog(frog: receivedFrog!, isVisited: receivedFrog!.isVisited, isFavourite: localIsFav)
    }
    
    // MARK: - Weather
    //Gets data and parses the JSON data into usable data
    func getDataFromUrl() {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(receivedFrog!.latitude)&lon=\(receivedFrog!.longitude)&appid=3af463d5d4d7916e155dd605e37db688")
        URLSession.shared.dataTask(with: url!) { data, _, _ in
            if let data = data {
                let resp = try? JSONDecoder().decode(WeatherJsonResponse.self, from: data)
                DispatchQueue.main.async {
                    let d: Double = round((resp?.main.temp)!)
                    let intTemp = Int(d)
                    let tempInCelsius = String(format: "%i", intTemp - 273) + " °C"
                    self.wTemp.text = tempInCelsius
                    self.wLocName.text = resp?.name
                    self.wCondition.text = resp?.weather[0].description
                    let humidityText = "\(resp?.main.humidity ?? 87)"
                    self.wHumidity.text = humidityText
                    self.makeGetRequestImage(icon: (resp?.weather[0].icon)!)
                }
            }
        }.resume()
    }
    
    //From Apple docs
    //Gets image data from the API and sets the icon into image view for location's weather
    func makeGetRequestImage(icon: String){
        let url : String = "https://openweathermap.org/img/wn/" + icon + "@2x.png"
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = NSURL(string: url) as URL?
        request.httpMethod = "GET"
        request.timeoutInterval = 60
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue(), completionHandler:{ (response:URLResponse!, data: Data!, error: Error!) -> Void in
            DispatchQueue.main.async {
                self.wImage.backgroundColor = .clear
                self.wImage.image = UIImage(data: data)
                
            }
        })
    }
}

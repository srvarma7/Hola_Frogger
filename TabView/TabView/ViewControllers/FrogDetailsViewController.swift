//
//  FrogDetailsViewController.swift
//  TabView
//
//  Created by Varma on 14/04/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import MapKit

// Structure to hold API response
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

    // UI outlets
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

    @IBOutlet weak var frogImage: UIImageView!
    
    // Variable will hold the data that is sent by other controller.
    var receivedFrog: FrogEntity?
    
    // Variables to hold data
    var lat: Double = 0
    var long: Double = 0
    let favButton = UIButton()
    let closeButton = UIButton()
    var localIsFav: Bool = false
    // Used to show the foucs loation on map
    var focusLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 1000, longitudinalMeters: 1000)
    var annotaion = FrogAnnotation(title: "", subtitle: "", latitude: 0, longitude: 0)
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // When this controller is loaded, Weather data is being gathered.
        getDataFromUrl()
        mapView.delegate = self
        // When the Map is loaded the Map will focus to the below location and puts the annotation marker.
        annotaion = FrogAnnotation(title: receivedFrog!.cname!, subtitle: receivedFrog!.sname!, latitude: receivedFrog!.latitude, longitude: receivedFrog!.longitude)
        // Setting the text to text label holders.
        comNameLbl.text = receivedFrog?.cname
        scNameLbl.text = receivedFrog?.sname
        descLbl.text = receivedFrog?.desc
        descLbl.isEditable = false
        frogImage.image = UIImage(named:"\(String(receivedFrog!.sname!))")
        
        locationLbl.text = "\(String(describing: receivedFrog!.uncertainty)) meters"
        statusLbl.text = receivedFrog?.threatnedStatus
        countLbl.text = "\(String(describing: receivedFrog!.frogcount))"
        // This button is be used to Favourite or Unfavourite a Frog.
        favButton.frame = CGRect(x: self.view.center.x-15, y: self.view.center.y + 260, width: 30, height: 30)
       // favButton.center.x = view.center.x
        // To dismiss the current view controller
        closeButton.frame = CGRect(x: view.center.x, y: view.frame.maxY + 30, width: 50, height: 50)
        closeButton.center.x = view.center.x
        closeButton.setBackgroundImage(UIImage(systemName: "xmark.circle.fill"), for: UIControl.State.normal)
        closeButton.tintColor = UIColor.red
        localIsFav = receivedFrog!.isFavourite
        // Checking the Favourite status to set the Logo of the button
        if localIsFav {
            favButton.setBackgroundImage(UIImage(systemName: "suit.heart.fill"), for: UIControl.State.normal)
            favButton.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        } else {
            favButton.setBackgroundImage(UIImage(systemName: "suit.heart"), for: UIControl.State.normal)
            favButton.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        }
        // Tap action methods
        favButton.addTarget(self, action: #selector(favButtonAction), for: .touchUpInside)
        self.view.addSubview(favButton)
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        self.view.addSubview(closeButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // When the Map is loaded, the Map will focus to the below location and puts the annotation marker.
        UIView.animate(withDuration: 0.5, delay: 0.3, animations: {
            self.focusLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self.receivedFrog!.latitude, longitude: self.receivedFrog!.longitude), latitudinalMeters: 1000, longitudinalMeters: 1000)
            self.mapView.setRegion(self.focusLocation, animated: true)
            self.mapView.addAnnotation(self.annotaion)
            self.closeButton.transform = CGAffineTransform(translationX: 0, y: -170)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Sends a notification to the Frog list controller to reload the tableview controller.
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    @objc func closeButtonAction(sender: UIButton!) {
        // Sends a notification to the Frog list controller to reload the tableview controller.
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        // Dismisses the current controller.
        dismiss(animated: true)
    }
    
    // Action method when tapped on fav button.
    @objc func favButtonAction(sender: UIButton!) {
        localIsFav.toggle()
        // Changes the logo when tapped on it.
        if localIsFav {
            favButton.setBackgroundImage(UIImage(systemName: "suit.heart.fill"), for: UIControl.State.normal)
            favButton.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        } else {
            favButton.setBackgroundImage(UIImage(systemName: "suit.heart"), for: UIControl.State.normal)
            favButton.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        }
        // Updates the fav status of a frog in database.
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
                    // Invokes method to get Weather image.
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

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
}

class FrogDetailsViewController: UIViewController, MKMapViewDelegate {

    
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
    //var apiurl = "https://api.openweathermap.org/data/2.5/weather?lat="+lat+"&lon="+long+"&appid=3af463d5d4d7916e155dd605e37db688"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let focusLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: receivedFrog!.latitude, longitude: receivedFrog!.longitude), latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.delegate = self
        // When the Map is loaded the Map will focus to the following location.
        mapView.setRegion(focusLocation, animated: true)
        let annotaion = FrogAnnotation(title: receivedFrog!.cname!, subtitle: receivedFrog!.sname!, latitude: receivedFrog!.latitude, longitude: receivedFrog!.longitude)
        mapView.addAnnotation(annotaion)
        // Do any additional setup after loading the view.
        comNameLbl.text = receivedFrog?.cname
        scNameLbl.text = receivedFrog?.sname
        descLbl.text = receivedFrog?.desc
        locationLbl.text = "\(String(describing: receivedFrog!.uncertainty))"
        statusLbl.text = receivedFrog?.threatnedStatus
        countLbl.text = "\(String(describing: receivedFrog!.frogcount))"
    }

    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func favBtnClicked(_ sender: Any) {
        getDataFromUrl()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Gets data and parses the JSON data into usable data
    func getDataFromUrl() {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(receivedFrog!.latitude)&lon=\(receivedFrog!.longitude)&appid=3af463d5d4d7916e155dd605e37db688")
        URLSession.shared.dataTask(with: url!) { data, _, _ in
            if let data = data {
                let resp = try? JSONDecoder().decode(WeatherJsonResponse.self, from: data)
                DispatchQueue.main.async {
                    let d: Double = round((resp?.main.temp)!)
                    let intTemp = Int(d)
                    print(String(format: "%i", intTemp - 273) + " °C")
                    //self.makeGetRequestImage(icon: (resp?.weather[0].icon)!)
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
//                self.apiIcon.backgroundColor = .clear
//                self.apiIcon.image = UIImage(data: data)
                
            }
        })
    }
}

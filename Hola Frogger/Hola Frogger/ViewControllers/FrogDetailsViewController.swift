//
//  FrogDetailsViewController.swift
//  TabView
//
//  Created by Varma on 14/04/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import MapKit
import AwesomeSpotlightView
import QuickLook
import ARKit



class FrogDetailsViewController: UIViewController, MKMapViewDelegate, AwesomeSpotlightViewDelegate, QLPreviewControllerDataSource {

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
    @IBOutlet weak var isVisitedLbl: UILabel!
    
    var spotlight: [SpotLightEntity] = []
    var spotlightView = AwesomeSpotlightView()
    var fromListScreen: Bool = false
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
        
        if receivedFrog!.sname == "Litoria paraewingi" {
           frogImage.image = UIImage(named: "frogsplash")
        } else {
            frogImage.image = UIImage(named:"\(String(receivedFrog!.sname!))")
        }
        frogImage.image = UIImage(named:"\(String(receivedFrog!.sname!))")
        if traitCollection.userInterfaceStyle == .light {
            frogImage.layer.shadowColor = UIColor.black.cgColor
        } else {
            frogImage.layer.shadowColor = UIColor.white.cgColor
        }
        frogImage.layer.shadowOffset = CGSize(width: 4, height: 4)
        frogImage.layer.shadowRadius = 4.0
        frogImage.layer.shadowOpacity = 1
        frogImage.clipsToBounds = true
        locationLbl.text = "\(String(describing: receivedFrog!.uncertainty)) meters"
        statusLbl.text = receivedFrog?.threatnedStatus
        countLbl.text = "\(String(describing: receivedFrog!.frogcount))"
        if receivedFrog!.isVisited {
            isVisitedLbl.text = "Yes"
        } else {
            isVisitedLbl.text = "No"
        }
        
        // This button is be used to Favourite or Unfavourite a Frog.
        favButton.frame = CGRect(x: self.view.center.x-20, y: isVisitedLbl.frame.maxY + 10, width: 50, height: 50)
        
        favButton.center = frogImage.center
        favButton.center.x = frogImage.center.x + 150
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
        checkForSpotLight()
        // MARK:- AR
        // Frog image tapped
        //frogImage.addTarget(self, action: #selector(frogImageDidTapped), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedMe))
        frogImage.addGestureRecognizer(tap)
        frogImage.isUserInteractionEnabled = true
    }
    
    @objc func tappedMe()
    {
        print("Tapped")
        if isSimulator {
            displayMessage(title: "Alert!", message: "Augmented Reality is not avaliable on simulators!!!.\nTo experiance AR, please open this feature on a AR supported device")
        } else {
            let previewController = QLPreviewController()
            previewController.dataSource = self
            present(previewController, animated: true, completion: nil)
        }
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int { return 1 }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        //guard let path = Bundle.main.path(forResource: "FrogCartoon", ofType: "usdz") else { fatalError("Couldn't find the supported input file.") }
        //guard let path = Bundle.main.path(forResource: "Frog_Hopping", ofType: "usdz") else { fatalError("Couldn't find the supported input file.") }
        //guard let path = Bundle.main.path(forResource: "DartFrog", ofType: "obj") else { fatalError("Couldn't find the supported input file.") }
        //guard let path = Bundle.main.path(forResource: "toy_biplane", ofType: "usdz") else { fatalError("Couldn't find the supported input file.") }
        guard let path = Bundle.main.path(forResource: "FrogScaledUsdz", ofType: "usdz") else { fatalError("Couldn't find the supported input file.") }
        let url = URL(fileURLWithPath: path)
        return url as QLPreviewItem
    }
    
    func checkForSpotLight() {
        if spotlight.isEmpty {
            CoreDataHandler.addSpotLight()
            spotlight = CoreDataHandler.fetchSpotLight()
        }
        if !(spotlight.first!.frogdetails) {
            startSpotLightTour()
        }
    }
    
    func startSpotLightTour() {
        let screenSize: CGRect = UIScreen.main.bounds
        var spotlight1 = AwesomeSpotlight()
        var spotlight2 = AwesomeSpotlight()
        var spotlight5 = AwesomeSpotlight()
        var properDevice = false
        print(screenSize.width)
        if screenSize.width == 414.0 {
            // Spotlight for Image
            spotlight1 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 162, y: 122, width: 90, height: 90), shape: .circle, text: "\n\nFrog's geographical location", isAllowPassTouchesThroughSpotlight: false)
            
            // Spotlight for Frog's Common Name
            spotlight2 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY+8, y: 5, width: 400, height: 85), shape: .roundRectangle, text: "Weather conditions at frog's location", isAllowPassTouchesThroughSpotlight: false)
            
            // Spotlight for Filter by Favourite
            spotlight5 = AwesomeSpotlight(withRect: CGRect(x: frogImage.center.x + 120, y: frogImage.center.y - 30, width: 60, height: 60), shape: .circle, text: "Make favourite or unfavourite", isAllowPassTouchesThroughSpotlight: false)
            properDevice = true
        } else if screenSize.width == 375.0 {
            // Spotlight for Image
            spotlight1 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 140, y: 115, width: 90, height: 90), shape: .circle, text: "\n\nFrog's geographical location", isAllowPassTouchesThroughSpotlight: false)
            
            // Spotlight for Frog's Common Name
            spotlight2 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY+8, y: 5, width: 360, height: 75), shape: .roundRectangle, text: "Weather conditions at frog's location", isAllowPassTouchesThroughSpotlight: false)
            
            // Spotlight for Favourite
            spotlight5 = AwesomeSpotlight(withRect: CGRect(x: frogImage.center.x + 120, y: frogImage.center.y - 30, width: 60, height: 60), shape: .circle, text: "Make favourite or unfavourite", isAllowPassTouchesThroughSpotlight: false)
            properDevice = true
        }
        if properDevice {
            // Load spotlights
            let spotlightView = AwesomeSpotlightView(frame: view.frame, spotlight: [spotlight1, spotlight2, spotlight5])
            spotlightView.cutoutRadius = 8
            spotlightView.delegate = self
            view.addSubview(spotlightView)
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                if self.traitCollection.userInterfaceStyle == .light {
                    spotlightView.spotlightMaskColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
                } else {
                    spotlightView.spotlightMaskColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
                }
                spotlightView.enableArrowDown = true
                spotlightView.start()
            }
            CoreDataHandler.updateSpotLight(attribute: "frogdetails", boolean: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // When the Map is loaded, the Map will focus to the below location and puts the annotation marker.
        UIView.animate(withDuration: 0.5, delay: 0.3, animations: {
            self.focusLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self.receivedFrog!.latitude, longitude: self.receivedFrog!.longitude), latitudinalMeters: 1000, longitudinalMeters: 1000)
            self.mapView.setRegion(self.focusLocation, animated: true)
            self.mapView.addAnnotation(self.annotaion)
            let screenSize: CGRect = UIScreen.main.bounds
            if screenSize.width == 375.0 {
                self.closeButton.transform = CGAffineTransform(translationX: 0, y: -155)
            } else {
                self.closeButton.transform = CGAffineTransform(translationX: 0, y: -180)
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Sends a notification to the Frog list controller to reload the tableview controller.
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTableView"), object: nil)
    }
    
    @objc func closeButtonAction(sender: UIButton!) {
        // Sends a notification to the Frog list controller to reload the tableview controller.
        if fromListScreen {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTableView"), object: nil)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadColllectionView"), object: nil)
        }
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
    
    //To display messages to the user as an alert
    func displayMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// Method to identify the device type
/// Author "mbelsky"
/// Reference link - https://stackoverflow.com/questions/24869481/how-to-detect-if-app-is-being-built-for-device-or-simulator-in-swift
extension FrogDetailsViewController {
    var isSimulator: Bool {
        #if arch(i386) || arch(x86_64)
            return true
        #else
            return false
        #endif
    }
}

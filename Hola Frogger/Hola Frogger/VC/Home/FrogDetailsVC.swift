//
//  FrogDetailsVC.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 14/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import MapKit

class FrogDetailsVC: UIViewController {
        
    // Header view
    private var weatherView             = UIView()
    private var locationLabel           = UILabel()
    private var temperatureLabel        = UILabel()
    private var temperatureStatusLabel  = UILabel()
    private var temperatureImageView    = UIImageView()
    private var humidityLabel           = UILabel()
    private var humidityStatusLabel     = UILabel()
    
    // Middle
    private var mapView = MKMapView()
    
    // Body
    private var frogImageView           = UIImageView()
    private var favouriteButton         = UIButton()
    private var frogCommonNameLabel     = UILabel()
    private var frogScientificNameLabel = UILabel()
    private var descriptionHeading      = UILabel()
    private var frogDetailsLabel        = UILabel()
    
    private var locationUncertaintyHeading  = UILabel()
    private var locationUncertaintyLabel    = UILabel()
    private var threatenedHeading           = UILabel()
    private var threatenedLabel             = UILabel()
    private var frogCountHeading            = UILabel()
    private var frogCountLabel              = UILabel()
    private var sightedHeading              = UILabel()
    private var sightedLabel                = UILabel()
    
    // Foot
    private var closeButton = UIButton()
    
    // Varibles
    var frogDetailsViewModel = FrogDetailsViewModel()
    var frogItem: FrogEntity?
    var favouriteStatus: Bool = false

    private let screen = UIScreen.main.bounds
    
    // Main
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        addViews()
        
        setFrogDetails()
        setFrogAnnotationOnMap()
        closeButton.transform = CGAffineTransform(translationX: 0, y: 100)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animateCloseButton()
        SpotLight.showForDetails(view: view, vc: self)
    }
    
    private func animateCloseButton() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.25,
                       options: .curveEaseInOut,
                       animations: {
                        self.closeButton.transform = CGAffineTransform(translationX: 0, y: -25)
                       })
    }
    
    private func setFrogDetails() {
        if let frogData = frogItem {
            
            frogCommonNameLabel.text        = frogData.cname
            frogScientificNameLabel.text    = frogData.sname
            frogDetailsLabel.text           = frogData.desc
            locationUncertaintyLabel.text   = "\(frogData.uncertainty)"
            threatenedLabel.text            = frogData.threatnedStatus
            frogCountLabel.text             = "\(frogData.frogcount)"
            sightedLabel.text               = frogData.isVisited ? "Yes" : "No"
            frogImageView.image             = UIImage(named: frogData.sname!)
            favouriteStatus                 = frogData.isFavourite
            frogImageView.backgroundColor   = .clear
            favouriteButton.setBackgroundImage(UIImage(systemName: favouriteStatus ? "suit.heart.fill" : "suit.heart"), for: UIControl.State.normal)

            frogDetailsViewModel.weatherDelegate = self
            let latLonInString = convertLatLonToString(latitude: frogData.latitude, longitude: frogData.longitude)
            fetchWeather(latitude: latLonInString.0, longitude: latLonInString.1)
        }
    }
    
}

// MARK:- Add views and constriants
extension FrogDetailsVC: MKMapViewDelegate {
    private func setFrogAnnotationOnMap() {
        mapView.delegate = self
        let focusLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self.frogItem!.latitude,
                                                                              longitude: self.frogItem!.longitude),
                                               latitudinalMeters: 1000,
                                               longitudinalMeters: 1000)
        
        
        
        mapView.setRegion(focusLocation, animated: true)
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        let annotaion = FrogAnnotation(title: frogItem!.cname!,
                                       subtitle: frogItem!.sname!,
                                       latitude: frogItem!.latitude,
                                       longitude: frogItem!.longitude)
        mapView.addAnnotation(annotaion)
    }
    
}

// MARK:- Add views and constriants
extension FrogDetailsVC {
    
    private func addViews() {
//        let safeArea = view.safeAreaLayoutGuide
        addHeaderViews()
        
        view.addSubview(mapView)
        addMapViewConstriants()

        addBodyViews()
//
        addFootView()
    }
    
    // MARK:- Header views
    fileprivate func addHeaderViews() {
        view.addSubview(weatherView)
        addWeatherViewConstriants()
        
        weatherView.addSubview(locationLabel)
        addLocationLabelConstriants()
        
        weatherView.addSubview(temperatureImageView)
        addTempImageViewConstriants()
        
        weatherView.addSubview(temperatureLabel)
        addTemperatureLabelConstriants()
        
        weatherView.addSubview(humidityLabel)
        addHumidityLabelConstriants()
        
        weatherView.addSubview(temperatureStatusLabel)
        weatherView.addSubview(humidityStatusLabel)
        addStatusConstriants()
    }
    
    private func addWeatherViewConstriants() {
        weatherView.addAnchor(top: view.topAnchor, paddingTop: 0,
                              left: view.leftAnchor, paddingLeft: 0,
                              bottom: nil, paddingBottom: 0,
                              right: view.rightAnchor, paddingRight: 0,
                              width: view.frame.width, height: 65, enableInsets: true)
        
        weatherView.backgroundColor = .raspberryPieTint()
    }
    
    private func addLocationLabelConstriants() {
        locationLabel.addAnchor(top: weatherView.topAnchor, paddingTop: 3,
                                left: nil, paddingLeft: 0,
                                bottom: nil, paddingBottom: 0,
                                right: nil, paddingRight: 0,
                                width: 0, height: 0,
                                enableInsets: true)
        
        locationLabel.centerXAnchor.constraint(equalTo: weatherView.centerXAnchor).isActive = true
        locationLabel.text      = "Location name"
        locationLabel.font      = UIFont.systemFont(ofSize: 18, weight: .bold)
        locationLabel.textColor = .white
    }
    
    private func addTempImageViewConstriants() {
        temperatureImageView.addAnchor(top: nil, paddingTop: 0,
                                       left: nil, paddingLeft: 0,
                                       bottom: weatherView.bottomAnchor, paddingBottom: -8,
                                       right: nil, paddingRight: 0,
                                       width: 60, height: 60,
                                       enableInsets: true)
        
        temperatureImageView.centerXAnchor.constraint(equalTo: weatherView.centerXAnchor).isActive = true
    }

    private func addTemperatureLabelConstriants() {
        temperatureLabel.addAnchor(top: locationLabel.bottomAnchor, paddingTop: -5,
                                   left: weatherView.leftAnchor, paddingLeft: 20,
                                   bottom: nil, paddingBottom: 0,
                                   right: temperatureImageView.leftAnchor, paddingRight: 20,
                                   width: 0, height: 0,
                                   enableInsets: true)
        
        temperatureLabel.text           = "30 C"
        temperatureLabel.textAlignment  = .center
        temperatureLabel.font           = UIFont.systemFont(ofSize: 17, weight: .medium)
        temperatureLabel.textColor      = .white
    }
    
    private func addHumidityLabelConstriants() {
        humidityLabel.addAnchor(top: locationLabel.bottomAnchor, paddingTop: -5,
                                left: temperatureImageView.rightAnchor, paddingLeft: 20,
                                bottom: nil, paddingBottom: 0,
                                right: weatherView.rightAnchor, paddingRight: 20,
                                width: 0, height: 0,
                                enableInsets: true)
        
        humidityLabel.text          = "00"
        humidityLabel.textAlignment = .center
        humidityLabel.font          = UIFont.systemFont(ofSize: 17, weight: .medium)
        humidityLabel.textColor     = .white
    }
    
    
    private func addStatusConstriants() {
        temperatureStatusLabel.addAnchor(top: temperatureLabel.bottomAnchor, paddingTop: 0,
                                         left: weatherView.leftAnchor, paddingLeft: 20,
                                         bottom: nil, paddingBottom: 0,
                                         right: temperatureImageView.leftAnchor, paddingRight: 20,
                                         width: 0, height: 0,
                                         enableInsets: true)
        
        temperatureStatusLabel.text             = "Description"
        temperatureStatusLabel.textAlignment    = .center
        temperatureStatusLabel.textColor        = .white
        temperatureStatusLabel.font             = UIFont.systemFont(ofSize: 16, weight: .light)

        
        humidityStatusLabel.addAnchor(top: humidityLabel.bottomAnchor, paddingTop: 0,
                                      left: temperatureImageView.rightAnchor, paddingLeft: 20,
                                      bottom: nil, paddingBottom: 0,
                                      right: weatherView.rightAnchor, paddingRight: 20,
                                      width: 0, height: 0,
                                      enableInsets: true)
        
        humidityStatusLabel.text            = "Humidity"
        humidityStatusLabel.textAlignment   = .center
        humidityStatusLabel.textColor       = .white
        humidityStatusLabel.font            = UIFont.systemFont(ofSize: 16,
                                                                weight: .light)
    }
    
    // MARK:- Map view
    private func addMapViewConstriants() {
        mapView.addAnchor(top: weatherView.bottomAnchor, paddingTop: 0,
                          left: view.leftAnchor, paddingLeft: 0,
                          bottom: nil, paddingBottom: 0,
                          right: view.rightAnchor, paddingRight: 0,
                          width: 0, height: screen.height * 0.25,
                          enableInsets: true)
    }
    
    // MARK:- Body views
    private func addBodyViews() {
        let leftRightPadding: CGFloat   = 15
        let sectionPadding: CGFloat     = 6
        let bodyPadding: CGFloat        = 1
        let fontBodySize: CGFloat = 18
        let fontSubBodySize: CGFloat = 16
        
        view.addSubViews(views: frogImageView, favouriteButton,
                               frogCommonNameLabel, frogScientificNameLabel,
                               descriptionHeading, frogDetailsLabel,
                               locationUncertaintyHeading, locationUncertaintyLabel,
                               threatenedHeading, threatenedLabel,
                               frogCountHeading, frogCountLabel,
                               sightedHeading, sightedLabel)
        
        frogImageView.addAnchor(top: mapView.bottomAnchor, paddingTop: -((screen.width * 0.30)/2),
                                left: nil, paddingLeft: 0,
                                bottom: nil, paddingBottom: 0,
                                right: nil, paddingRight: 0,
                                width: screen.width * 0.30, height: screen.width * 0.30, enableInsets: true)
        
        frogImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(frogImageDidTapped))
        frogImageView.addGestureRecognizer(tap)
        frogImageView.isUserInteractionEnabled = true
        
        favouriteButton.addAnchor(top: mapView.bottomAnchor, paddingTop: -20,
                                  left: nil, paddingLeft: 0,
                                  bottom: nil, paddingBottom: 0,
                                  right: view.rightAnchor, paddingRight: 20,
                                  width: 40, height: 40, enableInsets: true)
        favouriteButton.setBackgroundImage(UIImage(systemName: "suit.heart.fill"), for: UIControl.State.normal)
        favouriteButton.tintColor = .raspberryPieTint()
        // Adding tap gesture action
        favouriteButton.addTarget(self, action: #selector(favouriteButtonDidTapped), for: .touchUpInside)
        
        frogCommonNameLabel.addAnchor(top: frogImageView.bottomAnchor, paddingTop: -10,
                                      left: nil, paddingLeft: 0,
                                      bottom: nil, paddingBottom: 0,
                                      right: nil, paddingRight: 0,
                                      width: 0, height: 0, enableInsets: true)
        frogCommonNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        frogCommonNameLabel.text = "frog Common Name Label"
        frogCommonNameLabel.font = UIFont.systemFont(ofSize: fontBodySize, weight: .bold)

        
        frogScientificNameLabel.addAnchor(top: frogCommonNameLabel.bottomAnchor, paddingTop: bodyPadding,
                                          left: nil, paddingLeft: 0,
                                          bottom: nil, paddingBottom: 0,
                                          right: nil, paddingRight: 0,
                                          width: 0, height: 0, enableInsets: true)
        frogScientificNameLabel.text = "frog scientific Name Label"
        frogScientificNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        frogScientificNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        frogScientificNameLabel.textColor = .secondaryLabel

        
        
        descriptionHeading.addAnchor(top: frogScientificNameLabel.bottomAnchor, paddingTop: sectionPadding,
                                     left: view.leftAnchor, paddingLeft: leftRightPadding,
                                     bottom: nil, paddingBottom: 0,
                                     right: nil, paddingRight: 0,
                                     width: 0, height: 0, enableInsets: true)
        descriptionHeading.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionHeading.text = "Description"
        descriptionHeading.font = UIFont.systemFont(ofSize: fontSubBodySize, weight: .bold)

        
        frogDetailsLabel.addAnchor(top: descriptionHeading.bottomAnchor, paddingTop: bodyPadding,
                                   left: view.leftAnchor, paddingLeft: leftRightPadding,
                                   bottom: nil, paddingBottom: 0,
                                   right: view.rightAnchor, paddingRight: leftRightPadding,
                                   width: 0, height: 0, enableInsets: true)
        frogDetailsLabel.text = ""
        frogDetailsLabel.font = UIFont.systemFont(ofSize: fontSubBodySize, weight: .regular)
        frogDetailsLabel.numberOfLines = 0
        frogDetailsLabel.textAlignment = .justified
        frogDetailsLabel.textColor = .secondaryLabel


        
        locationUncertaintyHeading.addAnchor(top: frogDetailsLabel.bottomAnchor, paddingTop: sectionPadding,
                                             left: view.leftAnchor, paddingLeft: leftRightPadding,
                                             bottom: nil, paddingBottom: 0,
                                             right: nil, paddingRight: 0,
                                             width: 0, height: 0, enableInsets: true)
        locationUncertaintyHeading.text = "Location uncertainty"
        locationUncertaintyHeading.font = UIFont.systemFont(ofSize: fontSubBodySize, weight: .bold)
        
        locationUncertaintyLabel.addAnchor(top: frogDetailsLabel.bottomAnchor, paddingTop: sectionPadding,
                                           left: nil, paddingLeft: 0,
                                           bottom: nil, paddingBottom: 0,
                                           right: view.rightAnchor, paddingRight: leftRightPadding,
                                           width: 0, height: 0, enableInsets: true)
        locationUncertaintyLabel.text = "100 meters"
        locationUncertaintyLabel.font = UIFont.systemFont(ofSize: fontSubBodySize, weight: .regular)
        
        threatenedHeading.addAnchor(top: locationUncertaintyLabel.bottomAnchor, paddingTop: bodyPadding,
                                             left: view.leftAnchor, paddingLeft: leftRightPadding,
                                             bottom: nil, paddingBottom: 0,
                                             right: nil, paddingRight: 0,
                                             width: 0, height: 0, enableInsets: true)
        threatenedHeading.text = "Threatened status"
        threatenedHeading.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        threatenedLabel.addAnchor(top: locationUncertaintyLabel.bottomAnchor, paddingTop: bodyPadding,
                                           left: nil, paddingLeft: 0,
                                           bottom: nil, paddingBottom: 0,
                                           right: view.rightAnchor, paddingRight: leftRightPadding,
                                           width: 0, height: 0, enableInsets: true)
        threatenedLabel.text = "Endabgered"
        threatenedLabel.font = UIFont.systemFont(ofSize: fontSubBodySize, weight: .regular)

        frogCountHeading.addAnchor(top: threatenedLabel.bottomAnchor, paddingTop: bodyPadding,
                                             left: view.leftAnchor, paddingLeft: leftRightPadding,
                                             bottom: nil, paddingBottom: 0,
                                             right: nil, paddingRight: 0,
                                             width: 0, height: 0, enableInsets: true)
        frogCountHeading.text = "Frog count"
        frogCountHeading.font = UIFont.systemFont(ofSize: fontSubBodySize, weight: .bold)
        
        frogCountLabel.addAnchor(top: threatenedLabel.bottomAnchor, paddingTop: bodyPadding,
                                           left: nil, paddingLeft: 0,
                                           bottom: nil, paddingBottom: 0,
                                           right: view.rightAnchor, paddingRight: leftRightPadding,
                                           width: 0, height: 0, enableInsets: true)
        frogCountLabel.text = "6"
        frogCountLabel.font = UIFont.systemFont(ofSize: fontSubBodySize, weight: .regular)
        
        sightedHeading.addAnchor(top: frogCountLabel.bottomAnchor, paddingTop: bodyPadding,
                                             left: view.leftAnchor, paddingLeft: leftRightPadding,
                                             bottom: nil, paddingBottom: 0,
                                             right: nil, paddingRight: 0,
                                             width: 0, height: 0, enableInsets: true)
        sightedHeading.text = "Sighted"
        sightedHeading.font = UIFont.systemFont(ofSize: fontSubBodySize, weight: .bold)
        
        sightedLabel.addAnchor(top: frogCountLabel.bottomAnchor, paddingTop: bodyPadding,
                                           left: nil, paddingLeft: 0,
                                           bottom: nil, paddingBottom: 0,
                                           right: view.rightAnchor, paddingRight: leftRightPadding,
                                           width: 0, height: 0, enableInsets: true)
        sightedLabel.text = "No"
        sightedLabel.font = UIFont.systemFont(ofSize: fontSubBodySize, weight: .regular)
        
    }
    
    // MARK:- Foot views
    fileprivate func addFootView() {
        view.addSubview(closeButton)
        
        closeButton.addAnchor(top: nil, paddingTop: 0,
                              left: nil, paddingLeft: 0,
                              bottom: view.bottomAnchor, paddingBottom: 0,
                              right: nil, paddingRight: 0,
                              width: 50, height: 50,
                              enableInsets: true)
        closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        closeButton.setBackgroundImage(UIImage(systemName: "xmark.circle.fill"), for: UIControl.State.normal)
        closeButton.tintColor = UIColor.red
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
    }
    
}

// MARK:- Tap action methods
extension FrogDetailsVC {
    
    @objc func frogImageDidTapped() {
        let previewController = QLPreviewController()
        previewController.dataSource = self
        present(previewController, animated: true, completion: nil)
    }
    
    @objc func favouriteButtonDidTapped() {
        favouriteStatus.toggle()
        // Changes the logo when tapped on it.
        favouriteButton.setBackgroundImage(UIImage(systemName: favouriteStatus ? "suit.heart.fill" : "suit.heart"), for: UIControl.State.normal)
        
        // Updates the fav status of a frog in database.
        CoreDataHandler.updateFrog(frogCommonName: frogItem!.cname!, isVisited: frogItem!.isVisited, isFavourite: favouriteStatus)
        postNotificationForFavouriteChange()
    }
    
    @objc func closeButtonAction(sender: UIButton!) {
        // Dismisses the current controller.
        dismiss(animated: true)
    }
    
    private func postNotificationForFavouriteChange() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "com.favourite.button.did.tapped"), object: nil)
    }

}

// MARK:- Weather fetching protocol
extension FrogDetailsVC: WeatherProtocol {
    
    func convertLatLonToString(latitude: Double, longitude: Double) -> (String, String) {
        let latitudeInString = String(latitude)
        let longitudeInStirng = String(longitude)
        
        return (latitudeInString, longitudeInStirng)
    }
    
    func fetchWeather(latitude: String, longitude: String) {
        frogDetailsViewModel.fetchWeatherDetailsFor(latitude: latitude, longitude: longitude)
    }
    
    func didFinishFetchingWeather() {
        updateWeatherData()
    }
    
    func didFinishFetchingWeatherIcon() {
        updateWeatherIcon()
    }
    
    private func updateWeatherData() {
        if let weatherData = frogDetailsViewModel.weather {
            locationLabel.text = weatherData.name
            
            let temperature = Int(round(weatherData.main.temp))
            let temperatureInCelsius = String(format: "%i", temperature - 273) + " °C"
            temperatureLabel.text = "\(String(describing: temperatureInCelsius))"
            temperatureStatusLabel.text = "\(String(describing: weatherData.weather[0].description))"
            
            humidityLabel.text = "\(String(describing: weatherData.main.humidity))"
            humidityStatusLabel.text = "Humidity"
        }
    }
    
    private func updateWeatherIcon() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: { [self] in
            temperatureImageView.backgroundColor = .clear
            temperatureImageView.image = UIImage(data: frogDetailsViewModel.imageData ?? Data())
        })
    }
}

// MARK:- AR Look
import QuickLook
import ARKit

extension FrogDetailsVC: QLPreviewControllerDataSource {
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int { return 1 }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        var url = [URL]()
        let usdzNames = ["Frog1", "Frog2Color", "Frog3Main"]
        for usdz in usdzNames {
            guard let path = Bundle.main.path(forResource: usdz, ofType: "usdz") else { fatalError("Couldn't find the supported input file.") }
            url.append(URL(fileURLWithPath: path))
        }
        
        return url[getRandom(from: 0, to: 2)] as QLPreviewItem
    }
    
    func getRandom(from: Int, to: Int) -> Int {
        let number = Int.random(in: from..<to)
        print(number)
        
        return number
    }
}

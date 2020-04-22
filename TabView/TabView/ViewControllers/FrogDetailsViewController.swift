//
//  FrogDetailsViewController.swift
//  TabView
//
//  Created by Varma on 14/04/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit

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

class FrogDetailsViewController: UIViewController {

    var receivedFrog: FrogEntity?
    
    var lat: Double = 0
    var long: Double = 0
    //var apiurl = "https://api.openweathermap.org/data/2.5/weather?lat=" + lat + "&lon=" + long + "&appid=3af463d5d4d7916e155dd605e37db688"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(receivedFrog?.sname! as Any)
        // Do any additional setup after loading the view.
    }

    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    /*
    //From Apple documentation
        //Gets data and parses the JSON data into usable data
        func getDataFromUrl() {
            let urls = URL(string: apiurl)
            //let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=" + lat + "&lon=" + long + "&appid=3af463d5d4d7916e155dd605e37db688")
            URLSession.shared.dataTask(with: urls!) { data, _, _ in
                if let data = data {
                    let resp = try? JSONDecoder().decode(JsonResponse.self, from: data)
                    DispatchQueue.main.async {
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
//                    self.apiIcon.backgroundColor = .clear
//                    self.apiIcon.image = UIImage(data: data)

                }
            })
        }
 */
}

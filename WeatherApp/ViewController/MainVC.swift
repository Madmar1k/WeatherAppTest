//
//  MainVC.swift
//  WeatherApp
//
//  Created by Michil Khodulov on 09.11.2017.
//  Copyright © 2017 Michil Khodulov. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    //MARK: - Properties
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windspdLabel: UILabel!
    @IBOutlet weak var winddirLabel: UILabel!
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    
    var windDirectionDegree: Int?
    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toggleActivityIndicator(on: true)
        loadCurrentWeather()
    }
    
    // show Chart in landscape orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            performSegue(withIdentifier: "Chart", sender: self)
        }
    }
    
    //MARK: - Event handlers
    @IBAction func refreshAction(_ sender: UIButton) {
        toggleActivityIndicator(on: true)
        loadCurrentWeather()
    }
    
    // get current weather from API
    private func loadCurrentWeather() {
        APIRouter.shared.getWeather(for: ["q": "Moscow"], apiMethod: .current) { (result) in
            self.toggleActivityIndicator(on: false)
            switch result {
            case .Success(let weather):
                do {
                    // assign view properties
                    self.weatherImage.image = try WeatherIconManager(path: weather.condition.icon).image
                    self.tempLabel.text = "\(weather.temp_c)°C"
                    self.conditionLabel.text = weather.condition.text
                    self.feelsLabel.text = "Feels like: \(weather.feelslike_c)°C"
                    
                    //convert bars to mms
                    let pressureInMM = weather.pressure_mb * 0.750062
                    self.pressureLabel.text = "Pressure: \(pressureInMM.rounded()) mm"
                    
                    self.humidityLabel.text = "Humidity: \(weather.humidity)%"
                    self.windspdLabel.text = "Wind: \(weather.wind_kph) kph"
                    self.winddirLabel.text = "direction: \(weather.wind_dir)"
                    
                    self.windDirectionDegree = weather.wind_degree
                } catch {
                    print(error)
                }
                let dict = ["tempC": weather.temp_c, "windKph": weather.wind_kph, "lastUpdated": weather.last_updated] as [String : AnyObject]
                self.saveInCoreDataWith(dict: dict)
            case .Error(let message):
                self.showAlertWith(title: "Error", message: message)
            }
        }
    }
    
    func toggleActivityIndicator(on: Bool) {
        refreshButton.isUserInteractionEnabled = !on
        if on {
            activityInd.startAnimating()
        } else {
            activityInd.stopAnimating()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "ShowWindDirection":
            guard let windVC = segue.destination as? WindVC else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let degree = self.windDirectionDegree else {
                self.showAlertWith(title: "Error", message: "Can't load data for wind degree")
                return
            }
            windVC.degree = degree
        case "Chart":
            print("Chart segue")
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: - Core Data methods
    private func createWeatherEntityFrom(dictionary: [String: Any]) -> NSManagedObject? {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        if let weatherEntity = NSEntityDescription.insertNewObject(forEntityName: "Weather", into: context) as? Weather {
            weatherEntity.tempC = dictionary["tempC"] as! Double
            weatherEntity.windKph = dictionary["windKph"] as! Double
            
            //convert string to NSDate
            let date = dictionary["lastUpdated"] as! String
            weatherEntity.lastUpdated = date.getDate()
            return weatherEntity
        }
        return nil
    }
    
    private func saveInCoreDataWith(dict: [String: AnyObject]) {
        _ = self.createWeatherEntityFrom(dictionary: dict)
        do {
            try CoreDataStack.shared.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }

    
}


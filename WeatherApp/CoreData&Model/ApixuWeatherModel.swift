//
//  ApixuWeatherModel.swift
//  WeatherApp
//
//  Created by Michil Khodulov on 09.11.2017.
//  Copyright © 2017 Michil Khodulov. All rights reserved.
//

import Foundation

struct ApixuWeatherModel {
    let last_updated_epoch: Int
    let last_updated: String
    let temp_c: Double
    let temp_f: Double
    let is_day: Int
    let condition: (code: Int, icon: String, text: String)
    let wind_mph: Double
    let wind_kph: Double
    let wind_degree: Int
    let wind_dir: String
    let pressure_mb: Double
    let pressure_in: Double
    let precip_mm: Double
    let precip_in: Double
    let humidity: Int
    let cloud: Int
    let feelslike_c: Double
    let feelslike_f: Double
    let vis_km: Double
    let vis_miles: Double
    
    //MARK: - Initializer with Error Handling
    init(json: [String: Any]) throws {
        // Extract name
        guard let last_updated_epoch = json["last_updated_epoch"] as? Int else {
            throw SerializationError.missing("last_updated_epoch")
        }
        guard  let last_updated = json["last_updated"] as? String  else {
            throw SerializationError.missing("last_updated")
        }
        guard let temp_c = json["temp_c"] as? Double else {
            throw SerializationError.missing("temp_c")
        }
        guard let temp_f = json["temp_f"] as? Double else {
            throw SerializationError.missing("temp_f")
        }
        guard let is_day = json["is_day"] as? Int else {
            throw SerializationError.missing("exposure")
        }
        guard let conditionJSON = json["condition"] as? [String: Any],
            let text = conditionJSON["text"] as? String,
            let icon = conditionJSON["icon"] as? String,
            let code = conditionJSON["code"] as? Int
            else {
                throw SerializationError.missing("condition")
        }
        let condition = (code, icon, text)
        guard let wind_mph = json["wind_mph"] as? Double else {
            throw SerializationError.missing("wind_mph")
        }
        guard let wind_kph = json["wind_kph"] as? Double else {
            throw SerializationError.missing("wind_kph")
        }
        guard let wind_degree = json["wind_degree"] as? Int else {
            throw SerializationError.missing("wind_degree")
        }
        guard case (0...360) = wind_degree else {
            throw SerializationError.invalid("wind_degree", wind_degree)
        }
        guard let wind_dir = json["wind_dir"] as? String else {
            throw SerializationError.missing("wind_dir")
        }
        guard let pressure_mb = json["pressure_mb"] as? Double else {
            throw SerializationError.missing("pressure_mb")
        }
        guard let pressure_in = json["pressure_in"] as? Double else {
            throw SerializationError.missing("pressure_in")
        }
        guard let precip_mm = json["precip_mm"] as? Double else {
            throw SerializationError.missing("precip_mm")
        }
        guard let precip_in = json["precip_in"] as? Double else {
            throw SerializationError.missing("precip_in")
        }
        guard let humidity = json["humidity"] as? Int else {
            throw SerializationError.missing("humidity")
        }
        guard let cloud = json["cloud"] as? Int else {
            throw SerializationError.missing("cloud")
        }
        guard let feelslike_c = json["feelslike_c"] as? Double else {
            throw SerializationError.missing("feelslike_c")
        }
        guard let feelslike_f = json["feelslike_f"] as? Double else {
            throw SerializationError.missing("feelslike_f")
        }
        guard let vis_km = json["vis_km"] as? Double else {
            throw SerializationError.missing("vis_km")
        }
        guard let vis_miles = json["vis_miles"] as? Double else {
            throw SerializationError.missing("vis_miles")
        }
        self.last_updated_epoch = last_updated_epoch
        self.last_updated = last_updated
        self.temp_c = temp_c
        self.temp_f = temp_f
        self.is_day = is_day
        self.condition = condition
        self.wind_mph = wind_mph
        self.wind_kph = wind_kph
        self.wind_degree = wind_degree
        self.wind_dir = wind_dir
        self.pressure_mb = pressure_mb
        self.pressure_in = pressure_in
        self.precip_mm = precip_mm
        self.precip_in = precip_in
        self.humidity = humidity
        self.cloud = cloud
        self.feelslike_c = feelslike_c
        self.feelslike_f = feelslike_f
        self.vis_km = vis_km
        self.vis_miles = vis_miles
    }
}

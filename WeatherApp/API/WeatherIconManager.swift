//
//  WeatherIconManager.swift
//  WeatherApp
//
//  Created by Michil Khodulov on 10.11.2017.
//  Copyright © 2017 Michil Khodulov. All rights reserved.
//

import UIKit

struct WeatherIconManager {
    let image: UIImage?
    init(path: String) throws {
        // get path to icon png file
        let pathString = path.replacingOccurrences(of: "//cdn.apixu.com/weather/64x64/", with: "").replacingOccurrences(of: ".png", with: "")
        let pathArray = pathString.components(separatedBy: "/")
        guard let bundlePath = Bundle.main.path(forResource: pathArray[1], ofType: "png", inDirectory: pathArray[0]) else {
            throw IconManagerError.invalid("bundlePath")
        }
        guard let image = UIImage(contentsOfFile: bundlePath) else {
            throw IconManagerError.invalid("image")
        }
        self.image = image
    }
}

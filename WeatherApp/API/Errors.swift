//
//  Errors.swift
//  WeatherApp
//
//  Created by Michil Khodulov on 09.11.2017.
//  Copyright © 2017 Michil Khodulov. All rights reserved.
//

//MARK: - Throwing errors
enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}
enum URLFormerError: Error {
    case missing(String)
    case invalid(String)
}
enum IconManagerError: Error {
    case invalid(String)
}

//
//  APIRouter.swift
//  WeatherApp
//
//  Created by Michil Khodulov on 09.11.2017.
//  Copyright © 2017 Michil Khodulov. All rights reserved.
//

import Foundation

final class APIRouter: NSObject {
    
    // singleton
    static let shared = APIRouter()
    private override init() { }
    
    // set API key
    fileprivate let apixuKey = "93479c6634be462ea2e95936170811"
    
    //MARK: - Main function to get current weather, forecast or history
    func getWeather(for parameters: [String: Any], apiMethod: APIMethod, completion: @escaping (Result<ApixuWeatherModel>) -> Void) {
        do {
            var request = URLRequest(url: try urlFormer(withAPIMethod: apiMethod, parameters: parameters))
            request.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else { print(error!); completion(.Error("connection error")); return }
                guard let _ = response, let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                            let apixu = try ApixuWeatherModel(json: json["current"] as! [String : Any])
                            completion(.Success(apixu))
                        }
                    } catch let serializationError {
                        completion(.Error("\(serializationError)"))
                    }
                }
                }.resume()
        } catch let urlError {
            print(urlError)
        }
    }
    
    //MARK: - URL formatter with error handler
    fileprivate func urlFormer(withAPIMethod: APIMethod, parameters: [String: Any]?) throws -> URL {
        guard let parameterString = parameters?.stringFromHttpParameters() else {
            throw URLFormerError.missing("missing parameters")
        }
        var path: String {
            switch withAPIMethod {
            case .current:
                return "/current.json"
            case .forecast:
                return "/forecast.json"
            case .history:
                return "/history.json"
            }
        }
        guard let url = URL(string: apixuAPI + path + "?key=" + apixuKey + "&" + parameterString) else {
            throw URLFormerError.invalid("invalid URL")
        }
        return url
    }
}


//MARK: - Enums
enum APIMethod {
    case current
    case forecast(String, Int)
    case history(String)
}

enum Result<T> {
    case Success(T)
    case Error(String)
}




















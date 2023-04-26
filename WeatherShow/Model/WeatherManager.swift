//
//  WeatherManager.swift
//  WeatherShow
//
//  Created by 贾贾 on 2023/4/25.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=9d0ec0779dca347eb1806654b5dbf105&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    //get data
    func performRequest(with urlString: String) {
        //create a URL
        if let url = URL(string: urlString) {
            //create a URLSession
            let session = URLSession(configuration: .default)
            //give URLSession a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        //pass weather to controller
                        self.delegate?.didUpdateWeather(self, weather: weather)
                        
                    }
                }
            }
            //start the task (hit enter in browser)
            task.resume()
        }
    }
    //transfer the data type to swift that we can use
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodeData.weather[0].id
            let temp = decodeData.main.temp
            let name = decodeData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temprature: temp)
            return weather
        }catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
}

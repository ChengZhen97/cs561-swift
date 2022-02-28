import Alamofire

public protocol WeatherService {
    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void)
    func getHello(completion: @escaping (_ response: Result<String, Error>) -> Void)
    func getAuth(completion: @escaping (_ authToken: String) -> Void)
}

class WeatherServiceImpl: WeatherService {
    let urlWeather = "http://localhost:3000/v1/weather"
    let urlAuth    = "http://localhost:3000/v1/auth"
    let urlHello   = "http://localhost:3000/v1/hello"

    func getAuth(completion: @escaping (_ auth: String) -> Void) -> Void) {
        let params: Parameters = [
            "username": "usr",
            "password": "pass"
        ]

        AF.request(urlAuth, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
          .validate(statusCode: 200..<300)
          .responseDecodable(of: Token.self) {
              AFdata in
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: AFdata.data!) as? [String: Any] else {
                        print("Error: Cannot convert data to JSON object")
                        return
                    }
                    let token = jsonObject["accessToken"] as! String
                    completion(token)
            } 
    }
    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void) {
        AF.request(url, method: .get).validate(statusCode: 200..<300).responseDecodable(of: Weather.self) { response in
            switch response.result {
            case let .success(weather):
                let temperature = weather.main.temp
                let temperatureAsInteger = Int(temperature)
                completion(.success(temperatureAsInteger))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    func getHello(completion: @escaping (_ response: Result<String /* Temperature */, Error>) -> Void) {
        AF.request(url, method: .get).validate(statusCode: 200..<300).responseDecodable(of: Weather.self) { response in
            switch response.result {
            case let .success(weather):
                let temperature = weather.main.temp
                let temperatureAsInteger = Int(temperature)
                completion(.success(temperatureAsInteger))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

private struct Weather: Decodable {
    let main: Main

    struct Main: Decodable {
        let temp: Double
    }
}

//
//  LocationModel.swift
//  On the Map
//
//  Created by Aditya Rana on 03.09.20.
//  Copyright © 2020 Aditya Rana. All rights reserved.
//

import Foundation

class LocationModel {
    
    struct Auth {
        static var keyAccount = ""
        static var sessionId = ""
        
    }
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"
        
        case createSessionId
        case getStudentLocation(Int)
        case getOneStduentLocation(String)
        case postStudentLocation
        case updateStudentLocation(String)
        case getUserData
        case logout
        
        var urlString: String {
            switch self {
                
                
            case .createSessionId: return Endpoints.base + "session"
            case .getStudentLocation(let index): return Endpoints.base + "StudentLocation" + "?limit=100&skip=\(index)&order=-updatedAt"
            case .getOneStduentLocation(let uniqueKey): return Endpoints.base + "StudentLocation?uniqueKey=\(uniqueKey)"
            case .postStudentLocation: return Endpoints.base + "StudentLocation"
            case .updateStudentLocation(let objectID): return Endpoints.base + "StudentLocation/\(objectID)"
            case .getUserData: return Endpoints.base + "users/" + Auth.keyAccount
            case .logout: return Endpoints.base + "session"
            }
            
        }
        
        var url: URL {
            return URL(string: urlString)!
        }
    }
    
    //POST Request for Login
    class func login(with email: String, password: String, completion: @escaping (Bool, Error?) -> ()){
        
        var request = URLRequest(url: Endpoints.createSessionId.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    return completion(false, error)
                }
                return
            }
            print("login: \(String(describing: String(data: data, encoding: .utf8)))")
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            print(String(data: newData, encoding: .utf8)!)
            let decoder = JSONDecoder()
            do {
                
                let responseObject = try decoder.decode(LoginResponse.self, from: newData)
                DispatchQueue.main.async {
                    self.Auth.sessionId = responseObject.session.id
                    self.Auth.keyAccount = responseObject.account.key
                    completion(true, nil)
                }
            }
            catch {
                DispatchQueue.main.async {struct UserLoginResponse: Codable {
                        
                        let account: Account
                        let session: Session
                        
                        enum CodingKeys: String, CodingKey { case account, session }
                    }

                    struct Account: Codable {
                        let registered: Bool
                        let key: String
                        
                        enum CodingKeys: String, CodingKey { case registered, key }
                    }

                    struct Session: Codable {
                        let id: String
                        let expiration: String
                        
                        enum CodingKeys: String, CodingKey { case id, expiration }
                    }

                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    
    // GET Student Locations
    
    class func getStudentLocation(singleStudent: Bool, completion: @escaping ([StudentLocation]?, Error?) -> Void) {
        
        let session = URLSession.shared
        var url = URL(string: "www.google.com")!
        
        if singleStudent {
            url = Endpoints.getOneStduentLocation("1234").url
        } else {
            url = Endpoints.getStudentLocation(0).url
        }
        
        
        let task = session.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let requestObject = try decoder.decode(StudentLocationResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(requestObject.results, nil)
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                    print(error.localizedDescription)
                }
            }
        }
        
        task.resume()
    }
    
//   Delete Login Session
    
    class func deleteLoginSession(completion: @escaping (Bool, Error?) -> Void){
        let url = Endpoints.logout.url
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie}
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(true, nil)
            }
        }
        task.resume()
        
    }
    
//   Get User Data
    
  class func getUserData(completion: @escaping (UserData?, Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: Endpoints.getUserData.url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            let decoder = JSONDecoder()
            do {
                let requestObject = try decoder.decode(UserData.self, from: newData)
                DispatchQueue.main.async {
                    print(newData)
                    completion(requestObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            
        }
        task.resume()
        
    }
    
    // Post Student Location
    class func postStudentLoaction(postLocation: PostLocationRequest, completion: @escaping (PostLocationResponse?, Error?) -> Void) {
        
        var request = URLRequest(url: Endpoints.postStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = postLocation
        
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    return completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(PostLocationResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                    print("Location Posted")
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
        
    }
    
    // Method put student location
    
    class func putStudentLocation(objectID: String, postLocation: PostLocationRequest, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.updateStudentLocation(objectID).url)
        
        print(request.description)
        
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = postLocation
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    return completion(false, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let responseObj = try decoder.decode(PostLocationResponse.self, from: data)
                DispatchQueue.main.async {
                    print("\(responseObj)")
                    completion(true, nil)
                }
                
            }
            catch {
                // error
                DispatchQueue.main.async {
                    completion(false, nil)
                }
            }
        }
        task.resume()
        
    }
}




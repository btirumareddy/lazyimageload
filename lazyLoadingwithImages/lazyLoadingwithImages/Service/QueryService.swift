//
//  QueryService.swift
//  lazyLoadingwithImages
//
//  Created by Bhanuja Tirumareddy on 02/07/20.
//  Copyright © 2020 Bhanuja Tirumareddy. All rights reserved.
//

import Foundation.NSURL
import UIKit

class QueryService {
    var tracks: [GetDataModel] = []
    let defaultSession = URLSession(configuration: .default)
    // MARK: - Variables And Properties
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
    // MARK: - Type Alias
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([GetDataModel]?, String) -> Void
    
    
    func getDataWith(url: String, limit:String , completion: @escaping QueryResult) {
       dataTask?.cancel()
        
       // guard let url = URL(string: url) else { fatalError("Invalid Url!")}
        
        let queryItems = [URLQueryItem(name: "limit", value: limit), URLQueryItem(name: "offset", value: "6")]
        var urlComps = URLComponents(string: url)!
        urlComps.queryItems = queryItems
        let result = urlComps.url!
        print(result)
        
        var getrequest = URLRequest(url:urlComps.url!)
       // var getrequest = URLRequest(url: url)
        getrequest.httpMethod = "GET"
        getrequest.setValue("jvmNAyPNr1JhiCeUlYmB2ae517p3Th0aGG6syqMb", forHTTPHeaderField: "x-api-key")
    
        dataTask = defaultSession.dataTask(with: getrequest) {[weak self] data, response, error in
            
            defer {
            self?.dataTask = nil
          }
          if let error = error {
            self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
          } else if
            let data = data,
            let response = response as? HTTPURLResponse{
            if response.statusCode == 200 {
            self?.updateSearchResults(data)
            DispatchQueue.main.async {
              completion(self?.tracks, self?.errorMessage ?? "")
            }
            }
            else {
                self?.errorMessage += "DataTask error: " + "status is other than 200" + "\n"
                
            }
          }
           
            
        }
        dataTask?.resume()
    }


private  func updateSearchResults(_ data: Data) {

        let responseObj = try? JSONSerialization.jsonObject(with: data, options: [])
        if let response = responseObj as? [String: Any] { print(response) }
  guard let array = responseObj as? [Any] else {
    errorMessage += "Dictionary does not contain results key\n"
    return
  }
  var index = 0
  for trackDictionary in array {
    if let trackDictionary = trackDictionary as? JSONDictionary,
      let previewURLString = trackDictionary["thumbnail"] as? String,
      let previewURL = URL(string: previewURLString),
      let status = trackDictionary["status"] as? String,
     let dateTime = trackDictionary["dateTime"] as? String,
    let size = trackDictionary["fileSize"] as? String,
      let id = trackDictionary["id"] as? Int {
        tracks.append(GetDataModel(dateTime: dateTime, status: status, thumbnail: previewURL, id: id, size: size))
        index += 1
    } else {
      errorMessage += "Problem parsing trackDictionary\n"
    }
  }
}

}

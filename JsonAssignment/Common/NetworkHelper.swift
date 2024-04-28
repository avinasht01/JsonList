//
//  NetworkHelper.swift
//  JsonAssignment
//
//  Created by Avinash Thakur on 26/04/24.
//

import Foundation

class NetworkRequestHelper {
    
    /**
     Function request data from server for given url using URLSession
     - Parameter url: URL  server url
     - Returns: completion  Returns completion handler with request data and error if any.
     */
    static func requestDataForUrl(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(
            with: request, completionHandler: { data, response, error in
                if error == nil {
                    guard let resultData = data else {
                        let error = NSError(domain: "Api Result Error", code: 101, userInfo: ["Desc" : "No data found"])
                        completion(nil, error)
                        return
                    }
                    completion(resultData, nil)
                } else {
                    completion(nil, error)
                }
            })
        task.resume()
    }
}

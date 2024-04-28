//
//  PostService.swift
//  JsonAssignment
//
//  Created by Avinash Thakur on 26/04/24.
//

import Foundation

class PostService {
    
    static let jsonDecoder = JSONDecoder()
    
    /// Function  prepares api url to fetch data from server
    static func fetchListOfPostFromServer(completion: @escaping ([Post], Error?) -> Void) {
        let apiString = PostConstants.apiUrl
        guard let url = URL(string: apiString) else {
            let error = NSError(domain: PostConstants.invalidUrlError, code: PostConstants.apiErrorCode, userInfo: [PostConstants.errorDesc : PostConstants.errorMessage])
            completion([], error)
            return
        }
        NetworkRequestHelper.requestDataForUrl(url: url) { data, error in
            if error == nil, let resultData = data {
                let posts = PostService.parserApiResult(result: resultData)
                completion(posts, nil)
            } else {
                let error = NSError(domain: PostConstants.serverError, code: PostConstants.serverErrorCode, userInfo:  [PostConstants.errorDesc : PostConstants.errorMessage])
                completion([], error)
            }
        }
    }
    
    /// Function parses data from api response and creates post list.
    static func parserApiResult(result: Data) -> [Post] {
        do {
            let post = try PostService.jsonDecoder.decode([Post].self, from: result)
            print(post)
            return post
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
}

//
//  PostStruct.swift
//  JsonAssignment
//
//  Created by Avinash Thakur on 26/04/24.
//

import Foundation

struct Post: Codable {
    var id: Int
    var userId: Int
    var title: String
    var body: String
}

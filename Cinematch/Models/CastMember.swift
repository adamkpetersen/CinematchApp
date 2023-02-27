//
//  CastMember.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/7/22.
//

import Foundation

struct CastMember: Codable, Identifiable, Hashable {
    let id: Int
    var character: String
    var creditId: String
    var gender: Int
    var castId: Int
    var name: String
    var order: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case character
        case creditId = "credit_id"
        case gender
        case castId = "cast_id"
        case name
        case order
    }
}

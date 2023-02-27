//
//  Movie.swift
//  Cinematch
//
//  Created by Adam Petersen on 10/24/22.
//

import Foundation
import SwiftUI

struct Movie: Identifiable, Codable, Hashable {
    var id: Int
    var title: String
    var year: Int
    var tagline: String
    var genres: [Genre]
    var keywords: [Keyword]
    var cast: [CastMember]
    var overview: String
    var budget: Int
    var language: String
    var revenue: Int
    var runtime: Int
    var popularity: Double
    var voteAverage: Double
    var voteCount: Int
    var weightedRating: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case year = "release_year"
        case tagline
        case genres
        case keywords
        case cast
        case overview
        case budget
        case language = "original_language"
        case revenue
        case runtime
        case popularity
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case weightedRating = "weighted_rating"
    }
}

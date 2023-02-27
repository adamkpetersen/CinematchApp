//
//  Genre.swift
//  Cinematch
//
//  Created by Adam Petersen on 10/24/22.
//

import Foundation
import SwiftUI

struct Genre: Identifiable, Hashable, Codable {
    var id: Int
    var name: String
    var emoji: String {
        switch name {
        case "Action":
            return "🧨"
        case "Adventure":
            return "🚀"
        case "Animation":
            return "🎨"
        case "Comedy":
            return "😂"
        case "Crime":
            return "🚓"
        case "Documentary":
            return "🎥"
        case "Drama":
            return "🎭"
        case "Family":
            return "👨‍👩‍👧"
        case "Fantasy":
            return "🏰"
        case "Foreign":
            return "🌎"
        case "History":
            return "📖"
        case "Horror":
            return "👻"
        case "Music":
            return "🎵"
        case "Mystery":
            return "🔎"
        case "Romance":
            return "❤️"
        case "Science Fiction":
            return "👽"
        case "TV Movie":
            return "📺"
        case "Thriller":
            return "🍿"
        case "War":
            return "🪖"
        case "Western":
            return "🤠"
        default:
            return "🤖"
        }
    }
}

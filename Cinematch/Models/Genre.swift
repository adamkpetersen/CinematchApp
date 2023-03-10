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
            return "๐งจ"
        case "Adventure":
            return "๐"
        case "Animation":
            return "๐จ"
        case "Comedy":
            return "๐"
        case "Crime":
            return "๐"
        case "Documentary":
            return "๐ฅ"
        case "Drama":
            return "๐ญ"
        case "Family":
            return "๐จโ๐ฉโ๐ง"
        case "Fantasy":
            return "๐ฐ"
        case "Foreign":
            return "๐"
        case "History":
            return "๐"
        case "Horror":
            return "๐ป"
        case "Music":
            return "๐ต"
        case "Mystery":
            return "๐"
        case "Romance":
            return "โค๏ธ"
        case "Science Fiction":
            return "๐ฝ"
        case "TV Movie":
            return "๐บ"
        case "Thriller":
            return "๐ฟ"
        case "War":
            return "๐ช"
        case "Western":
            return "๐ค "
        default:
            return "๐ค"
        }
    }
}

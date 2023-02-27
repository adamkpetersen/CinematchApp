//
//  GenreViewModel.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/20/22.
//

import Foundation

class GenreViewModel: ObservableObject {
    @Published var genres: [Genre] = []
    @Published var genreStrings: [String] = []
    
    func loadGenres(movies: [Movie]) {
        self.genres = Array(movies.map(\.genres).joined()).removingDuplicates().sorted(by: { $0.name < $1.name })
        self.genreStrings = self.genres.map(\.name).sorted()
    }
}



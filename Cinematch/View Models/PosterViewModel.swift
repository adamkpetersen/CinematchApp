//
//  Created by Alfian Losari on 22/05/20.
//  Alterations by Adam Petersen on 11/10/22.
//

import SwiftUI

class PosterViewModel: ObservableObject {
    @Published var posters: [Poster] = []
    @Published var error: NSError?
    @EnvironmentObject var movieData: MovieViewModel
    @Published var postersLoaded = false
    @Published var posterLookup = PosterLookup()
    
    func loadPosters(movies: [Movie]) {
        self.postersLoaded = false
        var fetchedPosters: [Poster] = posters
        for movie in movies {
            self.posterLookup.fetchPoster(id: movie.id) {[weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let movie):
                    fetchedPosters.append(movie)
                    self.posters = fetchedPosters
                    if movie.id == movies.last!.id {
                        self.postersLoaded = true
                    }
                case .failure(let error):
                    self.error = error as NSError
                }
            }
        }
    }
}

//
//  MovieMatchModel.swift
//  Cinematch
//
//  Created by Adam Petersen
//

import Foundation
import CardStack

class MovieMatchModel: ObservableObject {
    @Published var likedMovies: [(movie: Movie, genreMash: [Genre])] = []
    @Published var dislikedMovies: [Movie] = []
    @Published var filteredMovies: [Movie] = []
    @Published var recommendations: [(movie: Movie, score: Double)] = []
    @Published var genreMashes: [[Genre]] = []
    @Published var recentlyLikedMovieCount : Int = 0
    @Published var refreshCount: Int = 0
    private let recommendationService: RecommendationService
    private var recommendationsTask: Task<Void, Never>?
    
    init(recommendationService: RecommendationService = RecommendationService()) {
      self.recommendationService = recommendationService
    }
    
    func makeRecommendations(likedMovies: [Movie], allMovies: [Movie], allGenres: [String]) async throws {
        recommendationsTask?.cancel()
        recommendationsTask = Task {
            do {
                let result = try await recommendationService.prediction(for: likedMovies, allMovies: allMovies, allGenres: allGenres)
                if !Task.isCancelled {
                    DispatchQueue.main.async {
                        self.recommendations = result
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func FilterMovie(movie: Movie, genreMash: [Genre], allMovies: [Movie], allGenres: [String], direction: LeftRight) {
        let swipedMovie = (movie, genreMash)
        if direction == .left {
            if !self.dislikedMovies.contains(movie) {
                self.dislikedMovies.append(movie)
            }
           self.likedMovies.removeAll(where: { $0 == swipedMovie })
        } else {
            if !self.likedMovies.contains(where: { $0 == swipedMovie }) {
                if !self.genreMashes.contains(genreMash) {
                    self.genreMashes.append(genreMash)
                }
                self.likedMovies.append(swipedMovie)
                self.recentlyLikedMovieCount += 1
                self.refreshCount += 1
                if self.refreshCount % 10 == 0 {
                    Task {
                        do {
                            try await self.makeRecommendations(likedMovies: self.likedMovies.map(\.movie), allMovies: allMovies, allGenres: allGenres)
                        } catch {
                            print("Error making predictions")
                        }
                    }
                }
            }
            self.dislikedMovies.removeAll(where: { $0 == movie })
        }
    }
}

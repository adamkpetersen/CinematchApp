//
//  RecommendationService.swift
//  Cinematch
//
//  Created by Martin Mitrevski on 10.7.21.
//  Alterations by Adam Petersen on 11/10/22.
//

import Foundation
import CoreML
import TabularData
#if canImport(CreateML)
import CreateML
#endif

final class RecommendationService {
    private let queue = DispatchQueue(label: "com.recommendation-service.queue", qos: .userInitiated)
    
    func prediction(for favoriteMovies: [Movie], allMovies: [Movie], allGenres: [String]) async throws -> [(Movie, Double)] {
        let trainingData = prepareTrainingData(from: favoriteMovies, allGenres: allGenres)
        let classifier = try await trainLinearRegressor(data: trainingData)
        let predictions = try predictionValues(for: favoriteMovies, allMovies: allMovies, classifier: classifier)
        return Array(zip(predictions.keys, predictions.values).sorted { $0.1 > $1.1 })
    }

    private func prepareTrainingData(from movies: [Movie], allGenres: [String]) -> TrainingData {
        var trainingGenres = [[String: Double]]()
        var trainingTargets = [Double]()
        
        for movie in movies {
            let features = featuresFromMovieAndGenres(movie: movie.title, genres: movie.genres.map(\.name))
            trainingGenres.append(features)
            trainingTargets.append(1.0)
            
            let negativeGenres = allGenres.filter { genre in
                !movie.genres.map(\.name).contains(genre)
            }
            
            trainingGenres.append(featuresFromMovieAndGenres(movie: movie.title, genres: Array(negativeGenres)))
            trainingTargets.append(-1.0)
        }
        
        return TrainingData(trainingGenres: trainingGenres, trainingTargets: trainingTargets)
    }

    private func predictionValues(for favoriteMovies: [Movie], allMovies: [Movie], classifier: MLLinearRegressor) throws -> [Movie: Double] {
        var maxValues = [Movie: Double]()
        
        for movie in allMovies.filter({ !$0.genres.isEmpty }) {
            if !favoriteMovies.contains(movie) {
                let genreData = Array(movie.genres.map(\.name)).map { genre in
                    [genre: 1.0]
                }
                var inputData = DataFrame()
                inputData.append(column: Column(name: "genres", contents: genreData))
                let predictions = try classifier.predictions(from: inputData)
                var max: Double = 0
                for prediction in predictions {
                    if let value = prediction as? Double, value > max {
                        max = value
                    }
                }
                
                maxValues[movie] = max
            }
        }
        
        return maxValues
    }

    private func trainLinearRegressor(data: TrainingData) async throws -> MLLinearRegressor {
        return try await withCheckedThrowingContinuation { continuation in
            queue.async {
                var trainingData = DataFrame()
                trainingData.append(column: Column(name: "genres", contents: data.trainingGenres))
                trainingData.append(column: Column(name: "target", contents: data.trainingTargets))
                
                do {
                    let model = try MLLinearRegressor(trainingData: trainingData, targetColumn: "target")
                    continuation.resume(returning: model)
                } catch {
                    continuation.resume(throwing: NSError(domain: "classifier", code: 1, userInfo: [:]))
                }
            }
        }
    }

    private func featuresFromMovieAndGenres(movie: String, genres: [String]) -> [String: Double] {
        let featureNames = genres + genres.map { movie + ":" + $0 }
        return featureNames.reduce(into: [:]) { featureNames, name in
            featureNames[name] = 1.0
        }
    }
}

struct TrainingData {
    var trainingGenres: [[String: Double]]
    var trainingTargets: [Double]
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

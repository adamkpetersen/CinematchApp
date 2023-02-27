//
//  GenreMashLikeabilitySheet.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/14/22.
//

import SwiftUI

struct GenreMashLikeabilitySheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var movieMatchModel: MovieMatchModel
    var movies: [Movie] {
        self.movieMatchModel.filteredMovies.filter { !self.movieMatchModel.likedMovies.map(\.movie).contains($0) && !self.movieMatchModel.dislikedMovies.contains($0) }
    }
    var likeabilityScores: (low: Double, medium: Double, high: Double) {
        countMoviesByLikeability(movies: self.movies, recommendations: self.movieMatchModel.recommendations)
    }
    var sortedMovies: (low: [(movie: Movie, score: Double)], medium: [(movie: Movie, score: Double)], high: [(movie: Movie, score: Double)]) {
        moviesByLikeability(movies: self.movies, recommendations: self.movieMatchModel.recommendations)
    }
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    GroupBox {
                        HStack(alignment: .top, spacing: 12) {
                            ZStack {
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.pink.opacity(0.5))
                                Text("🤖")
                                    .font(.title)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Movie Bot")
                                    .font(.system(.headline, design: .rounded))
                                    .foregroundColor(.primary)
                                    .foregroundColor(Color(UIColor.systemGray3))
                                Text("Now that I know a little bit about the types of movies you like, here's what I predict about this GenreMash:")
                                    .font(.system(.body, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(EdgeInsets(top: 20, leading: 15, bottom: 0, trailing: 20))
                    }
                    .groupBoxStyle(CardGroupBoxStyleNoHPadding())
                    
                    GroupBox("Movie Likeability") {
                        HStack {
                            Spacer()
                            PieChartView(
                                values: [likeabilityScores.high, likeabilityScores.medium, likeabilityScores.low],
                                colors: [.green,.orange,.cyan],
                                names: ["High Probability", "Medium Probability", "Low Probability"],
                                backgroundColor: Color(UIColor.secondarySystemGroupedBackground),
                                innerRadiusFraction: 0.60)
                            .frame(height: 300)
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 5, leading: 0, bottom: 20, trailing: 0))
                    }
                    .groupBoxStyle(CardGroupBoxStyle())
                    
                    GroupBox("Likeability Breakdown") {
                        VStack(alignment: .leading) {
                            VStack {
                                HStack {
                                    Circle()
                                        .frame(width: 10, height: 10)
                                        .foregroundColor(.green)
                                    Text("High")
                                        .font(.system(.headline, design: .rounded))
                                        .foregroundColor(.secondary)
                                    Spacer()
                                }
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 0))
                                ForEach(self.sortedMovies.high.sorted(by: { $0.score > $1.score }).map(\.movie), id: \.self) { movie in
                                    HStack {
                                        Spacer()
                                        MovieMatchRow(movie: movie)
                                        Spacer()
                                    }
                                    .padding(EdgeInsets(top: 10, leading: 3, bottom: 10, trailing: 5))
                                    .background(Color(UIColor.secondarySystemGroupedBackground))
                                    .cornerRadius(10)
                                }
                            }
                            .padding(10)
                            .background(Color(UIColor.tertiarySystemGroupedBackground).opacity(0.8))
                            .cornerRadius(10)
                            
                            VStack {
                                HStack {
                                    Circle()
                                        .frame(width: 10, height: 10)
                                        .foregroundColor(.orange)
                                    Text("Medium")
                                        .font(.system(.headline, design: .rounded))
                                        .foregroundColor(.secondary)
                                    Spacer()
                                }
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 0))
                                ForEach(self.sortedMovies.medium.sorted(by: { $0.score > $1.score }).map(\.movie), id: \.self) { movie in
                                    HStack {
                                        Spacer()
                                        MovieMatchRow(movie: movie)
                                        Spacer()
                                    }
                                    .padding(EdgeInsets(top: 10, leading: 3, bottom: 10, trailing: 5))
                                    .background(Color(UIColor.secondarySystemGroupedBackground))
                                    .cornerRadius(10)
                                }
                            }
                            .padding(10)
                            .background(Color(UIColor.tertiarySystemGroupedBackground).opacity(0.8))
                            .cornerRadius(10)
                            
                            VStack {
                                HStack {
                                    Circle()
                                        .frame(width: 10, height: 10)
                                        .foregroundColor(.cyan)
                                    Text("Low")
                                        .font(.system(.headline, design: .rounded))
                                        .foregroundColor(.secondary)
                                    Spacer()
                                }
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 0))
                                ForEach(self.sortedMovies.low.sorted(by: { $0.score > $1.score }).map(\.movie), id: \.self) { movie in
                                    HStack {
                                        Spacer()
                                        MovieMatchRow(movie: movie)
                                        Spacer()
                                    }
                                    .padding(EdgeInsets(top: 10, leading: 3, bottom: 10, trailing: 5))
                                    .background(Color(UIColor.secondarySystemGroupedBackground))
                                    .cornerRadius(10)
                                }
                            }
                            .padding(10)
                            .background(Color(UIColor.tertiarySystemGroupedBackground).opacity(0.8))
                            .cornerRadius(10)
                        }.padding(.top, 5)
                    }
                    .groupBoxStyle(CardGroupBoxStyle())
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 30, trailing: 20))
            }
            .background(Color(UIColor.systemGroupedBackground))
            .scrollIndicators(.hidden)
            .navigationTitle("GenreMash Stats")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }.bold()
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

private func countMoviesByLikeability(movies: [Movie], recommendations: [(movie: Movie, score: Double)]) -> (low: Double, medium: Double, high: Double) {
    var low: [Movie] = []
    var medium: [Movie] = []
    var high: [Movie] = []
    let movieRecommendations: [Movie] = recommendations.map(\.movie)
    let scores: [Double] = recommendations.map(\.score)
    let mean = scores.avg()
    let sd = scores.std()
    
    for movie in movies {
        if let index = movieRecommendations.firstIndex(of: movie) {
            var movieScore = scores[index]
            var deviationCount = 0
            if movieScore == mean {
                medium.append(movie)
            } else {
                if movieScore < mean {
                    while movieScore < mean {
                        deviationCount += 2
                        movieScore += sd
                    }
                    if deviationCount >= 2 {
                        low.append(movie)
                    } else {
                        medium.append(movie)
                    }
                } else {
                    while movieScore > mean {
                        deviationCount += 2
                        movieScore -= sd
                    }
                    if deviationCount >= 2 {
                        high.append(movie)
                    } else {
                        medium.append(movie)
                    }
                }
            }
        }
    }
    
    return (Double(low.count), Double(medium.count), Double(high.count))
}

private func moviesByLikeability(movies: [Movie], recommendations: [(movie: Movie, score: Double)]) -> (low: [(movie: Movie, score: Double)], medium: [(movie: Movie, score: Double)], high: [(movie: Movie, score: Double)]) {
    var low: [(Movie, Double)] = []
    var medium: [(Movie, Double)] = []
    var high: [(Movie, Double)] = []
    let movieRecommendations: [Movie] = recommendations.map(\.movie)
    let scores: [Double] = recommendations.map(\.score)
    let mean = scores.avg()
    let sd = scores.std()
    
    for movie in movies {
        if let index = movieRecommendations.firstIndex(of: movie) {
            var movieScore = scores[index]
            var deviationCount = 0
            if movieScore == mean {
                medium.append((movie, movieScore))
            } else {
                if movieScore < mean {
                    while movieScore < mean {
                        deviationCount += 2
                        movieScore += sd
                    }
                    if deviationCount >= 2 {
                        low.append((movie, movieScore))
                    } else {
                        medium.append((movie, movieScore))
                    }
                } else {
                    while movieScore > mean {
                        deviationCount += 2
                        movieScore -= sd
                    }
                    if deviationCount >= 2 {
                        high.append((movie, movieScore))
                    } else {
                        medium.append((movie, movieScore))
                    }
                }
            }
        }
    }
    
    return (low, medium, high)
}

struct GenreMashLikeabilitySheet_Previews: PreviewProvider {
    static var previews: some View {
        GenreMashLikeabilitySheet()
    }
}

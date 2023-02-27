//
//  ChartView.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/4/22.
//

import Charts
import SwiftUI

struct RectangleChartView: View {
    @EnvironmentObject var movieData: MovieViewModel
    @Binding var selectedGenres: [Genre]
    var body: some View {
        GroupBox ("Average Ratings") {
            Chart {
                ForEach(self.selectedGenres, id: \.self) { genre in
                    RectangleMark(x: .value("Genre", genre.name),
                                  y: .value("Average Rating", AverageMovieRating(movies: self.movieData.movies.filter { $0.genres.contains(genre) })))
                    .cornerRadius(3)
                }
                if selectedGenres.count > 1 {
                    RectangleMark(x: .value("Genre", "GenreMash"),
                                  y: .value("Average Rating", AverageMovieRating(movies: FilterByGenre(movies: self.movieData.movies, genres: self.selectedGenres))))
                    .foregroundStyle(.orange)
                    .cornerRadius(3)
                }
            }
            .chartYScale(domain: LowHighGenreAverages(movies: self.movieData.movies, selectedGenres: self.selectedGenres).low...LowHighGenreAverages(movies: self.movieData.movies, selectedGenres: self.selectedGenres).high)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 15))
            .frame(height: 150)
        }
        .groupBoxStyle(CardGroupBoxStyleNoHPadding())
    }
}

private func LowHighGenreAverages(movies: [Movie], selectedGenres: [Genre]) -> (low: Double, high: Double) {
    if selectedGenres.isEmpty { return (0.0, 10.0) }
    
    var filteredMovies = FilterByGenre(movies: movies, genres: [selectedGenres[0]])
    var lowAverage = AverageMovieRating(movies: filteredMovies)
    var highAverage = lowAverage
    
    for genre in selectedGenres {
        filteredMovies = FilterByGenre(movies: movies, genres: [genre])
        let tempAverage = AverageMovieRating(movies: filteredMovies)
        if tempAverage < lowAverage { lowAverage = tempAverage }
        if tempAverage > highAverage { highAverage = tempAverage }
    }
    
    if selectedGenres.count > 1 {
        filteredMovies = FilterByGenre(movies: movies, genres: selectedGenres)
        let genreMashAverage = AverageMovieRating(movies: filteredMovies)
        if genreMashAverage < lowAverage { lowAverage = genreMashAverage }
        if genreMashAverage > highAverage { highAverage = genreMashAverage }
    }
    
    return ((lowAverage - 0.05), (highAverage + 0.05))
}

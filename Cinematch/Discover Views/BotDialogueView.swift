//
//  BotDialogueView.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/4/22.
//

import SwiftUI

struct BotDialogueView: View {
    @EnvironmentObject var movieData: MovieViewModel
    var genres: [Genre]
    @Binding var selectedGenres: [Genre]
    var body: some View {
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
                    switch self.selectedGenres.count {
                    case 0:
                        Text("Hi there! Welcome to ")
                            .foregroundColor(.secondary)
                            .font(.system(.body, design: .rounded)) +
                        Text("**CineMatch**")
                            .foregroundColor(.cyan)
                            .font(.system(.body, design: .rounded)) +
                        Text(". To get started, pick a few genres to create a custom ")
                            .foregroundColor(.secondary)
                            .font(.system(.body, design: .rounded)) +
                        Text("**GenreMash**")
                            .foregroundColor(.orange)
                            .font(.system(.body, design: .rounded)) +
                        Text(". I'll give some suggestions as you pick!")
                            .foregroundColor(.secondary)
                            .font(.system(.body, design: .rounded))
                    case 1:
                        Text("Whew, there quite a few movies that match the ").foregroundColor(.secondary).font(.system(.body, design: .rounded)) +
                        Text(self.selectedGenres[0].emoji + " " + self.selectedGenres[0].name).font(.system(.body, design: .rounded)).bold().foregroundColor(.cyan) +
                        Text(" genre (").font(.system(.body, design: .rounded)).foregroundColor(.secondary) +
                        Text(String(FilterByGenre(movies: self.movieData.movies, genres: self.selectedGenres).count)).font(.system(.body, design: .rounded)).bold().foregroundColor(.cyan) +
                        Text(" to be exact!) Try adding another genre to narrow down your potential selections.").font(.system(.body, design: .rounded)).foregroundColor(.secondary)
                    default:
                        AnyView(MovieBotDialogue(movies: self.movieData.movies, allGenres: self.genres, selectedGenres: self.selectedGenres))
                    }
                }
            }
            .padding(EdgeInsets(top: 20, leading: 15, bottom: 0, trailing: 20))
        }
        .groupBoxStyle(CardGroupBoxStyleNoHPadding())
    }
}

func AverageMovieRating(movies: [Movie]) -> Double {
    var ratingTotals = 0.0
    if movies.isEmpty { return ratingTotals }
    for movie in movies {
        ratingTotals += movie.weightedRating
    }
    return ratingTotals / Double(movies.count)
}

private func RemoveGenres(allGenres: [Genre], genresToRemove: [Genre]) -> [Genre] {
    var filteredGenres: [Genre] = allGenres
    for genre in genresToRemove {
        if let index = filteredGenres.firstIndex(of: genre) {
            filteredGenres.remove(at: index)
        }
    }
    return filteredGenres
}

private func GenreSuggestion(movies: [Movie], allGenres: [Genre], selectedGenres: [Genre]) -> Genre {
    let filteredMovies = FilterByGenre(movies: movies, genres: selectedGenres)
    let filteredGenreList = RemoveGenres(allGenres: allGenres, genresToRemove: selectedGenres)
    
    var highestRatingAverage = AverageMovieRating(movies: filteredMovies)
    var genreToSuggest = Genre(id: 0, name: "None")
    
    for genre in filteredGenreList {
        var tempSelectedGenres = selectedGenres
        tempSelectedGenres.append(genre)
        let tempFilteredMovies = FilterByGenre(movies: movies, genres: tempSelectedGenres)
        let tempAverageRating = AverageMovieRating(movies: tempFilteredMovies)
        if highestRatingAverage < tempAverageRating {
            highestRatingAverage = tempAverageRating
            genreToSuggest = genre
        }
    }
    return genreToSuggest
}

private func MovieBotDialogue(movies: [Movie], allGenres: [Genre], selectedGenres: [Genre]) -> any View {
    let suggestedGenre = GenreSuggestion(movies: movies, allGenres: allGenres, selectedGenres: selectedGenres)
    let originalFilteredMovies = FilterByGenre(movies: movies, genres: selectedGenres)
    let originalAverage = AverageMovieRating(movies: originalFilteredMovies)
    let originalAverageString = String(format: "%.2f", originalAverage)
    
    if suggestedGenre.name == "None" {
        if originalFilteredMovies.isEmpty {
            return HStack {
                Text("Bummer! It doesn't look like there are any movies that match those genres. Try removing or switching a genre.")
                    .font(.system(.body, design: .rounded)).foregroundColor(.secondary)
            }
        } else {
            return HStack {
                Text("Your genre picks are spot on! There's ").font(.system(.body, design: .rounded)).foregroundColor(.secondary) +
                Text(String(originalFilteredMovies.count)).font(.system(.body, design: .rounded)).bold().foregroundColor(.cyan) +
                Text(" movie(s) that match those genres with an average rating of ").font(.system(.body, design: .rounded)).foregroundColor(.secondary) +
                Text(originalAverageString).font(.system(.body, design: .rounded)).bold().foregroundColor(.cyan)
            }
        }
    }
    
    var tempSelectedGenres = selectedGenres
    tempSelectedGenres.append(suggestedGenre)
    tempSelectedGenres = tempSelectedGenres.sorted { $0.name < $1.name }
    
    let boostedFilteredMovies = FilterByGenre(movies: movies, genres: tempSelectedGenres)
    let boostedAverage = AverageMovieRating(movies: boostedFilteredMovies)
    let boostedAverageString = String(format: "%.2f", boostedAverage)
    
    //Pre-constructed Text Views
    let suggestedGenreAndEmoji = Text(suggestedGenre.emoji + " " + suggestedGenre.name).font(.system(.body, design: .rounded)).bold().foregroundColor(.cyan)
    
    let averageRatio = Text(originalAverageString).bold().font(.system(.body, design: .rounded)).foregroundColor(.cyan) +
    Text(" to ").font(.system(.body, design: .rounded)).foregroundColor(.secondary) +
    Text(boostedAverageString).font(.system(.body, design: .rounded)).bold().foregroundColor(.cyan)
    
    let movieCountRatio = Text(String(originalFilteredMovies.count)).font(.system(.body, design: .rounded)).bold().foregroundColor(.cyan) +
    Text(" to ").font(.system(.body, design: .rounded)).foregroundColor(.secondary) +
    Text(String(boostedFilteredMovies.count)).font(.system(.body, design: .rounded)).bold().foregroundColor(.cyan)
    
    return HStack {
        Text("Nice picks! Feeling decision fatigue? Try including the ").font(.system(.body, design: .rounded)).foregroundColor(.secondary) +
        suggestedGenreAndEmoji +
        Text(" genre to boost your average rating from ").font(.system(.body, design: .rounded)).foregroundColor(.secondary) +
        averageRatio +
        Text(" and decrease your potential options from ").font(.system(.body, design: .rounded)).foregroundColor(.secondary) +
        movieCountRatio
    }
}

struct BotDialogueView_Previews: PreviewProvider {
    static var previews: some View {
        BotDialogueView(genres: [], selectedGenres: .constant([]))
    }
}

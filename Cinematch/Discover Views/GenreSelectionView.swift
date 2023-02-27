//
//  GenreSelectionView.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/3/22.
//

import CardStack
import SwiftUI

struct GenreSelectionView: View {
    @AppStorage("tabSelection") var tabSelection = "first"
    @EnvironmentObject var movieMatchModel: MovieMatchModel
    @EnvironmentObject var movieData: MovieViewModel
    @EnvironmentObject var posterData: PosterViewModel
    @EnvironmentObject var genreViewModel: GenreViewModel
    @State var genreMash: [Genre] = []
    @State var showChartAndButton: Bool = false
    @State var showCards: Bool = false
    @State var loadingCards: Bool = false
    @State var reloadId: UUID = UUID()
    @State var showImmersiveView: Bool = false
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    GroupBox("Select Genres") {
                        ScrollView(.horizontal) {
                            HStack {
                                LazyHGrid(rows: [GridItem(.fixed(60)), GridItem(.fixed(60)), GridItem(.fixed(60))]) {
                                    ForEach(self.genreViewModel.genres, id: \.self) { genre in
                                        GenreButton(genre: genre, selectedGenres: $genreMash)
                                    }
                                }
                                .id(reloadId)
                            }
                            .padding(.horizontal, 20)
                        }
                        .frame(height: 200)
                        .scrollIndicators(.hidden)
                        .padding(.top, 5)
                    }
                    .groupBoxStyle(CardGroupBoxStyleNoHPadding())
                    
                    BotDialogueView(genres: self.genreViewModel.genres, selectedGenres: $genreMash)
                    
                    if self.showChartAndButton { RectangleChartView(selectedGenres: $genreMash) }
                    
                    HStack(spacing: 10) {
                        Button {
                            self.loadingCards = true
                            let filteredMovies = FilterByGenre(movies: movieData.movies, genres: self.genreMash)
                            if !self.movieMatchModel.recommendations.isEmpty {
                                self.movieMatchModel.filteredMovies = SortMoviesByRecommendation(movies: filteredMovies, recommendations: self.movieMatchModel.recommendations)
                            } else {
                                self.movieMatchModel.filteredMovies = filteredMovies.sorted(by: { $0.popularity > $1.popularity })
                            }
                            self.posterData.loadPosters(movies: self.movieMatchModel.filteredMovies)
                        } label: {
                            HStack {
                                Spacer()
                                Text("Explore GenreMash")
                                    .font(.system(.body, design: .rounded)).fontWeight(.medium)
                                Spacer()
                            }
                        }
                        .padding(.vertical, 12)
                        .background(self.loadingCards || !self.showChartAndButton ? Color(UIColor.systemGray5) : Color.cyan)
                        .foregroundColor(self.loadingCards || !self.showChartAndButton ? Color(UIColor.systemGray2) : .white)
                        .cornerRadius(45)
                        .disabled(self.loadingCards || !self.showChartAndButton)
                    }
                    .padding(EdgeInsets(top: 0, leading: 50, bottom: 20, trailing: 50))
                }
                .padding(.horizontal, 20)
            }
            .scrollIndicators(.hidden)
            .sheet(isPresented: $showCards) {
                AltSwipeView(model: CardStackModel<MovieWithIndex, LeftRight>(MoviesWithIndexes(movies: self.movieMatchModel.filteredMovies)), genreMash: self.genreMash)
            }
            .navigationTitle("Discover")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.genreMash.removeAll()
                        for _ in 0..<2 {
                            let randomInt = Int.random(in:  0..<self.genreViewModel.genres.count)
                            if !self.genreMash.contains(self.genreViewModel.genres[randomInt]) {
                                self.genreMash.append(self.genreViewModel.genres[randomInt])
                            }
                        }
                        self.reloadId = UUID()
                    } label: {
                        Image(systemName: "dice.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.cyan, .cyan.opacity(0.2))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.genreMash.removeAll()
                        self.reloadId = UUID()
                    } label: {
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .font(.system(.title3, design: .rounded)).fontWeight(.bold)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(self.genreMash.isEmpty ? Color(UIColor.systemGray2) : .cyan, self.genreMash.isEmpty ? Color(UIColor.systemGray5) : .cyan.opacity(0.2))
                    }
                    .disabled(self.genreMash.isEmpty)
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
        .onChange(of: self.posterData.postersLoaded) { loaded in
            if loaded && self.loadingCards {
                self.loadingCards = false
                self.showCards.toggle()
            }
        }
        .onChange(of: self.genreMash) { genreSelection in
            if genreSelection.isEmpty || FilterByGenre(movies: self.movieData.movies, genres: self.genreMash).isEmpty {
                withAnimation(.spring(response: 0.75)) {
                    self.showChartAndButton = false
                }
            } else {
                withAnimation(.spring(response: 0.75)) {
                    self.showChartAndButton = true
                }
            }
        }
    }
    private func SortMoviesByRecommendation(movies: [Movie], recommendations: [(movie: Movie, score: Double)]) -> [Movie] {
        var sorted: [Movie] = []
        
        for recommendation in recommendations {
            if movies.contains(recommendation.movie) {
                sorted.append(recommendation.movie)
            }
        }
        return sorted
    }
}

struct MovieWithIndex: Identifiable {
    let id = UUID()
    var movie: Movie
    var index: Int
}

func MoviesWithIndexes(movies: [Movie]) -> [MovieWithIndex] {
    var moviesWithIndex: [MovieWithIndex] = []
    for index in movies.indices {
        moviesWithIndex.append(MovieWithIndex(movie: movies[index], index: index))
    }
    return moviesWithIndex
}

func FilterByGenre(movies: [Movie], genres: [Genre]) -> [Movie] {
    if genres.isEmpty { return movies }
    var filteredMovies: [Movie] = []
    for movie in movies {
        var genreMissing = false
        for genre in genres {
            if !movie.genres.contains(genre) { genreMissing = true }
        }
        if !genreMissing { filteredMovies.append(movie) }
    }
    return filteredMovies
}

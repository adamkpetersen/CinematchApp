//
//  CineMatchesView.swift
//  Cinematch
//
//  Created by Adam Petersen on 10/24/22.
//

import SwiftUI

struct CineMatchesView: View {
    @AppStorage("tabSelection") var tabSelection = "second"
    @EnvironmentObject var movieMatchModel: MovieMatchModel
    @State var selectedMovie: Movie? = nil
    @State private var sortSelection = 1
    var body: some View {
        NavigationView {
            VStack {
                if movieMatchModel.likedMovies.isEmpty {
                    VStack(spacing: 10) {
                        Spacer()
                        Image(systemName: "heart.slash")
                            .font(.system(size: 45, weight: .bold))
                            .foregroundColor(Color(UIColor.systemGray4))
                        VStack(spacing: 2) {
                            Text("No Matches...Yet")
                                .font(.system(.footnote, design: .rounded)).bold()
                            Text("Swipe right on your favorite movies")
                                .font(.system(.footnote, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Spacer()
                        }
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(self.movieMatchModel.genreMashes, id: \.self) { genreMash in
                            if let movies = self.movieMatchModel.likedMovies.filter { $0.genreMash == genreMash }.map(\.movie) {
                                Section {
                                    ForEach(sortBySelection(movies: movies, selection: self.sortSelection), id: \.self) { movie in
                                        Button {
                                            self.selectedMovie = movie
                                        } label: {
                                            MovieMatchRow(movie: movie, genreMash: genreMash)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                } header: {
                                    GenreMashSectionHeader(genreMash: genreMash, movieCount: movies.count)
                                }
                            }
                        }
                    }
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .sheet(item: $selectedMovie) { movie in
                MovieDetailSheet(movie: movie)
            }
            .onAppear {
                self.movieMatchModel.recentlyLikedMovieCount = 0
            }
            .navigationTitle("CineMatches")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Sort Options", selection: $sortSelection) {
                            Label("Alphabetical", systemImage: "abc").tag(1)
                            Label("Highest Rated", systemImage: "star").tag(2)
                            Label("Most Popular", systemImage: "hand.thumbsup").tag(3)
                            Label("Order Swiped", systemImage: "rectangle.and.hand.point.up.left").tag(4)
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                            .font(.title3).bold()
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.cyan, .cyan.opacity(0.2))
                    }
                }
            }
        }
    }
}

func sortBySelection(movies: [Movie], selection: Int) -> [Movie] {
    if selection == 1 { return movies.sorted { return $0.title < $1.title } }
    if selection == 2 { return movies.sorted { return $0.weightedRating > $1.weightedRating } }
    if selection == 3 { return movies.sorted { return $0.popularity > $1.popularity } }
    return movies
}

func TitleAndYearString(movie: Movie) -> String {
    return movie.title + " (" + String(movie.year) + ")"
}

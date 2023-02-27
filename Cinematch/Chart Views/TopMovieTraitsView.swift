//
//  TopMovieTraitsView.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/14/22.
//

import SwiftUI

struct TopMovieTraitsView: View {
    @EnvironmentObject var movieMatchModel: MovieMatchModel
    @State var topTraits: (favGenre: Genre, favKeyword: String, leastFavGenre: Genre, leastFavKeyword: String) = (Genre(id: 1000, name: "No Data"), "No Data", Genre(id: 1000, name: "No Data"), "No Data")
    var body: some View {
        GroupBox("Swipe Stats") {
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    HStack {
                        Spacer()
                        VStack {
                            Text(String(self.movieMatchModel.likedMovies.count))
                                .font(.system(.title, design: .rounded)).bold()
                                .foregroundColor(.cyan)
                            Text("Liked Movies")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .frame(height: 75)
                    .background(Color(UIColor.tertiarySystemGroupedBackground))
                    .cornerRadius(10)
                    HStack {
                        Spacer()
                        VStack {
                            Text(String(self.movieMatchModel.dislikedMovies.count))
                                .font(.system(.title, design: .rounded)).bold()
                                .foregroundColor(.cyan)
                            Text("Disliked Movies")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .frame(height: 75)
                    .background(Color(UIColor.tertiarySystemGroupedBackground))
                    .cornerRadius(10)
                }
                HStack(spacing: 10) {
                    HStack {
                        Spacer()
                        VStack(spacing: 3) {
                            Text("Liked Genre")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(.secondary)
                            Text(self.topTraits.favGenre.emoji + " " + self.topTraits.favGenre.name)
                                .font(.system(.headline, design: .rounded)).bold()
                                .foregroundColor(.green)
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    .frame(height: 75)
                    .background(Color(UIColor.tertiarySystemGroupedBackground))
                    .cornerRadius(10)
                    HStack {
                        Spacer()
                        VStack(spacing: 3) {
                            Text("Liked Keyword")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(.secondary)
                            Text(self.topTraits.favKeyword.capitalized)
                                .font(.system(.headline, design: .rounded)).bold()
                                .foregroundColor(.green)
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    .frame(height: 75)
                    .background(Color(UIColor.tertiarySystemGroupedBackground))
                    .cornerRadius(10)
                }
                HStack(spacing: 10) {
                    HStack {
                        Spacer()
                        VStack(spacing: 3) {
                            Text("Disliked Genre")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(.secondary)
                            Text(self.topTraits.leastFavGenre.emoji + " " + self.topTraits.leastFavGenre.name)
                                .font(.system(.headline, design: .rounded)).bold()
                                .foregroundColor(.red)
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    .frame(height: 75)
                    .background(Color(UIColor.tertiarySystemGroupedBackground))
                    .cornerRadius(10)
                    HStack {
                        Spacer()
                        VStack(spacing: 3) {
                            Text("Disliked Keyword")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(.secondary)
                            Text(self.topTraits.leastFavKeyword.capitalized)
                                .font(.system(.headline, design: .rounded)).bold()
                                .foregroundColor(.red)
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    .frame(height: 75)
                    .background(Color(UIColor.tertiarySystemGroupedBackground))
                    .cornerRadius(10)
                }
            }
            .padding(.top, 5)
        }
        .groupBoxStyle(CardGroupBoxStyle())
        .onAppear {
            self.topTraits = topMovieTraits(likedMovies: self.movieMatchModel.likedMovies.map(\.movie), dislikedMovies: self.movieMatchModel.dislikedMovies)
        }
        .onChange(of: self.movieMatchModel.likedMovies.map(\.movie)) { movies in
            self.topTraits = topMovieTraits(likedMovies: movies, dislikedMovies: self.movieMatchModel.dislikedMovies)
        }
        .onChange(of: self.movieMatchModel.dislikedMovies) { movies in
            self.topTraits = topMovieTraits(likedMovies: self.movieMatchModel.likedMovies.map(\.movie), dislikedMovies: movies)
        }
    }
}

private func topMovieTraits(likedMovies: [Movie], dislikedMovies: [Movie]) -> (favGenre: Genre, favKeyword: String, leastFavGenre: Genre, leastFavKeyword: String) {
    var favGenres: [Genre] = []
    var favKeywords: [Keyword] = []
    var leastFavGenres: [Genre] = []
    var leastFavKeywords: [Keyword] = []
    
    var favGenre: (genre: Genre, count: Int) = (Genre(id: 0, name: "No Data"), 0)
    var favKeyword: (keyword: Keyword, count: Int) = (Keyword(id: 0, name: "No Data"), 0)
    var leastFavGenre: (genre: Genre, count: Int) = (Genre(id: 0, name: "No Data"), 0)
    var leastFavKeyword: (keyword: Keyword, count: Int) = (Keyword(id: 0, name: "No Data"), 0)
    
    for array in likedMovies.map(\.genres) { favGenres += array }
    for array in likedMovies.map(\.keywords) { favKeywords += array }
    for array in dislikedMovies.map(\.genres) { leastFavGenres += array }
    for array in dislikedMovies.map(\.keywords) { leastFavKeywords += array }
    
    favKeywords = favKeywords.filter { $0.id != 179430 && $0.id != 179431  && $0.id != 209714} ///Removing stinger-related keywords
    leastFavKeywords = leastFavKeywords.filter { $0.id != 179430 && $0.id != 179431 && $0.id != 209714} ///Removing stinger-related keywords
    
    for genre in favGenres {
        let genreCount = favGenres.filter { $0 == genre }.count
        if genreCount > favGenre.count {
            favGenre = (genre, genreCount)
        }
    }
    
    for keyword in favKeywords {
        let keywordCount = favKeywords.filter { $0 == keyword }.count
        if keywordCount > favKeyword.count {
            favKeyword = (keyword, keywordCount)
        }
    }
    
    for genre in leastFavGenres {
        let genreCount = leastFavGenres.filter { $0 == genre }.count
        if genreCount > leastFavGenre.count {
            leastFavGenre = (genre, genreCount)
        }
    }
    
    for keyword in leastFavKeywords {
        let keywordCount = leastFavKeywords.filter { $0 == keyword }.count
        if keywordCount > leastFavKeyword.count {
            leastFavKeyword = (keyword, keywordCount)
        }
    }
    
    return (favGenre.genre, favKeyword.keyword.name, leastFavGenre.genre, leastFavKeyword.keyword.name)
}

struct TopMovieTraitsView_Previews: PreviewProvider {
    static var previews: some View {
        TopMovieTraitsView()
    }
}

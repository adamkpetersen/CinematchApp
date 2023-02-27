//
//  FavoriteButton.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/17/22.
//

import SwiftUI

struct FavoriteButton: View {
    @EnvironmentObject var movieMatchModel: MovieMatchModel
    var isLiked: Bool {
        self.movieMatchModel.likedMovies.map(\.movie).contains(self.movie)
    }
    @State var movie: Movie
    @State var customGenreMash: [Genre]?
    @State var altStyle: Bool?
    @State var altSize: Bool?
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.25)) {
                var genreMash = [Genre(id: 100, name: "A.I.")]
                if let mash = customGenreMash { genreMash = mash }
                let likedMovie = (movie: self.movie, genreMash: genreMash)
                if self.isLiked {
                    self.movieMatchModel.likedMovies.removeAll(where: { $0 == likedMovie })
                    if !self.movieMatchModel.likedMovies.map(\.genreMash).contains(genreMash) {
                        self.movieMatchModel.genreMashes.removeAll(where: { $0 == genreMash })
                    }
                } else {
                    if !self.movieMatchModel.likedMovies.contains(where: { $0 == likedMovie }) {
                        if !self.movieMatchModel.genreMashes.contains(genreMash) {
                            self.movieMatchModel.genreMashes.insert(genreMash, at: 0)
                        }
                        self.movieMatchModel.likedMovies.append((self.movie, genreMash))
                        self.movieMatchModel.recentlyLikedMovieCount += 1
                        self.movieMatchModel.dislikedMovies.removeAll(where: { $0 == self.movie })
                    }
                }
            }
        } label: {
            if altStyle != nil {
                if self.isLiked {
                    Image(systemName: "heart.fill")
                        .font(.title).bold()
                        .foregroundColor(.green)
                        .shadow(color: Color.black.opacity(0.5), radius: 3, x: 0, y: 1)
                } else {
                    Image(systemName: "heart.fill")
                        .font(.title).bold()
                        .foregroundColor(.white.opacity(0.8))
                        .shadow(color: Color.black.opacity(0.5), radius: 3, x: 0, y: 1)
                }
            } else {
                if self.isLiked {
                    Image(systemName: "heart.fill")
                        .font(altSize != nil ? .body : .title2)
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "heart")
                        .font(altSize != nil ? .body : .title2)
                        .foregroundColor(.green)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

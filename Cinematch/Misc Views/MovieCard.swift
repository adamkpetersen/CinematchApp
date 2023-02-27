//
//  MovieCard.swift
//  Cinematch
//
//  Created by Adam Petersen on 10/19/22.
//

import CardStack
import SwiftUI

struct MovieCard: View {
    @EnvironmentObject var movieMatchModel: MovieMatchModel
    @EnvironmentObject var posterData: PosterViewModel
    var likedMovie: Bool { self.movieMatchModel.likedMovies.map(\.movie).contains(self.movie) }
    var dislikedMovie: Bool { self.movieMatchModel.dislikedMovies.contains(self.movie) }
    var posterInfo: Poster { posterData.posters.first(where: { $0.id == movie.id}) ?? Poster(id: 1) }
    var movie: Movie
    var direction: LeftRight?
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                AsyncImage(url: posterInfo.posterURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: geometry.size.height, alignment: .top)
                } placeholder: {
                    Image("loading")
                        .resizable()
                        .scaledToFill()
                        .frame(height: geometry.size.height)
                }
            }
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .top, spacing: 4) {
                        Text(String(format: "%.1f", self.movie.weightedRating))
                            .font(.system(.caption2, design: .rounded)).bold()
                            .padding(.top, 1)
                        Image(systemName: "star.fill")
                            .font(.caption2).foregroundColor(.yellow)
                    }
                    HStack {
                        Text(self.movie.title + " (" + String(self.movie.year) + ")")
                            .font(.system(.title3, design: .rounded)).bold()
                            .lineLimit(1)
                        Spacer()
                    }
                    HStack(spacing: 0) {
                        ForEach(self.movie.genres.indices, id: \.self) { inx in
                            Text(self.movie.genres.count == inx + 1 ? self.movie.genres[inx].name : self.movie.genres[inx].name + " / ")
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }
                }
                .padding(EdgeInsets(top: 15, leading: 20, bottom: 20, trailing: 20))
                .background(.ultraThinMaterial)
            }
            VStack {
                HStack {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .foregroundColor(.green)
                        .frame(width: 65, height: 60)
                        .opacity(self.likedMovie || self.direction == .right ? 1:0)
                        .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 1)
                    Spacer()
                    Image(systemName: "xmark")
                        .resizable()
                        .foregroundColor(.red)
                        .frame(width: 65, height: 65)
                        .opacity(self.dislikedMovie || self.direction == .left ? 1:0)
                        .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 1)
                }
                Spacer()
            }
            .padding(EdgeInsets(top: 30, leading: 30, bottom: 0, trailing: 30))
        }
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 7, x: 0, y: 1)
    }
}

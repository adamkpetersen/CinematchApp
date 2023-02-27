//
//  MovieMatchRow.swift
//  Cinematch
//
//  Created by Adam Petersen on 10/26/22.
//

import SwiftUI

struct MovieMatchRow: View {
    @EnvironmentObject var movieMatchModel: MovieMatchModel
    @EnvironmentObject var posterData: PosterViewModel
    @State var movie: Movie
    @State var genreMash: [Genre]?
    var ranking: Int? = nil
    var posterInfo: Poster { posterData.posters.first(where: { $0.id == movie.id}) ?? Poster(id: 1) }
    var body: some View {
        HStack {
            ZStack {
                AsyncImage(url: posterInfo.posterURL) { posterImage in
                    posterImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .cornerRadius(7)
                } placeholder: {
                    Image("loading")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .cornerRadius(7)
                }
                if let value = ranking {
                    Image(systemName: "\(value).circle.fill")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.title)
                        .shadow(color: Color.black.opacity(1), radius: 3, x: 0, y: 1)
                }
            }
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 4) {
                    Text(String(format: "%.1f", self.movie.weightedRating))
                        .font(.system(.caption2, design: .rounded))
                        .padding(.top, 1)
                    Image(systemName: "star.fill")
                        .font(.caption2).foregroundColor(.yellow)
                }
                Text(self.movie.title)
                    .font(.system(.headline, design: .rounded))
                    .lineLimit(1)
                Text(String(self.movie.year))
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.secondary)
            }
            Spacer()
            FavoriteButton(movie: self.movie, customGenreMash: genreMash)
        }
    }
}

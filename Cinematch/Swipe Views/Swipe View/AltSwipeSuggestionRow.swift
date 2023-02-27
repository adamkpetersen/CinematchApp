//
//  AltSwipeSuggestionRow.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/18/22.
//

import SwiftUI

struct AltSwipeSuggestionRow: View {
    @EnvironmentObject var movieMatchModel: MovieMatchModel
    @EnvironmentObject var posterData: PosterViewModel
    @State var movie: Movie
    var posterInfo: Poster { posterData.posters.first(where: { $0.id == movie.id}) ?? Poster(id: 1) }
    var body: some View {
        ZStack {
            AsyncImage(url: posterInfo.posterURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 150)
            } placeholder: {
                Image("loading")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 150)
            }
            FavoriteButton(movie: self.movie, altStyle: true)
        }
        .cornerRadius(10)
        .padding(.vertical, 5)
    }
}

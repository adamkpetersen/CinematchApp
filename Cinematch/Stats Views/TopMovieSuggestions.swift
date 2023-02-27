//
//  TopMovieSuggestions.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/16/22.
//

import SwiftUI

struct TopMovieSuggestions: View {
    @EnvironmentObject var posterData: PosterViewModel
    @EnvironmentObject var movieMatchModel: MovieMatchModel
    @State var loadingPosters: Bool = false
    @State var topMovies: [Movie] = []
    @Binding var selectedMovie: Movie?
    var body: some View {
        GroupBox("Top 🤖 Picks") {
            if self.topMovies.isEmpty {
                HStack {
                    Spacer()
                    Text("No Prediction Data Yet")
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .frame(height: 200)
                .background(Color(UIColor.tertiarySystemGroupedBackground))
                .cornerRadius(10)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
            } else {
                ForEach(0..<self.topMovies.count, id: \.self) { index in
                    HStack {
                        Spacer()
                        Button {
                            self.selectedMovie = self.topMovies[index]
                        } label: {
                            MovieMatchRow(movie: self.topMovies[index], ranking: (index + 1))
                        }
                        .buttonStyle(.plain)
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 10, leading: 3, bottom: 10, trailing: 5))
                    .background(Color(UIColor.tertiarySystemGroupedBackground).opacity(0.8))
                    .cornerRadius(10)
                    .padding(.vertical, 5)
                }
            }
        }
        .groupBoxStyle(CardGroupBoxStyle())
        .onAppear {
            if !self.movieMatchModel.recommendations.isEmpty {
                self.topMovies = self.movieMatchModel.recommendations.prefix(10).map(\.movie)
            }
        }
    }
}

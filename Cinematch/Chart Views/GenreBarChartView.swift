//
//  GenreBarChartView.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/14/22.
//

import Charts
import SwiftUI

struct GenreBarChartView: View {
    @EnvironmentObject var movieMatchModel: MovieMatchModel
    @State private var movieListPicker = 0
    var body: some View {
        GroupBox("Genre Insights") {
            if self.movieMatchModel.likedMovies.isEmpty {
                HStack {
                    Spacer()
                    Text(movieListPicker == 0 ? "No Data Yet" : "No Prediction Data Yet")
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .frame(height: 200)
                .background(Color(UIColor.tertiarySystemGroupedBackground))
                .cornerRadius(10)
                .padding(EdgeInsets(top: 5, leading: 0, bottom: 20, trailing: 0))
            } else {
                Chart {
                    if movieListPicker == 0 {
                        ForEach(self.movieMatchModel.likedMovies.map(\.movie), id: \.self) { movie in
                            ForEach(movie.genres, id: \.self) { genre in
                                BarMark(
                                    x: .value("Genre", genre.emoji),
                                    y: .value("Count", 1)
                                )
                                .cornerRadius(3)
                            }
                        }
                    }  else {
                        ForEach(getTopMovies(recommendations: self.movieMatchModel.recommendations), id: \.self) { movie in
                            ForEach(0..<(movie.genres.count < 3 ? movie.genres.count : 3), id: \.self) { index in
                                BarMark(
                                    x: .value("Genre", movie.genres[index].emoji),
                                    y: .value("Count", 1))
                                .cornerRadius(3)
                            }
                        }
                    }
                }
                .frame(height: 250)
                .padding(EdgeInsets(top: 5, leading: 0, bottom: 20, trailing: 0))
            }
            Picker("Genre Source", selection: $movieListPicker) {
                Text("My CineMatches").tag(0)
                Text("Top 🤖 Picks").tag(1)
            }
            .pickerStyle(.segmented)
        }
        .groupBoxStyle(CardGroupBoxStyle())
    }
}

private func getTopMovies(recommendations: [(movie: Movie, score: Double)]) -> [Movie] {
    return Array(recommendations.map(\.movie).prefix(10))
}

struct GenreBarChartView_Previews: PreviewProvider {
    static var previews: some View {
        GenreBarChartView()
    }
}

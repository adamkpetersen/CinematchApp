//
//  MovieDetailSheet.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/3/22.
//

import SwiftUI

struct MovieDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var posterData: PosterViewModel
    @State var movie: Movie
    @State var genreMash: [Genre]?
    var posterInfo: Poster { posterData.posters.first(where: { $0.id == movie.id}) ?? Poster(id: 1) }
    var body: some View {
        NavigationView {
            List {
                Section {
                    VStack {
                            AsyncImage(url: self.posterInfo.posterURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 225)
                            } placeholder: {
                                Image("loading")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 225)
                            }
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 1)
                        HStack(spacing: 2) {
                            Spacer()
                            ForEach(0..<Int(self.movie.weightedRating)) {_ in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            }
                            ForEach(0..<(10 - Int(self.movie.weightedRating))) {_ in
                                Image(systemName: "star.fill")
                                    .foregroundColor(Color(UIColor.systemGray4))
                            }
                            Spacer()
                        }
                        .padding(5)
                    }
                }
                Section("Overview") {
                    Text(self.movie.overview)
                        .font(.system(.body, design: .rounded))
                }
                Section("Details") {
                    HStack {
                        Text("Release Year")
                            .foregroundColor(.secondary)
                            .font(.system(.body, design: .rounded))
                        Spacer()
                        Text(String(self.movie.year))
                            .font(.system(.body, design: .rounded))
                    }
                    HStack {
                        Text("Rating")
                            .foregroundColor(.secondary)
                            .font(.system(.body, design: .rounded))
                        Spacer()
                        Text(String(format: "%.2f", self.movie.weightedRating))
                            .font(.system(.body, design: .rounded))
                    }
                    HStack {
                        Text("Total Runtime")
                            .foregroundColor(.secondary)
                            .font(.system(.body, design: .rounded))
                        Spacer()
                        Text(String(self.movie.runtime) + " min")
                            .font(.system(.body, design: .rounded))
                    }
                    HStack {
                        Text("Budget")
                            .foregroundColor(.secondary)
                            .font(.system(.body, design: .rounded))
                        Spacer()
                        Text("$" + String(self.movie.budget))
                            .font(.system(.body, design: .rounded))
                    }
                }
                Section("Genres") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                        ForEach(self.movie.genres, id: \.self) { genre in
                            VStack {
                                Text(genre.emoji)
                                Spacer()
                                Text(genre.name)
                                    .font(.system(.caption, design: .rounded, weight: .medium))
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                            .frame(width: 65, height: 35)
                            .padding(10)
                            .background(Color(UIColor.tertiarySystemGroupedBackground).opacity(0.7))
                            .cornerRadius(15.0)
                        }
                    }
                }
            }
            .navigationTitle(self.movie.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    FavoriteButton(movie: self.movie, customGenreMash: genreMash, altSize: true)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }.bold()
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

//
//  AltSwipeSuggestionView.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/18/22.
//

import SwiftUI

struct AltSwipeSuggestionView: View {
    @EnvironmentObject var posterData: PosterViewModel
    @EnvironmentObject var movieMatchModel: MovieMatchModel
    @State var topSuggestions: [Movie] = []
    @State var updateSuggestions: Int = 0
    @State var posterCallSent: Bool = false
    @State var selectedMovie: Movie?
    var body: some View {
        VStack(alignment: .leading) {
            Text("🤖 Suggestions")
                .font(.system(.headline, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.bottom, -5)
            ScrollView(.horizontal) {
                if self.topSuggestions.isEmpty {
                    HStack(spacing: 10) {
                        ForEach(0..<10) { _ in
                            VStack {
                                Group {
                                    Text("No")
                                    Text("Suggestions")
                                    Text("Yet")
                                }
                                .font(.system(.caption, design: .rounded)).bold()
                                .foregroundColor(.white)
                            }
                            .frame(width: 100, height: 150)
                            .background(.ultraThinMaterial.opacity(0.5))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 1)
                            .padding(.vertical, 5)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                HStack(spacing: 10) {
                    ForEach(self.topSuggestions, id: \.self) { movie in
                        Button {
                            self.selectedMovie = movie
                        } label: {
                            AltSwipeSuggestionRow(movie: movie)
                                .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 1)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
            .scrollIndicators(.hidden)
        }
        .sheet(item: $selectedMovie) { movie in
            MovieDetailSheet(movie: movie)
        }
        .onAppear {
            if !self.movieMatchModel.recommendations.isEmpty {
                withAnimation(.spring(response: 0.5)) {
                    self.topSuggestions = self.movieMatchModel.recommendations.prefix(10).map(\.movie)
                }
            }
        }
        .onChange(of: self.movieMatchModel.recommendations.prefix(10).map(\.movie)) { movies in
            self.posterCallSent = true
            self.posterData.loadPosters(movies: movies)
        }
        .onChange(of: posterData.postersLoaded) { loaded in
            if posterCallSent && loaded {
                withAnimation(.spring(response: 0.5)) {
                    self.topSuggestions = self.movieMatchModel.recommendations.prefix(10).map(\.movie)
                }
                self.posterCallSent = false
            }
        }
    }
}


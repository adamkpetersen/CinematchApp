//
//  StatsView.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/4/22.
//

import SwiftUI

struct StatsView: View {
    @AppStorage("tabSelection") var tabSelection = "third"
    @EnvironmentObject var movieData: MovieViewModel
    @EnvironmentObject var movieMatchModel: MovieMatchModel
    @State private var isPresentingAlert: Bool = false
    @State var refreshToken: UUID = UUID()
    @State var selectedMovie: Movie? = nil
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    GroupBox {
                        HStack(alignment: .top, spacing: 12) {
                            ZStack {
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.pink.opacity(0.5))
                                Text("🤖")
                                    .font(.title)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Movie Bot")
                                    .font(.system(.headline, design: .rounded))
                                    .foregroundColor(.primary)
                                    .foregroundColor(Color(UIColor.systemGray3))
                                Text("The more you swipe, the smarter I get! Here are some insights based on your current CineMatches:")
                                    .font(.system(.body, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(EdgeInsets(top: 20, leading: 15, bottom: 0, trailing: 20))
                    }
                    .groupBoxStyle(CardGroupBoxStyleNoHPadding())
                    
                    TopMovieTraitsView()
                    
                    GenreBarChartView()
                    
                    TopMovieSuggestions(selectedMovie: $selectedMovie)
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 30, trailing: 20))
                .sheet(item: $selectedMovie) { movie in
                    MovieDetailSheet(movie: movie)
                }
            }
            .id(refreshToken)
            .background(Color(UIColor.systemGroupedBackground))
            .scrollIndicators(.hidden)
            .onAppear { self.refreshToken = UUID() }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(role: .destructive) {
                            isPresentingAlert = true
                        } label: {
                            Label("Clear All History", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.title3).bold()
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.cyan, .cyan.opacity(0.2))
                    }
                    .confirmationDialog("Are you sure?", isPresented: $isPresentingAlert) {
                        Button("Clear all swipe history?", role: .destructive) {
                            self.movieMatchModel.likedMovies.removeAll()
                            self.movieMatchModel.dislikedMovies.removeAll()
                            self.movieMatchModel.recommendations.removeAll()
                            self.movieMatchModel.genreMashes.removeAll()
                            self.refreshToken = UUID()
                        }
                    }
                }
            }
            .navigationTitle("Stats")
        }
    }
}

private func getMovies(recommendations: [(movie: Movie, score: Double)]) -> [Movie] {
    return recommendations.map(\.movie)
}

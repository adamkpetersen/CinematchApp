//
//  AltSwipeButtons.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/18/22.
//

import SwiftUI
import CardStack

struct AltSwipeButtons: View {
    @EnvironmentObject var movieViewModel: MovieViewModel
    @EnvironmentObject var movieMatchModel: MovieMatchModel
    @EnvironmentObject var genreViewModel: GenreViewModel
    @Binding var model: CardStackModel<MovieWithIndex, LeftRight>
    @Binding var modelIndex: Int
    @Binding var genreMash: [Genre]
    @State var likeTapped: Bool = false
    @State var dislikeTapped: Bool = false
    @State var backTapped: Bool = false
    var moviesRemaining: Int { self.movieMatchModel.filteredMovies.count - self.modelIndex }
    var body: some View {
        HStack {
            Button {
                self.dislikeTapped.toggle()
                let movie = self.movieMatchModel.filteredMovies[self.modelIndex]
                movieMatchModel.FilterMovie(movie: movie, genreMash: self.genreMash, allMovies: self.movieViewModel.movies, allGenres: self.genreViewModel.genreStrings, direction: .left)
                self.modelIndex+=1
                withAnimation { self.model.swipe(direction: .left, completion: nil) }
                Task {
                    try await Task.sleep(nanoseconds: 300_000_000)
                    self.dislikeTapped.toggle()
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(self.dislikeTapped ? .red : .white)
                    .frame(width: 80, height: 80)
            }
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            .disabled(moviesRemaining == 0 || self.dislikeTapped)
            Spacer()
            Button {
                self.backTapped.toggle()
                withAnimation {
                    self.model.unswipe()
                    self.modelIndex-=1
                }
                Task {
                    try await Task.sleep(nanoseconds: 300_000_000)
                    self.backTapped.toggle()
                }
            } label: {
                Image(systemName: "arrow.uturn.backward")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(self.backTapped ? .cyan : .white)
                    .frame(width: 80, height: 80)
            }
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            .disabled(self.moviesRemaining == self.model.numberOfElements || self.backTapped)
            Spacer()
            Button {
                self.likeTapped.toggle()
                let movie = self.movieMatchModel.filteredMovies[self.modelIndex]
                self.movieMatchModel.FilterMovie(movie: movie, genreMash: self.genreMash, allMovies: self.movieViewModel.movies, allGenres: self.genreViewModel.genreStrings, direction: .right)
                self.modelIndex+=1
                withAnimation { self.model.swipe(direction: .right, completion: nil) }
                Task {
                    try await Task.sleep(nanoseconds: 300_000_000)
                    self.likeTapped.toggle()
                }
            } label: {
                Image(systemName: "heart.fill")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(likeTapped ? .green : .white)
                    .frame(width: 80, height: 80)
            }
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            .disabled(moviesRemaining == 0 || self.likeTapped)
        }
    }
}

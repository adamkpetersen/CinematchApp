//
//  AltSwipeView.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/18/22.
//

import CardStack
import SwiftUI

struct AltSwipeView: View {
    @AppStorage("tabSelection") var tabSelection = "first"
    @EnvironmentObject var movieViewModel: MovieViewModel
    @EnvironmentObject var movieMatchModel: MovieMatchModel
    @EnvironmentObject var genreViewModel: GenreViewModel
    @State var showLikeability: Bool = false
    @State var startOver: Bool = false
    @State var reloadToken = UUID()
    @State var modelIndex: Int = 0
    @State var posterImage: Image = Image("black")
    @State var backgroundGradient: LinearGradient = LinearGradient(colors: [Color.gray, Color.black.opacity(0.1)], startPoint: .top, endPoint: .bottom)
    @State var selectedMovie: Movie? = nil
    @State var model: CardStackModel<MovieWithIndex, LeftRight>
    var moviesRemaining: Int { self.movieMatchModel.filteredMovies.count - self.modelIndex }
    @State var genreMash: [Genre]
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        if !startOver {
                            CardStack(
                                model: self.model,
                                onSwipe: { movie, direction in
                                    self.modelIndex+=1
                                    self.movieMatchModel.FilterMovie(movie: movie.movie, genreMash: self.genreMash, allMovies: self.movieViewModel.movies, allGenres: self.genreViewModel.genreStrings, direction: direction)
                                },
                                content: { movie, direction in
                                    AltMovieCard(movie: movie.movie, direction: direction, posterImage: $posterImage, modelIndex: $modelIndex, cardCount: movie.index)
                                        .onTapGesture { self.selectedMovie = movie.movie }
                                }
                            )
                            .environment(\.cardStackConfiguration, CardStackConfiguration(
                                maxVisibleCards: 3,
                                swipeThreshold: 0.1,
                                cardOffset: 10,
                                cardScale: 0.1,
                                animation: .linear
                            ))
                            .id(reloadToken)
                            .frame(height: (geometry.size.height / 1.8))
                            .padding(.bottom, 20) ///Offset padding
                            Spacer()
                            AltSwipeButtons(model: $model, modelIndex: $modelIndex, genreMash: $genreMash)
                                .padding(.horizontal, 30)
                            Spacer()
                        } else {
                            VStack {
                                Spacer()
                                Button {
                                    self.reloadToken = UUID()
                                    self.model = CardStackModel<MovieWithIndex, LeftRight>(MoviesWithIndexes(movies: self.movieMatchModel.filteredMovies))
                                    self.modelIndex = 0
                                    withAnimation { self.startOver = false }
                                } label: {
                                    Image(systemName: "arrow.counterclockwise.circle.fill")
                                        .resizable()
                                        .frame(width: 65, height: 65)
                                }
                                .padding(.bottom, 10)
                                HStack {
                                    Spacer()
                                    Text("Nice swiping! Start Over?")
                                        .font(.system(.subheadline, design: .rounded))
                                        .foregroundColor(.secondary)
                                    Spacer()
                                }
                                Spacer()
                            }
                            .background(.ultraThinMaterial)
                            .cornerRadius(20)
                            .padding(.bottom, 20)
                        }
                    }
                    .padding(.horizontal, 20)
                    AltSwipeSuggestionView()
                }
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 20, trailing: 0))
            }
            .background(self.backgroundGradient)
            .onChange(of: self.posterImage) { image in
                let color = ImageRenderer(content: image).uiImage?.averageColor ?? UIColor.gray
                self.backgroundGradient = LinearGradient(colors: [Color(uiColor: color), Color.black.opacity(0.1)], startPoint: .top, endPoint: .bottom)
            }
            .onChange(of: self.moviesRemaining) { remaining in
                if remaining == 0 { withAnimation(.spring(response: 1)) { self.startOver = true } }
            }
            .sheet(item: $selectedMovie) { movie in
                MovieDetailSheet(movie: movie, genreMash: self.genreMash)
            }
            .sheet(isPresented: $showLikeability) { GenreMashLikeabilitySheet() }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 4) {
                        Image(systemName: "popcorn.fill")
                            .font(.system(.caption2, design: .rounded))
                        Text(String(self.moviesRemaining))
                            .font(.system(.caption, design: .rounded, weight: .bold))
                    }
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                        .background(.white.opacity(0.2))
                        .cornerRadius(45)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 1)
                }
                ToolbarItem(placement: .principal) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white.opacity(0.2))
                        .frame(width: 50, height: 5)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 1)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.showLikeability.toggle()
                    } label: {
                        ZStack {
                            Image(systemName: "circle.fill")
                                .font(.title2).bold()
                                .foregroundColor(.white.opacity(0.2))
                            Image(systemName: "chart.bar.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.white)
                        }
                    }
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 1)
                }
            }
        }
    }
}

extension UIImage {
    /// Average color of the image, nil if it cannot be found
    var averageColor: UIColor {
        // convert our image to a Core Image Image
        guard let inputImage = CIImage(image: self) else { return UIColor.gray }

        // Create an extent vector (a frame with width and height of our current input image)
        let extentVector = CIVector(x: inputImage.extent.origin.x,
                                    y: inputImage.extent.origin.y,
                                    z: inputImage.extent.size.width,
                                    w: inputImage.extent.size.height)

        // create a CIAreaAverage filter, this will allow us to pull the average color from the image later on
        guard let filter = CIFilter(name: "CIAreaAverage",
                                  parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return UIColor.gray }
        guard let outputImage = filter.outputImage else { return UIColor.gray }

        // A bitmap consisting of (r, g, b, a) value
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])

        // Render our output image into a 1 by 1 image supplying it our bitmap to update the values of (i.e the rgba of the 1 by 1 image will fill out bitmap array
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)

        // Convert our bitmap images of r, g, b, a to a UIColor
        return UIColor(red: CGFloat(bitmap[0]) / 255,
                       green: CGFloat(bitmap[1]) / 255,
                       blue: CGFloat(bitmap[2]) / 255,
                       alpha: CGFloat(bitmap[3]) / 255)
    }
}

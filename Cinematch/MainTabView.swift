//
//  TabView.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/3/22.
//

import SwiftUI

struct MainTabView: View {
    @AppStorage("newUser") var newUser: Bool = true
    @AppStorage("tabSelection") var tabSelection = "first"
    @StateObject var movieViewModel = MovieViewModel()
    @StateObject var movieMatchModel = MovieMatchModel()
    @StateObject var posterViewModel = PosterViewModel()
    @StateObject var genreViewModel = GenreViewModel()
    
    init() {
        var titleFont = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleFont = UIFont(descriptor: titleFont.fontDescriptor.withDesign(.rounded)?.withSymbolicTraits(.traitBold) ?? titleFont.fontDescriptor, size: titleFont.pointSize)
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: titleFont]
        var tabFont = UIFont.preferredFont(forTextStyle: .caption2)
        tabFont = UIFont(descriptor: tabFont.fontDescriptor.withDesign(.rounded)?.withSymbolicTraits(.traitBold) ?? tabFont.fontDescriptor, size: tabFont.pointSize)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: tabFont ], for: .normal)
    }
    
    var body: some View {
        TabView(selection: $tabSelection) {
            GenreSelectionView()
                .environmentObject(movieViewModel)
                .environmentObject(posterViewModel)
                .environmentObject(movieMatchModel)
                .environmentObject(genreViewModel)
                .tabItem { Label("Discover", systemImage: "popcorn.fill") }
                .tag("first")
                .task { self.genreViewModel.loadGenres(movies: self.movieViewModel.movies) }
            
            CineMatchesView()
                .environmentObject(movieViewModel)
                .environmentObject(posterViewModel)
                .environmentObject(movieMatchModel)
                .environmentObject(genreViewModel)
                .badge(self.movieMatchModel.recentlyLikedMovieCount)
                .tabItem { Label("CineMatches", systemImage: "heart.fill") }
                .tag("second")
            
            StatsView()
                .environmentObject(movieViewModel)
                .environmentObject(movieMatchModel)
                .environmentObject(posterViewModel)
                .environmentObject(genreViewModel)
                .tabItem { Label("Stats", systemImage: "chart.bar.fill") }
                .tag("third")
            
            SettingsView()
                .environmentObject(movieViewModel)
                .environmentObject(movieMatchModel)
                .environmentObject(posterViewModel)
                .environmentObject(genreViewModel)
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
                .tag("fourth")
        }
        .sheet(isPresented: $newUser) {
            OnboardingSheet()
                .interactiveDismissDisabled(true)
        }
    }
}

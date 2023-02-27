//
//  SettingsView.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/17/22.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("tabSelection") var tabSelection = "fourth"
    @EnvironmentObject var movieMatchModel: MovieMatchModel
    @State private var isPresentingAlert: Bool = false
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: ComingSoonView()) {
                        Label("Appearance", systemImage: "paintpalette.fill")
                            .labelStyle(ColorfulIconLabelStyle(color: .cyan))
                    }
                }
                Section {
                    NavigationLink(destination: ComingSoonView()) {
                        Label("All Liked Movies", systemImage: "heart.fill")
                            .labelStyle(ColorfulIconLabelStyle(color: .green))
                    }
                    NavigationLink(destination: ComingSoonView()) {
                        Label("All Disliked Movies", systemImage: "xmark")
                            .labelStyle(ColorfulIconLabelStyle(color: .red))
                    }
                    NavigationLink(destination: ComingSoonView()) {
                        Label("Top 🤖 Recommendations", systemImage: "50.circle.fill")
                            .labelStyle(ColorfulIconLabelStyle(color: .purple))
                    }
                }
                Section {
                    NavigationLink(destination: ComingSoonView()) {
                        Label("Feedback", systemImage: "paperplane.fill")
                            .labelStyle(ColorfulIconLabelStyle(color: .blue))
                    }
                    NavigationLink(destination: ComingSoonView()) {
                        Label("Help", systemImage: "questionmark.circle.fill")
                            .labelStyle(ColorfulIconLabelStyle(color: .orange))
                    }
                }
                Section {
                    Button(role: .destructive) {
                        isPresentingAlert = true
                    } label: {
                        Label("Erase All Swipe History", systemImage: "trash")
                            .labelStyle(ColorfulIconLabelStyle(color: .red))
                    }
                }
                .confirmationDialog("Are you sure?", isPresented: $isPresentingAlert) {
                    Button("Erase All History", role: .destructive) {
                        self.movieMatchModel.likedMovies.removeAll()
                        self.movieMatchModel.dislikedMovies.removeAll()
                        self.movieMatchModel.recommendations.removeAll()
                        self.movieMatchModel.genreMashes.removeAll()
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct ColorfulIconLabelStyle: LabelStyle {
    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
                .font(.system(.body, design: .rounded))
        } icon: {
            configuration.icon
                .font(.system(size: 17))
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 7).frame(width: 28, height: 28).foregroundColor(color))
        }
    }
}

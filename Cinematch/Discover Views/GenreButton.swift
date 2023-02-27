//
//  GenreButton.swift
//  Cinematch
//
//  Created by Adam Petersen on 10/24/22.
//

import SwiftUI

struct GenreButton: View {
    var genre: Genre
    @State var isSelected: Bool = false
    @Binding var selectedGenres: [Genre]
    var body: some View {
        Button {
            if self.isSelected {
                if let index = selectedGenres.firstIndex(of: genre) {
                    selectedGenres.remove(at: index)
                }
            } else {
                selectedGenres.append(genre)
                selectedGenres = selectedGenres.sorted { $0.name < $1.name }
            }
            self.isSelected.toggle()
        } label: {
            VStack {
                Text(self.genre.emoji)
                    .font(.callout)
                Spacer()
                Text(self.genre.name)
                    .foregroundColor(self.isSelected ? .white : .secondary)
                    .font(.system(.caption2, design: .rounded, weight: .medium))
            }
            .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
            .frame(width: 102, height: 60)
            .background(self.isSelected ? .orange: Color(UIColor.tertiarySystemGroupedBackground).opacity(0.7))
            .cornerRadius(15.0)
        }
        .onAppear {
            if selectedGenres.contains(self.genre) {
                self.isSelected = true
            } else {
                self.isSelected = false
            }
        }
    }
}

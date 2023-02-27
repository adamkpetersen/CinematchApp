//
//  OnboardingSheet.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/3/22.
//

import SwiftUI

struct OnboardingSheet: View {
    @AppStorage("newUser") var newUser: Bool = true
    @Environment(\.dismiss) var dismiss
    var body: some View {
            VStack {
                Spacer()
                HStack(spacing: 0) {
                    Text("CineMatch")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                    Text("❤️")
                        .font(.title3)
                }
                .padding(.leading, 5)
                Text("fall in love with movies again")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.cyan)
                Spacer()
                GroupBox {
                    VStack(spacing: 35) {
                        HStack {
                            Image(systemName: "video.fill.badge.checkmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                                .foregroundColor(.green)
                                .padding(.trailing, 18)
                                .padding(.leading, -3)
                            VStack(alignment: .leading) {
                                Text("Get Picky With It")
                                    .font(.system(.headline, design: .rounded))
                                Text("No more \"one-genre-fits-all\" filtering. Sort movies using multiple genre filters to create a **GenreMash**, unique to you!")
                                    .font(.system(.subheadline, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        HStack {
                            Image(systemName: "rectangle.and.hand.point.up.left.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                                .foregroundColor(.orange)
                                .padding(.trailing, 15)
                            VStack(alignment: .leading) {
                                Text("Swipe to Save")
                                    .font(.system(.headline, design: .rounded))
                                Text("Tired of scrolling through the same old Top-100 lists? Interactively explore your potential options with a swipe!")
                                    .font(.system(.subheadline, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        HStack {
                            Image(systemName: "heart.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                                .foregroundColor(.red)
                                .padding(.trailing, 15)
                            VStack(alignment: .leading) {
                                Text("Find Your Perfect Match")
                                    .font(.system(.headline, design: .rounded))
                                Text("Make the ideal pick from your list of **CineMatches** or our **Movie Bot** 🤖 suggestions and kiss boring movie nights goodbye!")
                                    .font(.system(.subheadline, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.leading, 5)
                }
                .groupBoxStyle(CardGroupBoxStyle())
                .padding(.horizontal, 20)
                Spacer()
                Button {
                    self.newUser = false
                    dismiss()
                } label: {
                    VStack {
                        Text("Get Started")
                            .font(.system(.headline, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(EdgeInsets(top: 15, leading: 125, bottom: 15, trailing: 125))
                    .background(.cyan)
                    .clipShape(RoundedRectangle(cornerRadius: 45))
                }
                .padding(.bottom, 100)
            }
            .background(Color(UIColor.systemGroupedBackground))
    }
}

struct OnboardingSheet_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingSheet()
    }
}

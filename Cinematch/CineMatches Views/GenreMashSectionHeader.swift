//
//  GenreMashSectionHeader.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/9/22.
//

import SwiftUI

struct GenreMashSectionHeader: View {
    var genreMash: [Genre]
    var movieCount: Int
    var body: some View {
        HStack {
            Text(genreMashEmojiString(genreMash: genreMash))
                .font(.system(.headline, design: .rounded))
                .font(.system(.headline, design: .rounded))
            Spacer()
            Text(String(movieCount))
                .font(.system(.headline, design: .rounded))
                .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
                .background(Color(UIColor.systemGray5))
                .cornerRadius(5)
        }
            .padding(.bottom, 5)
    }
}

func genreMashEmojiString(genreMash: [Genre]) -> String {
    if genreMash.isEmpty { return "🍿" } ///This should never show up
    var emojiString: String = ""
    
    for genre in genreMash {
        if genreMash.last! == genre {
            emojiString += genre.emoji
        }
        else {
            emojiString += (genre.emoji + " + ")
        }
    }
    
    return emojiString
}

struct GenreMashSectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        GenreMashSectionHeader(genreMash: [], movieCount: 0)
    }
}

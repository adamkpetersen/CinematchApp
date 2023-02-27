//
//  CardGroupBoxStyle.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/16/22.
//

import Foundation
import SwiftUI

struct CardGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            configuration.label.bold()
                .font(.system(.headline, design: .rounded))
                .padding(.bottom, 10)
                configuration.content
            HStack { Spacer() }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 7, x: 0, y: 1)
    }
}

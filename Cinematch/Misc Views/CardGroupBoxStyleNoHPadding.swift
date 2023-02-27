//
//  CardGroupBoxStyleNoHPadding.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/16/22.
//

import Foundation
import SwiftUI

struct CardGroupBoxStyleNoHPadding: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            configuration.label
                .font(.system(.headline, design: .rounded))
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20))
            configuration.content
            HStack { Spacer() }
        }
        .padding(.bottom, 20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 7, x: 0, y: 1)
    }
}

//
//  BackgroundGradientView.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/18/22.
//

import SwiftUI

struct BackgroundGradientView: View {
    @State var gradient: Gradient
    var body: some View {
        ZStack {
            Rectangle()
                .fill(self.gradient)
        }
    }
}

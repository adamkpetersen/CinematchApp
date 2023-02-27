//
//  LinearRegressionChartView.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/9/22.
//

import Charts
import SwiftUI

struct LinearRegressionChartView: View {
    @EnvironmentObject var movieMatchModel: MovieMatchModel
    @State var scores: [Double] = []
    var body: some View {
        GroupBox("Linear Regression") {
            Chart {
                ForEach(scores.indices, id: \.self) { index in
                    PointMark(
                        x: .value("Movie", index),
                        y: .value("Value", scores[index])
                    )
                }
                if !scores.isEmpty {
                    LineMark(
                        x: .value("Movie", 0),
                        //y: .value("Value", LowHighRecommendations(scores: scores).low)
                        y: .value("Value", 1.0)
                    )
                    .foregroundStyle(.green)
                    LineMark(
                        x: .value("Movie", scores.count),
                        //y: .value("Value", calculateMean(scores: self.scores))
                        y: .value("Value", 1.0)
                    )
                    .foregroundStyle(.green)
                }
            }
            .chartYScale(domain: LowHighRecommendations(scores: scores).low...LowHighRecommendations(scores: scores).high)
            //.chartYAxis(.hidden)
            .frame(height: 200)
        }
        .groupBoxStyle(CardGroupBoxStyle())
        .onChange(of: movieMatchModel.recommendations.map(\.score)) { recommendations in
            scores = recommendations.reversed()
        }
    }
}

func calculateMean(scores: [Double]) -> Double {
    var total = 0.0
    for score in scores {
        total += score
    }
    return scores.isEmpty ? 0.0 : (total / Double(scores.count))
}

func LowHighRecommendations(scores: [Double]) -> (low: Double, high: Double) {
    if scores.isEmpty { return (0.0, 1.0) }
    var sorted = scores.sorted()
    return (sorted.first!, sorted.last!)
}

struct LinearRegressionChartView_Previews: PreviewProvider {
    static var previews: some View {
        LinearRegressionChartView()
    }
}

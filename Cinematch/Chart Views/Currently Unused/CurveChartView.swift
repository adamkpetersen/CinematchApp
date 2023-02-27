//
//  CurveChartView.swift
//  Cinematch
//
//  Created by Adam Petersen on 11/14/22.
//

import Charts
import SwiftUI

struct CurveChartView: View {
    @EnvironmentObject var movieMatchModel: MovieMatchModel
    @State var curvePoints: [Double] = []
    var body: some View {
        GroupBox("Likeability Curve (All Movies)") {
            if curvePoints.isEmpty {
                HStack {
                    Spacer()
                    Text("No Prediction Data Yet")
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .frame(height: 200)
                .background(Color(UIColor.tertiarySystemGroupedBackground))
                .cornerRadius(10)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 20, trailing: 0))
            } else {
                Chart {
                    ForEach(self.curvePoints.indices, id: \.self) {  index in
                        LineMark(
                            x: .value("Movie", index),
                            y: .value("Movie Count", self.curvePoints[index])
                        )
                        .interpolationMethod(.catmullRom)
                        AreaMark(
                            x: .value("Movie", index),
                            y: .value("Movie Count", self.curvePoints[index])
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(Color.cyan.opacity(0.4))
                    }
                }
                //.chartXScale(domain: -10...11)
                //.chartYAxis(.hidden)
                .frame(height: 200)
                .padding(.bottom, 20)
            }
            HStack {
                Text("💔 Less Likeable")
                Spacer()
                Text("More Likeable ❤️")
            }
            .font(.caption2)
            .foregroundColor(.secondary)
        }
        .groupBoxStyle(CardGroupBoxStyle())
        .onChange(of: movieMatchModel.recommendations.map(\.score)) { scores in
            var every100: [Double] = []
            for index in scores.indices {
                if index % 50 == 0 {
                    every100.append(scores[index])
                }
            }
            self.curvePoints = calculateCurve(scores: every100)
        }
    }
}

func calculateCurve(scores: [Double]) ->  [Double] {
    let μ = scores.avg()
    let σ = scores.std()
    let π = Double.pi
    let e = 2.71828
    
    var curve: [Double] = []
    
    for score in scores {
        let y = pow((1/(σ * sqrt(2*π))), pow(e, -(pow(score - μ, 2)/(2 * pow(σ, 2))))) ///Bell Curve Formula
        
        curve.append(y)
    }
    
    return curve
}

struct CurveChartView_Previews: PreviewProvider {
    static var previews: some View {
        CurveChartView()
    }
}

extension Array where Element: FloatingPoint {

    func sum() -> Element {
        return self.reduce(0, +)
    }

    func avg() -> Element {
        return self.sum() / Element(self.count)
    }

    func std() -> Element {
        let mean = self.avg()
        let v = self.reduce(0, { $0 + ($1-mean)*($1-mean) })
        return sqrt(v / (Element(self.count) - 1))
    }

}

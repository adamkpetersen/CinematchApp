//
//  PieChartView.swift
//
//
//  Created by Nazar Ilamanov on 4/23/21.
//  Alterations by Adam Petersen.
//

import SwiftUI

struct PieChartView: View {
    @EnvironmentObject var movieMatchModel: MovieMatchModel
    public let values: [Double]
    public var colors: [Color]
    public let names: [String]
    
    public var backgroundColor: Color
    public var innerRadiusFraction: CGFloat
    
    var slices: [PieSliceData] {
        let sum = values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []
        
        for (i, value) in values.enumerated() {
            let degrees: Double = value * 360 / sum
            tempSlices.append(PieSliceData(startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endDeg + degrees), text: String(format: "%.0f%%", value * 100 / sum), color: self.colors[i]))
            endDeg += degrees
        }
        return tempSlices
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                ZStack{
                    ForEach(0..<self.values.count){ i in
                        PieSliceView(pieSliceData: self.slices[i])
                    }
                    .frame(width: (geometry.size.width / 1.75), height: (geometry.size.width / 1.75))
                    
                    Circle()
                        .fill(self.backgroundColor)
                        .frame(width: (geometry.size.width / 1.75) * innerRadiusFraction, height: (geometry.size.width / 1.75) * innerRadiusFraction)
                    
                    VStack {
                        Text(String(self.movieMatchModel.filteredMovies.filter { !self.movieMatchModel.likedMovies.map(\.movie).contains($0) }.count))
                            .font(.system(.title, design: .rounded)).bold()
                            .foregroundColor(.primary)
                        Text("Movies Remaining")
                            .font(.system(.caption2, design: .rounded))
                            .foregroundColor(Color.secondary)
                    }
                }
                .padding(.bottom, 10)
                PieChartRows(colors: self.colors, names: self.names, values: self.values.map { String(format: "%.0f%", $0) }, percents: self.values.map { String(format: "%.0f%%", $0 * 100 / self.values.reduce(0, +)) })
            }
            .background(self.backgroundColor)
        }
    }
}

struct PieChartRows: View {
    var colors: [Color]
    var names: [String]
    var values: [String]
    var percents: [String]
    
    var body: some View {
        VStack{
            ForEach(0..<self.values.count){ i in
                HStack(spacing: 20) {
                    Circle()
                        .fill(self.colors[i])
                        .frame(width: 20, height: 20)
                    Text(self.names[i])
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                        .foregroundColor(.primary)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(self.values[i])
                            .foregroundColor(.primary)
                            .font(.system(.caption, design: .rounded)).bold()
                        Text(self.percents[i])
                            .foregroundColor(.secondary)
                            .font(.system(.caption2, design: .rounded))
                    }
                }
            }
        }
    }
}

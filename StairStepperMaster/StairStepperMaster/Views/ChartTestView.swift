//
//  ChartTestView.swift
//  7DayChart
//
//  Created by Zoe Cutler on 6/24/22.
//

import SwiftUI


//MARK: Start of Sample Code.
struct ChartShape: Shape {
    var data: [Double]
    var shouldFill: Bool
    
    init(data: [Double], shouldFill: Bool) {
        let maxPoint = data.max() ?? 1.0
        var translatedData: [Double] = []
        
        for item in data {
            translatedData.append(item / maxPoint)
        }
        
        self.data = translatedData
        
        self.shouldFill = shouldFill
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let start = CGPoint(x: rect.minX, y: rect.maxY - ((data.first ?? 0.0) * rect.height))
        path.move(to: start)
        
        var point = CGPoint()
        var control1 = CGPoint()
        var control2 = CGPoint()
        var value1 = 0.0
        var value2 = 0.0
        let maxData = data.max() ?? 1
        
        for (i, value) in data.enumerated() {
            var slope = 0.0
            
            if i != 0 {
                point = CGPoint(x: rect.minX + (rect.width / CGFloat(data.count - 1) * CGFloat(i)), y: rect.maxY - (value * rect.height) )
                control2 = CGPoint(x: rect.minX + (rect.width / CGFloat(data.count - 1) * (CGFloat(i) - 0.4)), y: rect.maxY - (value * rect.height) )
                
                if i + 1 < data.count {
                    value2 = data[i + 1]
                    slope = (value2 - value1) / 2
                } else {
                    value2 = value
                    slope = value2 - value1
                }
                
                if i == 1 {
                    control1.y = control1.y - (slope * rect.height / maxData * 0.4)
                }
                
                control2.y = control2.y + (slope * rect.height / maxData * 0.4)
                
                path.addCurve(to: point, control1: control1, control2: control2)
            }
            control1 = CGPoint(x: rect.minX + (rect.width / CGFloat(data.count - 1) * (CGFloat(i) + 0.4)), y: rect.maxY - (value * rect.height) )
            control1.y = control1.y - (slope * rect.height / maxData * 0.4)
            value1 = value
        }
        
        if data.count == 1 {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        }
        
        if shouldFill {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: start)
        }
        
        return path
    }
}


struct ChartView: View {
    var data: [Double]
    
    var body: some View {
        ZStack {
            HStack {
                Rectangle()
                    .frame(width: 2.0)
                Spacer()
            }
            VStack {
                Spacer()
                Rectangle()
                    .frame(height: 2.0)
            }
            //TODO: Change these to your colors or gradients.
            ChartShape(data: data, shouldFill: true)
                .fill(
                    LinearGradient(colors: [Color("FlightsChartLine"), Color("FlightsChartBottomGradient")], startPoint: .top, endPoint: .bottom)
                )
                .opacity(0.6)
            ChartShape(data: data, shouldFill: false)
                .stroke(style: .init(lineWidth: 3.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color("FlightsChartLine"))
        }
    }
}
//MARK: End of Sample Code



//TODO: Intead of using this view, insert ChartView into your View hierarchy, and it will resize appropriately.
struct ChartTestView: View {
    var data: [Double] = [1, 2, 3, 6, 0, 5]
    
    var body: some View {
        HStack {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.title)
            VStack(alignment: .leading) {
                Text("Flights")
                    .font(.subheadline)
                //This is a wild way to get the sum of an array.
                Text("\(Int(data.reduce(0, { partialResult, next in partialResult + next})))")
                    .bold()
                Spacer()
                Text("Goal")
                    .font(.subheadline)
                Text("\(Int(1.3 * data.reduce(0, { partialResult, next in partialResult + next})))")
                    .bold()
            }
            ChartView(data: data)
        }
        .padding()
        //Note: Shapes want to expand to the full area they're given, so care should be taken to test larger text sizes when constraining the frame like this.
        .frame(height: 140.0)
    }
}

struct ChartTestView_Previews: PreviewProvider {
    static var previews: some View {
        ChartTestView()
    }
}

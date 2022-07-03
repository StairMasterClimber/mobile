//
//  ActivityChartTileWidgetSharedView.swift
//  StairStepperMaster
//
//  Created by Saamer Mansoor on 6/26/22.
//

import SwiftUI

struct ActivityChartTileWidgetSharedView: View {
    var flightsArrayPadded: [Double]
    var flightsClimbed: Double
    var activityGoal: Int

    var body: some View {
        VStack{
            HStack{
                Image("Stairs")
                    .padding(.leading, 10)
                VStack(alignment: .leading){
                    Text("Flights")
                        .font(Font.custom("Avenir", size: 14))
                        .foregroundColor(.white)
                    Text(String(format: "%.0f", flightsClimbed))
                        .font(Font.custom("Avenir", size: 14))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.bottom, 8.0)
                    Text("Goal")
                        .font(Font.custom("Avenir", size: 14))
                        .foregroundColor(.white)
                    Text(String(activityGoal*7))
                        .font(Font.custom("Avenir", size: 14))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                }.padding(12.0)
                
                if #available(iOS 16.0, *) {
#if canImport(Charts)
                    Chart {
                        ForEach(last7Days, id: \.self) { element in
                            AreaMark(x: .value("Day", element.Day), y: .value("Flights Count", element.TotalCount))
                                .foregroundStyle(.linearGradient(colors: [Color("FlightsChartBottomGradient"),Color("FlightsChartLine")], startPoint: UnitPoint(x: 0.5, y: 1), endPoint: UnitPoint(x: 0.5, y: 0)))
                            LineMark(x: .value("Day", element.Day), y: .value("Flights Count", element.TotalCount))
                                .foregroundStyle(Color("FlightsChartLine"))
                            if element.Day != 0 && element.Day != 8{
                                PointMark(x: .value("Day", element.Day), y: .value("Flights Count", element.TotalCount))
                                    .foregroundStyle(Color("FlightsChartLine"))
//                                TODO: Figure out why it doesn't build
//                                        .annotation(position: .top, alignment: .top) {
//                                            Text(element.TotalCount)
//                                                .font(Font.custom("Avenir", size: 12))
//                                                .fontWeight(.light)
//                                                .foregroundColor(.white)
//                                        }
                                    .symbolSize(symbolSize)

                            }

                        }
                        .interpolationMethod(.catmullRom(alpha: 0.5))
                        
                        RuleMark(y: .value("Goal", activityGoal))
                            .foregroundStyle(.white)
                            .opacity(0.2)
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day)) { _ in
                            AxisValueLabel(format: .dateTime.weekday(.abbreviated), centered: true)
                        }
                    }
                    .foregroundStyle(.pink, .orange, .yellow)
                    .padding(.top,10)
                    .padding(.trailing,15)
#endif
                } else {
                    ChartView(data: flightsArrayPadded)
                        .padding(.top,10)
                        .padding(.trailing,15)
                    // Fallback on earlier versions
                }
                
            }
        }
    }
}


struct ActivityChartTileWidgetSharedView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityChartTileWidgetSharedView(flightsArrayPadded: [0,2,3,2,3,1,2,1,0], flightsClimbed: 35, activityGoal: 7)
    }
}

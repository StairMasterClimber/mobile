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
                    SwiftChartView(last7Days: Calc(flightsArrayPadded: flightsArrayPadded))
                } else {
                    ChartView(data: flightsArrayPadded)
                        .padding(.top,10)
                        .padding(.trailing,15)
                    // Fallback on earlier versions
                }
                
            }
        }
    }
    
    func Calc(flightsArrayPadded: [Double]) -> [Stairs]{
        var x:[Stairs] = []
        if flightsArrayPadded.count == 8{
            x = [
                .init(Day: 0, TotalCount: Int(flightsArrayPadded[0])),
                .init(Day: 1, TotalCount: Int(flightsArrayPadded[1])),
                .init(Day: 2, TotalCount: Int(flightsArrayPadded[2])),
                .init(Day: 3, TotalCount: Int(flightsArrayPadded[3])),
                .init(Day: 4, TotalCount: Int(flightsArrayPadded[4])),
                .init(Day: 5, TotalCount: Int(flightsArrayPadded[5])),
                .init(Day: 6, TotalCount: Int(flightsArrayPadded[6])),
                .init(Day: 7, TotalCount: Int(flightsArrayPadded[7])),
            ]
        }
        return x
    }
}


struct ActivityChartTileWidgetSharedView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityChartTileWidgetSharedView(flightsArrayPadded: [0,2,3,2,3,1,2,1,0], flightsClimbed: 35, activityGoal: 7)
    }
}

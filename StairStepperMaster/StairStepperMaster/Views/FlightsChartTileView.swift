//
//  FlightsChartTileView.swift
//  StairStepperMaster
//
//  Created by Saamer Mansoor on 6/8/22.
//

import SwiftUI
#if canImport(Charts)
import Charts
#endif



struct Stairs: Identifiable, Hashable {
    var Day: Int
    var TotalCount: Int
    var id = UUID()
}

struct FlightsChartTileView: View {
    @AppStorage("ActivityGoal") var activityGoal:Int = 8
    @AppStorage("FlightsClimbed") var flightsClimbed:Double = 0
    @AppStorage("FlightsClimbedArray") var flightsClimbedArray:[Double] = [4,2,5,6,7,2,4]
    @State var flightsClimbedRefinedArray:[Double] = [0,4,2,5,6,7,2,4,0]

    @State var last7Days: [Stairs] = []
    let symbolSize: CGFloat = 30

    init(){
        print("flightsClimbedArray.count")
        print(flightsClimbedArray.count)
        print(flightsClimbedArray)
        CalculateLast7Days()
    }
    var body: some View {
        VStack(spacing: 0){
            
            HStack{
                Text("ACTIVITY")
                    .font(Font.custom("Avenir", size: 25))
                    .fontWeight(.heavy)
                    .padding(.leading, 20)
                    .foregroundColor(.white)
                Spacer()
            }
            Text("Flights Climbed (past 7 days)")
                .font(Font.custom("Avenir", size: 15))
                .padding(.bottom, 8)
                .foregroundColor(.white)
            ActivityChartTileWidgetSharedView(flightsArrayPadded: flightsClimbedRefinedArray, flightsClimbed: flightsClimbed, activityGoal: activityGoal)
            .frame(minWidth:350, minHeight: 113)
            .background(Color("TileBackground"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .onAppear(){
            CalculateLast7Days()
        }
        .onChange(of: flightsClimbedArray, perform: { newNearMeter in
            //Then call the function and if you need to pass the new value do it like this
//            print("newNearMeter")
//            print(newNearMeter)
            // TODO: Check is this needed?
            CalculateLast7Days()
        })
        .padding([.horizontal])
    }
    func CalculateLast7Days(){
        if #available(iOS 16.0, *) {
            flightsClimbedRefinedArray = [0]
            
            for day in flightsClimbedArray {
                flightsClimbedRefinedArray.append(day)
            }
            flightsClimbedRefinedArray.append(0)
            // TODO: Need to test above code with iOS 16 device
//
//            if flightsClimbedArray.count < 7 {
//                let neededFligtDays = 7 - flightsClimbedArray.count
//                
//                for _ in 0..<neededFligtDays {
//                    flightsClimbedArray.append(0)
//                }
//            }
//            last7Days = [
//                .init(Day: 0, TotalCount: 0),
//                .init(Day: 1, TotalCount: Int(flightsClimbedArray[0])),
//                .init(Day: 2, TotalCount: Int(flightsClimbedArray[1])),
//                .init(Day: 3, TotalCount: Int(flightsClimbedArray[2])),
//                .init(Day: 4, TotalCount: Int(flightsClimbedArray[3])),
//                .init(Day: 5, TotalCount: Int(flightsClimbedArray[4])),
//                .init(Day: 6, TotalCount: Int(flightsClimbedArray[5])),
//                .init(Day: 7, TotalCount: Int(flightsClimbedArray[6])),
//                .init(Day: 8, TotalCount: 0),
//            ]
        } else{
            flightsClimbedRefinedArray = [0]
            
            for day in flightsClimbedArray {
                flightsClimbedRefinedArray.append(day)
            }
            flightsClimbedRefinedArray.append(0)
            
//            flightsClimbedRefinedArray = [0,flightsClimbedArray[0],flightsClimbedArray[1],flightsClimbedArray[2],flightsClimbedArray[3],flightsClimbedArray[4],flightsClimbedArray[5],flightsClimbedArray[6],0]
        }
    }
}

struct FlightsChartTileView_Previews: PreviewProvider {
    static var previews: some View {
        FlightsChartTileView()
    }
}

func date(year: Int, month: Int, day: Int = 1) -> Date {
    Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
}

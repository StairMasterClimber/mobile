//
//  FlightsChartTileView.swift
//  StairStepperMaster
//
//  Created by Saamer Mansoor on 6/8/22.
//

import SwiftUI
#if canImport(Charts)
import Charts



struct Stairs: Identifiable, Hashable {
    var Day: Int
    var TotalCount: Int
    var id = UUID()
}

struct FlightsChartTileView: View {
    @AppStorage("ActivityGoal") var activityGoal:Int = 8
    @AppStorage("FlightsClimbed") var flightsClimbed:Double = 0
    @AppStorage("FlightsClimbedArray") var flightsClimbedArray:[Double] = [4,2,5,6,7,2,4]

    var last7Days: [Stairs] = []
    let symbolSize: CGFloat = 30

    init(){
        print("flightsClimbedArray.count")
        print(flightsClimbedArray.count)
        if flightsClimbedArray.count < 7 {
            let neededFligtDays = 7 - flightsClimbedArray.count
            
            for _ in 0..<neededFligtDays {
                flightsClimbedArray.append(0)
            }
        
            
        }
        last7Days = [
            .init(Day: 0, TotalCount: 0),
            .init(Day: 1, TotalCount: Int(flightsClimbedArray[0])),
            .init(Day: 2, TotalCount: Int(flightsClimbedArray[1])),
            .init(Day: 3, TotalCount: Int(flightsClimbedArray[2])),
            .init(Day: 4, TotalCount: Int(flightsClimbedArray[3])),
            .init(Day: 5, TotalCount: Int(flightsClimbedArray[4])),
            .init(Day: 6, TotalCount: Int(flightsClimbedArray[5])),
            .init(Day: 7, TotalCount: Int(flightsClimbedArray[6])),
            .init(Day: 8, TotalCount: 0),
        ]
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
                    } else {
                        // Fallback on earlier versions
                    }
                    
                }
            }
            .frame(minWidth:350, minHeight: 113)
            .background(Color("TileBackground"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .onChange(of: flightsClimbedArray, perform: { newNearMeter in
            //Then call the function and if you need to pass the new value do it like this
            print("newNearMeter")
            print(newNearMeter)
        })
        .padding([.horizontal])
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
#endif

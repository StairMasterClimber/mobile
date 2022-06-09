//
//  FlightsChartTileView.swift
//  StairStepperMaster
//
//  Created by Saamer Mansoor on 6/8/22.
//

import SwiftUI
import Charts
//struct Stairs: Identifiable {
//    var Day: Int
//    var TotalCount: Int
//    var id = UUID()
//
//}
struct Stairs: Identifiable, Hashable {
    //    /// The name of the city.
    //    let city: String
    //
    //    /// Average daily sales for each weekday.
    //    /// The `weekday` property is a `Date` that represents a weekday.
    //    let sales: [(weekday: Date, sales: Int)]
    //
    //    /// The identifier for the series.
    //    var id: String { city }
    var Day: Int
    var TotalCount: Int
    var id = UUID()
}

/// Sales by location and weekday for the last 30 days.
let last7Days: [Stairs] = [
    .init(Day: 0, TotalCount: 0),
    .init(Day: 1, TotalCount: 5),
    .init(Day: 2, TotalCount: 3),
    .init(Day: 3, TotalCount: 8),
    .init(Day: 4, TotalCount: 2),
    .init(Day: 5, TotalCount: 10),
    .init(Day: 6, TotalCount: 1),
    .init(Day: 7, TotalCount: 5),
    .init(Day: 8, TotalCount: 0),
//    .init(city: "San Francisco", sales: [
//        (weekday: date(year: 2022, month: 5, day: 2), sales: 81),
//        (weekday: date(year: 2022, month: 5, day: 3), sales: 90),
//        (weekday: date(year: 2022, month: 5, day: 4), sales: 52),
//        (weekday: date(year: 2022, month: 5, day: 5), sales: 72),
//        (weekday: date(year: 2022, month: 5, day: 6), sales: 84),
//        (weekday: date(year: 2022, month: 5, day: 7), sales: 84),
//        (weekday: date(year: 2022, month: 5, day: 8), sales: 137)
//    ])
]


struct FlightsChartTileView: View {
    @AppStorage("ActivityGoal") var activityGoal:Int = 8
    @AppStorage("FlightsClimbed") var flightsClimbed:Double = 0
    let data = [0,4,2,5,6,7,2,4,0]
    var body: some View {
        VStack(spacing: 0){
           
            HStack{
                Text("ACTIVITY")
                    .font(Font.custom("Avenir", size: 25))
                    .fontWeight(.heavy)
                    .padding(.leading, 19)
                    .foregroundColor(.white)
                Spacer()
            }

            VStack{
                HStack{
                    Image("Stairs")
                    VStack(alignment: .leading){
                        Text("Flights")
                            .font(Font.custom("Avenir", size: 14))
                            .foregroundColor(.white)
                        Text("35")
                            .font(Font.custom("Avenir", size: 14))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding(.bottom, 12.0)
                        Text("Goal")
                            .font(Font.custom("Avenir", size: 14))
                            .foregroundColor(.white)
                        Text("70")
                            .font(Font.custom("Avenir", size: 14))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                    }.padding(15.0)
                    
                    if #available(iOS 16.0, *) {
//                        LocationDetailsChart()
                        Chart {
                            
                                ForEach(last7Days, id: \.self) { element in
                                    LineMark(x: .value("Day", element.Day), y: .value("TotalCount", element.TotalCount))
                                }
                                .foregroundStyle(.red)
                                .interpolationMethod(.catmullRom(alpha: 0.5))
                            
                                RuleMark(y: .value("Break Even Threshold", 5))
                                .foregroundStyle(.white)
                                .opacity(0.2)
//                            .foregroundStyle(.linearGradient(colors: [.red,.blue], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
//                            .foregroundStyle(by: .value("Day", last7Days))
//                            .symbol(by: .value("Day", last7Days))

                        }
//                        .chartForegroundStyleScale([
//                            "San Francisco": .green,
//                            "Sales": .red,
//                            "Day": .yellow,
//                        ])
//                        .chartSymbolScale([
//                            "San Francisco": Circle().strokeBorder(lineWidth: 2),
//                            "Sales": Circle().strokeBorder(lineWidth: 2),
//                            "Day": Circle().strokeBorder(lineWidth: 2),
//            //                "Cupertino": Square().strokeBorder(lineWidth: 2)
//                        ])
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .day)) { _ in
//                                AxisTick()
//                                AxisGridLine()
                                AxisValueLabel(format: .dateTime.weekday(.abbreviated), centered: true)
                            }
                        }
//                        .chartLegend(position: .top)
                        
                    } else {
                        // Fallback on earlier versions
                    }
                    
                }
            }
            .padding()
            .frame(minWidth:353, minHeight: 113)
            .background(Color("TileBackground"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding([.horizontal, .bottom])
    }
}

struct FlightsChartTileView_Previews: PreviewProvider {
    static var previews: some View {
        FlightsChartTileView()
    }
}

struct LocationDetailsChart: View {
    let data : [LocationData.Series]
    let bestSales: (city: String, weekday: Date, sales: Int)

    var body: some View {
        if #available(iOS 16.0, *) {
            Chart(data) { series in
                ForEach(series.sales, id: \.weekday) { element in
                    LineMark(
                        x: .value("Day", element.weekday, unit: .day),
                        y: .value("Sales", element.sales)
                    )
                }
                .foregroundStyle(by: .value("City", series.city))
                .symbol(by: .value("City", series.city))
                .interpolationMethod(.catmullRom)
            }
            .chartForegroundStyleScale([
                "San Francisco": .green,
                "Sales": .red,
                "Day": .yellow,
//                "Cupertino": .green
            ])
            .chartSymbolScale([
                "San Francisco": Circle().strokeBorder(lineWidth: 2),
                "Sales": Circle().strokeBorder(lineWidth: 2),
                "Day": Circle().strokeBorder(lineWidth: 2),
//                "Cupertino": Square().strokeBorder(lineWidth: 2)
            ])
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisTick()
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.weekday(.abbreviated), centered: true)
                }
            }
            .chartLegend(position: .top)
        } else {
            // Fallback on earlier versions
        }
    }
}

struct LocationData {
    /// A data series for the lines.
    struct Series: Identifiable {
        /// The name of the city.
        let city: String

        /// Average daily sales for each weekday.
        /// The `weekday` property is a `Date` that represents a weekday.
        let sales: [(weekday: Date, sales: Int)]

        /// The identifier for the series.
        var id: String { city }
    }

    /// Sales by location and weekday for the last 30 days.
    static let last30Days: [Series] = [
        .init(city: "Cupertino", sales: [
            (weekday: date(year: 2022, month: 5, day: 2), sales: 54),
            (weekday: date(year: 2022, month: 5, day: 3), sales: 42),
            (weekday: date(year: 2022, month: 5, day: 4), sales: 88),
            (weekday: date(year: 2022, month: 5, day: 5), sales: 49),
            (weekday: date(year: 2022, month: 5, day: 6), sales: 42),
            (weekday: date(year: 2022, month: 5, day: 7), sales: 125),
            (weekday: date(year: 2022, month: 5, day: 8), sales: 67)

        ]),
        .init(city: "San Francisco", sales: [
            (weekday: date(year: 2022, month: 5, day: 2), sales: 81),
            (weekday: date(year: 2022, month: 5, day: 3), sales: 90),
            (weekday: date(year: 2022, month: 5, day: 4), sales: 52),
            (weekday: date(year: 2022, month: 5, day: 5), sales: 72),
            (weekday: date(year: 2022, month: 5, day: 6), sales: 84),
            (weekday: date(year: 2022, month: 5, day: 7), sales: 84),
            (weekday: date(year: 2022, month: 5, day: 8), sales: 137)
        ])
    ]

    /// The best weekday and location for the last 30 days.
    static let last30DaysBest = (
        city: "San Francisco",
        weekday: date(year: 2022, month: 5, day: 8),
        sales: 137
    )

    /// The best weekday and location for the last 12 months.
    static let last12MonthsBest = (
        city: "San Francisco",
        weekday: date(year: 2022, month: 5, day: 8),
        sales: 113
    )

    /// Sales by location and weekday for the last 12 months.
    static let last12Months: [Series] = [
        .init(city: "Cupertino", sales: [
            (weekday: date(year: 2022, month: 5, day: 2), sales: 64),
            (weekday: date(year: 2022, month: 5, day: 3), sales: 60),
            (weekday: date(year: 2022, month: 5, day: 4), sales: 47),
            (weekday: date(year: 2022, month: 5, day: 5), sales: 55),
            (weekday: date(year: 2022, month: 5, day: 6), sales: 55),
            (weekday: date(year: 2022, month: 5, day: 7), sales: 105),
            (weekday: date(year: 2022, month: 5, day: 8), sales: 67)
        ]),
        .init(city: "San Francisco", sales: [
            (weekday: date(year: 2022, month: 5, day: 2), sales: 57),
            (weekday: date(year: 2022, month: 5, day: 3), sales: 56),
            (weekday: date(year: 2022, month: 5, day: 4), sales: 66),
            (weekday: date(year: 2022, month: 5, day: 5), sales: 61),
            (weekday: date(year: 2022, month: 5, day: 6), sales: 60),
            (weekday: date(year: 2022, month: 5, day: 7), sales: 77),
            (weekday: date(year: 2022, month: 5, day: 8), sales: 113)
        ])
    ]
}

func date(year: Int, month: Int, day: Int = 1) -> Date {
    Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
}

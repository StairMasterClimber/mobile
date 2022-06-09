//
//  FlightsChartTileView.swift
//  StairStepperMaster
//
//  Created by Saamer Mansoor on 6/6/22.
//

import SwiftUI
import HealthKit

struct FlightsChartTileView: View {
    @State var ChartData:[Double] = []
    var body: some View {
        VStack(spacing: 0){
            HStack{
                
                Text("FLIGHTS")
                    .font(Font.custom("Avenir", size: 25))
                    .fontWeight(.heavy)
                    .padding(.leading, 19)
                    .foregroundColor(.white)
                Spacer()
                Text("Show More")
                    .font(Font.custom("Avenir", size: 14))
                    .padding(.trailing, 19)
                    .foregroundColor(Color("MoreYellow"))
                
            }
            
            VStack{
                HStack{
                    Text("H")
                    // [2.0, 17, 9, 23, 10],
                    LightChartView(data: ChartData,
                                   type: .curved,
                                   visualType: .filled(color: .green, lineWidth: 3),
                                   offset: 0.2,
                                   currentValueLineType: .dash(color: .gray, lineWidth: 1, dash: [5]))
                }
                
            }
            .padding()
            .frame(minHeight: 113)
            .background(Color("TileBackground"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    func fetchFlightData()
    {
        let HKStore = HKHealthStore()
        
        if HKHealthStore.isHealthDataAvailable()
        {
            let readData = Set([
                HKObjectType.quantityType(forIdentifier: .flightsClimbed)!,
                HKObjectType.quantityType(forIdentifier: .stairAscentSpeed)!,
                HKObjectType.quantityType(forIdentifier: .stairDescentSpeed)!])
            HKStore.requestAuthorization(toShare: [], read: readData) {(success, error) in
                if success
                {
                    let cal = NSCalendar.current
                    var anchorComps = cal.dateComponents([.day, .month, .year, .weekday], from: NSDate() as Date)
                    
                    // TODO: Figure out what this does Tyler/Tom/Zoe
                    let offset = (5 + anchorComps.weekday! - 2) % 5
                    let endDate = Date()
                    
                    anchorComps.day! -= offset
                    anchorComps.hour = 1
                    
                    guard let anchorDate = Calendar.current.date(from: anchorComps)
                    else
                    {
                        fatalError("Can't get a valid date from the achor. You fucked something up!")
                    }
                    
                    guard let startDate = cal.date(byAdding: .month, value: -1, to: endDate)
                    else
                    {
                        fatalError("Can't generate a startDate! :-/")
                    }
                    print(startDate)
                    print(endDate)
                    let interval = NSDateComponents()
                    interval.hour = 24
                    
                    guard let quantityType2 = HKObjectType.quantityType(forIdentifier: .stepCount)
                    else{
                        fatalError("Can't get quantityType forIdentifier: .stepCount!")
                    }
                    let HKquery2 = HKStatisticsCollectionQuery(quantityType: quantityType2, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: interval as DateComponents)
                    
                    HKquery2.initialResultsHandler =
                    {
                        query, results, error in
                        guard let statsCollection = results
                        else
                        {
                            fatalError("Unable to get results! Reason: \(String(describing: error?.localizedDescription))")
                        }
                        
                        statsCollection.enumerateStatistics(from: startDate, to: endDate)
                        {
                            statistics, stop in
                            if let quantity = statistics.sumQuantity()
                            {
                                print(quantity)
                                let val = quantity.doubleValue(for: HKUnit(from: "count"))
                                ChartData.append(val)
                            }
                        }
                    }
                    HKStore.execute(HKquery2)
                }
                else
                {
                    print("Unauthorized!")
                }
            }
        }
        else
        {
            print("ERROR: Unable to fetch data!")
        }
    }
}

struct FlightsChartTileView_Previews: PreviewProvider {
    static var previews: some View {
        FlightsChartTileView()
    }
}

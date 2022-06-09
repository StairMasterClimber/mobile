//
//  MachineTileView.swift
//  StairStepperMaster
//
//  Created by Saamer Mansoor on 5/27/22.
//

import SwiftUI
import HealthKit

struct MachineTileView: View {
    @AppStorage("AskedAboutMachine") var shouldShowInitialQuestion:Bool = true
    @AppStorage("MachineUsage") var shouldHide:Bool = false
//    @AppStorage("DidStartWorkout") var didStartWorkout:Bool = false
    @AppStorage("InitialWorkoutStepsClimbed") var initialStepsWalked:Double = 0
    @AppStorage("FinalWorkoutStepsClimbed") var finalStepsWalked:Double = 0
    @AppStorage("FlightsClimbed") var flightsClimbed:Double = 0
    @AppStorage("StepsTakenAtStart") var stepsAt:Double = 0
//    @State private var shouldShowInitialQuestion:Bool = true
//    @State private var shouldHide:Bool = false
    @State private var didStartWorkout:Bool = false

    var body: some View {
        if !shouldHide{
            VStack(spacing: 0){
                HStack{
                Text("STAIR STEPPER MACHINE")
                    .font(Font.custom("Avenir", size: 25))
                    .fontWeight(.heavy)
//                    .foregroundColor(.orange)
//                    .multilineTextAlignment(.leading)

                    .padding(.leading, 19)
                    .foregroundColor(.white)
      Spacer()
                }

                VStack(spacing: 0){
                    if shouldShowInitialQuestion{
                        Text("Do you use a Stair Stepper Machine?")
                            .font(Font.custom("Avenir", size: 14))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                        HStack{
                            Button(action: {
                                shouldShowInitialQuestion = false
                                print("Yes")
                            }, label:{ Text("Yes")
                                    .font(Font.custom("Avenir", size: 20))
                                    .fontWeight(.heavy)
                            })
                            .buttonStyle(TileYesNoButton(isYes: true))
                            Button(action: {
                                print("No")
                                shouldShowInitialQuestion = false
                                shouldHide = true
                            }, label:{ Text("No")
                                    .font(Font.custom("Avenir", size: 20))
                                    .fontWeight(.heavy)
                            })
                            .buttonStyle(TileYesNoButton(isYes: false))
                        }
                    }
                    else if !didStartWorkout{
                        Text("Would you like us to record your machine workout?")
                            .font(Font.custom("Avenir", size: 14))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                        Button(action: {
                            print("Yes")
                            fetchInitialStepData()
                            didStartWorkout = true
                        }, label:{
                            Text("Start Workout")
                                .font(Font.custom("Avenir", size: 20))
                                .fontWeight(.heavy)
                            
                        })
                        .buttonStyle(TileStartStopButton(isStart: true))
                    }
                    else {
                        Text("Tap the button when you are done")
                            .font(Font.custom("Avenir", size: 14))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                        Button(action: {
                            fetchFinalStepData()
                            didStartWorkout = false
                        }, label:{ Text("End Workout")
                                .font(Font.custom("Avenir", size: 20))
                                .fontWeight(.heavy)
                        })
                        .buttonStyle(TileStartStopButton(isStart: false))
                    }
                }
                .padding()
                .frame(minWidth:350, minHeight: 113)
                .background(Color("TileBackground"))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }
    
    func saveFlights()
    {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier:.flightsClimbed) else {
            fatalError("Step Count Type is no longer available in HealthKit")
        }
        var numberOfFlights = (finalStepsWalked - initialStepsWalked) / 15
        // From here: https://developer.apple.com/documentation/swift/floatingpoint/2298113-round to prevent incomplete stairs
        numberOfFlights = numberOfFlights.rounded(.up)
        let stepsCountUnit:HKUnit = HKUnit.count()
        let stepsCountQuantity = HKQuantity(unit: stepsCountUnit,
                                           doubleValue: numberOfFlights)
        let date:Date = Date.init()
        let stepsCountSample = HKQuantitySample(type: stepCountType,
                                               quantity: stepsCountQuantity,
                                               start: date,
                                               end: date)
        
        HKHealthStore().save(stepsCountSample) { (success, error) in
            
            if let error = error {
                print("Error Saving Steps Count Sample: \(error.localizedDescription)")
            } else {
                flightsClimbed = flightsClimbed + numberOfFlights
                print("Successfully saved Steps Count Sample")
            }
        }
    }
    
    func fetchInitialStepData()
    {
        let HKStore = HKHealthStore()
        
        if HKHealthStore.isHealthDataAvailable()
        {
            let readData = Set([
                HKObjectType.quantityType(forIdentifier: .heartRate)!,
                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                //                HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
                HKObjectType.quantityType(forIdentifier: .stepCount)!,
                HKObjectType.quantityType(forIdentifier: .flightsClimbed)!,
                HKObjectType.quantityType(forIdentifier: .vo2Max)!,
                //                HKObjectType.quantityType(forIdentifier: .walkingHeartRateAverage)!,
                HKObjectType.quantityType(forIdentifier: .stairAscentSpeed)!,
                HKObjectType.quantityType(forIdentifier: .stairDescentSpeed)!,
                HKObjectType.categoryType(forIdentifier: .highHeartRateEvent)!])
            let writeData = Set([
                HKObjectType.quantityType(forIdentifier: .stepCount)!,
                HKObjectType.quantityType(forIdentifier: .flightsClimbed)!])
            HKStore.requestAuthorization(toShare: writeData, read: readData) {(success, error) in
                if success
                {
                    let cal = NSCalendar.current
                    var anchorComps = cal.dateComponents([.day, .month, .year, .weekday], from: NSDate() as Date)
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
                                let date = statistics.startDate
                                let val = quantity.doubleValue(for: HKUnit(from: "count"))
                                initialStepsWalked = val + initialStepsWalked
                                print(val)
                                print(date)
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
    
    func fetchFinalStepData()
    {
        let HKStore = HKHealthStore()
        
        if HKHealthStore.isHealthDataAvailable()
        {
            let readData = Set([
                HKObjectType.quantityType(forIdentifier: .heartRate)!,
                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                //                HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
                HKObjectType.quantityType(forIdentifier: .stepCount)!,
                HKObjectType.quantityType(forIdentifier: .flightsClimbed)!,
                HKObjectType.quantityType(forIdentifier: .vo2Max)!,
                //                HKObjectType.quantityType(forIdentifier: .walkingHeartRateAverage)!,
                HKObjectType.quantityType(forIdentifier: .stairAscentSpeed)!,
                HKObjectType.quantityType(forIdentifier: .stairDescentSpeed)!,
                HKObjectType.categoryType(forIdentifier: .highHeartRateEvent)!])
            let writeData = Set([
                HKObjectType.quantityType(forIdentifier: .stepCount)!,
                HKObjectType.quantityType(forIdentifier: .flightsClimbed)!])
            HKStore.requestAuthorization(toShare: writeData, read: readData) {(success, error) in
                if success
                {
                    let cal = NSCalendar.current
                    var anchorComps = cal.dateComponents([.day, .month, .year, .weekday], from: NSDate() as Date)
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
                    flightsClimbed = 0
                    
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
                                let date = statistics.startDate
                                let val = quantity.doubleValue(for: HKUnit(from: "count"))
                                finalStepsWalked = val + finalStepsWalked
                                print(val)
                                print(date)
                            }
                        }
                        saveFlights()
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

struct MachineTileView_Previews: PreviewProvider {
    static var previews: some View {
        MachineTileView()
    }
}

//
//  ContentView.swift
//  StairStepperMaster
//
//  Created by Saamer Mansoor on 5/24/22.
//

import SwiftUI
import HealthKit
import GameKit

struct SelectionView: View {
    @AppStorage("ActivityGoal") var activityGoal:Int = 8
    @AppStorage("DidShowSelectionView") var isActive:Bool = false
    var valHR = 0.0
    var heartCount = 0.0
    @AppStorage("VO2Max") var vo2Max:Double = 0
    @AppStorage("FlightsClimbed") var flightsClimbed:Double = 0
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color.gray,Color.black], startPoint: .bottom, endPoint: .leading)
                .edgesIgnoringSafeArea(.all)
            
            if self.isActive {
                // 3.
                DashboardView()
            }
            else{
                
                ScrollView{
                    VStack(){
                        Image("LogoWithName")
                        Text("Typically how active are you?")
                            .font(Font.custom("Avenir", size: 24))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Button(action: {activityGoal = 5}, label: {
                            VStack{
                                Text("Lightly")
                                    .fontWeight(.heavy)
                                    .font(Font.custom("Avenir", size: 24))
                                Text("Little to no exercise (5 flights/day)")
                                    .fontWeight(.thin)
                                    .font(Font.custom("Avenir", size: 14))
                            }
                        })
                        .buttonStyle(SelectionButton(isActive: activityGoal == 5))
                        
                        Button(action: {activityGoal = 8}, label: {
                            VStack{
                                Text("Moderately")
                                    .fontWeight(.heavy)
                                    .font(Font.custom("Avenir", size: 24))
                                Text("Somewhat physically active (8 flights/day)")
                                    .fontWeight(.thin)
                                    .font(Font.custom("Avenir", size: 14))
                            }
                        })
                        .buttonStyle(SelectionButton(isActive: activityGoal == 8))
                        
                        Button(action: {activityGoal = 10}, label: {
                            VStack{
                                Text("Highly")
                                    .fontWeight(.heavy)
                                    .font(Font.custom("Avenir", size: 24))
                                Text("Dedicated work out routine (10 flights/day)")
                                    .fontWeight(.thin)
                                    .font(Font.custom("Avenir", size: 14))
                            }
                        })
                        .buttonStyle(SelectionButton(isActive: activityGoal == 10))
                        
                        Text("A flights of stairs is counted as approximately 10 feet (3 meters) of elevation gain")
                            .font(Font.custom("Avenir", size: 14))
                            .fontWeight(.thin)
                            .padding()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Button(action: {
                            fetchHealthData()
                            simpleSuccessHaptic()
                        }, label: {
                            Text("Get Started")
                                .font(Font.custom("Avenir", size: 24))
                        })
                        .buttonStyle(WhiteButton())
                        
                        
                    }
                    .padding()
                }
                .background(ZStack{
                    Image("ScreenBackground").aspectRatio(contentMode: .fit).border(.black)
                })
                .onAppear(){
                    authenticateUser()
                }
            }
        }.onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation") // Forcing the rotation to portrait
            AppDelegate.orientationLock = .portrait // And making sure it stays that way
        }.onDisappear {
            AppDelegate.orientationLock = .all // Unlocking the rotation when leaving the view
        }
    }
    
    let localPlayer = GKLocalPlayer.local
    func authenticateUser() {
        localPlayer.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            GKAccessPoint.shared.isActive = localPlayer.isAuthenticated
        }
    }
    
    func fetchHealthData()
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
                    print(cal)
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
                    
                    guard let startDate = cal.date(byAdding: .day, value: -7, to: endDate)
                    else
                    {
                        fatalError("Can't generate a startDate! :-/")
                    }
                    print(startDate)
                    print(endDate)
                    let interval = NSDateComponents()
                    interval.hour = 24
                    
                    guard let quantityType2 = HKObjectType.quantityType(forIdentifier: .flightsClimbed)
                    else{
                        fatalError("Can't get quantityType forIdentifier: .flightsClimbed!")
                    }
                    guard let quantityType = HKObjectType.quantityType(forIdentifier: .vo2Max)
                    else
                    {
                        fatalError("Can't get quantityType forIdentifier: .vo2Max!")
                    }
                    let HKquery = HKStatisticsCollectionQuery(quantityType: quantityType, quantitySamplePredicate: nil, options: .discreteAverage, anchorDate: anchorDate, intervalComponents: interval as DateComponents)
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
                                flightsClimbed = val + flightsClimbed
                                print(val)
                                print(date)
                                self.isActive = true
                            }
                        }
                        
                    }
                    HKStore.execute(HKquery2)
                    
                    HKquery.initialResultsHandler =
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
                            if let quantity = statistics.averageQuantity()
                            {
                                print(quantity)
                                let date = statistics.startDate
                                let val = quantity.doubleValue(for: HKUnit(from: "mL/min·kg"))
                                vo2Max = val
                                self.isActive = true
                            }
                        }
                        
                    }
                    HKStore.execute(HKquery)
                    
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

struct SelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionView()
    }
}


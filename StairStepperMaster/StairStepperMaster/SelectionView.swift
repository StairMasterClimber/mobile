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
    @AppStorage("NotificationPermissionDenied") var NotificationPermissionDenied:Bool = false
    @AppStorage("ActivityGoal") var activityGoal:Int = 8
    @AppStorage("SyncTime") var SyncTime:String = "just now"
    @AppStorage("DidShowSelectionView") var isActive:Bool = false
    @AppStorage("FlightsClimbedArray") var flightsClimbedArray:[Double] = [4,2,5,6,7,2,4]
    @AppStorage("ShouldSendPushNotifications") var ShouldSendPushNotifications:Bool = true
    var valHR = 0.0
    var heartCount = 0.0
    @State var rejectedPermissions = 0
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
                        Button(action: {activityGoal = 3}, label: {
                            VStack{
                                Text("Lightly")
                                    .fontWeight(.heavy)
                                    .font(Font.custom("Avenir", size: 24))
                                Text("Little to no exercise (3 flights/day)")
                                    .fontWeight(.thin)
                                    .font(Font.custom("Avenir", size: 14))
                            }
                        })
                        .buttonStyle(SelectionButton(isActive: activityGoal == 3))
                        
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
                        
                        Button(action: {activityGoal = 12}, label: {
                            VStack{
                                Text("Highly")
                                    .fontWeight(.heavy)
                                    .font(Font.custom("Avenir", size: 24))
                                Text("Dedicated work out routine (12 flights/day)")
                                    .fontWeight(.thin)
                                    .font(Font.custom("Avenir", size: 14))
                            }
                        })
                        .buttonStyle(SelectionButton(isActive: activityGoal == 12))
                        
                        Text("A flights of stairs is counted as approximately 10 feet (3 meters) of elevation gain")
                            .font(Font.custom("Avenir", size: 14))
                            .fontWeight(.thin)
                            .padding()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        if(rejectedPermissions > 1){
                            Text("You have rejected Health permissions needed for the app to work. Either delete and reinstall the app or manually go to the Health App ->Sharing ->Apps ->Stair Master Climber ->Turn On permissions")
                                .font(Font.custom("Avenir", size: 16))
                                .fontWeight(.thin)
                                .background(Color("ButtonOrange"))// : Color("ButtonGrey"))
                                .foregroundColor(Color("TextBrown"))// : .white)
                                .multilineTextAlignment(.center)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .padding()

                        }
                        Button(action: {
                            rejectedPermissions = rejectedPermissions + 1
                            notificationPermission()
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
//                    print(cal)
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
//                    print(startDate)
//                    print(endDate)
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
                    let HKFlightsQuery = HKStatisticsCollectionQuery(quantityType: quantityType2, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: interval as DateComponents)
                    var oldFlights = 0.0
                    HKFlightsQuery.initialResultsHandler =
                    {
                        query, results, error in
                        guard let statsCollection = results
                        else
                        {
                            fatalError("Unable to get results! Reason: \(String(describing: error?.localizedDescription))")
                        }
                        oldFlights = flightsClimbed
                        flightsClimbed = 0
                        
                        flightsClimbedArray.removeAll()
                        statsCollection.enumerateStatistics(from: startDate, to: endDate)
                        {
                            statistics, stop in
                            if let quantity = statistics.sumQuantity()
                            {
//                                print(quantity)
                                let date = statistics.startDate
                                let val = quantity.doubleValue(for: HKUnit(from: "count"))
//                                print(val)
                                flightsClimbedArray.append(val)
                                flightsClimbed = val + flightsClimbed
//                                print(val)
//                                print(date)
                                self.isActive = true
                            }

                        }
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMM d, hh:mm a"
                        SyncTime = dateFormatter.string(from: endDate)
                        if (flightsClimbed > oldFlights){
                            self.sendNotification(val: (flightsClimbed - oldFlights))
                        }
                        
                    }
                    HKStore.execute(HKFlightsQuery)
                    
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
//                                print(quantity)
                                let date = statistics.startDate
                                let val = quantity.doubleValue(for: HKUnit(from: "mL/min·kg"))
                                vo2Max = val
                                self.isActive = true
                            }
                        }
                        
                    }
                    HKStore.execute(HKquery)
//                    print("HERE")
                    var shouldCheck = false
                    // ---------- Saamer
                    let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.date(byAdding: .day, value: -7, to: Date()), end: Date(), options: .strictStartDate)
                    let backgroundQuery = HKObserverQuery(sampleType: HKObjectType.quantityType(forIdentifier: .flightsClimbed)!, predicate: predicate) { query, completionHandler, error in
                        if let error = error {
                            print(error.localizedDescription); return
                        }
                        if !shouldCheck{ shouldCheck = true }
                        else{
                            // HK Sample query that grabs steps
//                            HKStore.execute(HKFlightsQuery)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                // 7.
                                withAnimation {
                                    let HKFlightsQuery2 = HKStatisticsCollectionQuery(quantityType: quantityType2, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: interval as DateComponents)
                                    var oldFlights = 0.0
                                    HKFlightsQuery2.initialResultsHandler =
                                    {
                                        query, results, error in
                                        guard let statsCollection = results
                                        else
                                        {
                                            fatalError("Unable to get results! Reason: \(String(describing: error?.localizedDescription))")
                                        }
                                        oldFlights = flightsClimbed
                                        flightsClimbed = 0

                                        flightsClimbedArray.removeAll()
                                        statsCollection.enumerateStatistics(from: startDate, to: endDate)
                                        {
                                            statistics, stop in
                                            if let quantity = statistics.sumQuantity()
                                            {
//                                                print(quantity)
                                                let date = statistics.startDate
                                                let val = quantity.doubleValue(for: HKUnit(from: "count"))
//                                                print(val)
                                                flightsClimbedArray.append(val)
                                                flightsClimbed = val + flightsClimbed
//                                                print(val)
//                                                print(date)
                                                self.isActive = true
                                            }
//                                            print(syncTime)
                                        }
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "MMM d, hh:mm a"
                                        SyncTime = dateFormatter.string(from: endDate)

                                        if (flightsClimbed > oldFlights){
                                            self.sendNotification(val: (flightsClimbed - oldFlights))
                                        }
                                        calculateAchievements()
                                        
                                    }
                                    HKStore.execute(HKFlightsQuery2)
                                }
                            }
                        }
                        
                        //                                    self.sendNotification()
                        completionHandler()
                    }
                    
                    
                    HKStore.execute(backgroundQuery)
                    
                    // ------- Saamer
                }
                else
                {
                    print("Unauthorized!")
                }
            }
            HKStore.enableBackgroundDelivery(for: HKObjectType.quantityType(forIdentifier: .flightsClimbed)!, frequency: .immediate) { success, error in
                if let error = error {
                    print(error.localizedDescription)
                }
//                print(success)
            }
            
        }
        else
        {
            print("ERROR: Unable to fetch data!")
        }
    }
    
    func calculateAchievements(){
        // Skywalker-199, AllStairsLeadToRome-16, StairClimbingMasterTier1-100
        GKAchievement.loadAchievements(completionHandler: { (achievements: [GKAchievement]?, error: Error?) in
            // ROME
            let romeAchievementID = "AllStairsLeadToRome"
            var romeAchievement: GKAchievement? = nil
            romeAchievement = achievements?.first(where: { $0.identifier == romeAchievementID})
            if romeAchievement == nil {
                romeAchievement = GKAchievement(identifier: romeAchievementID)
                romeAchievement?.percentComplete=(flightsClimbed/16) * 100
            }else{
                romeAchievement?.percentComplete=(flightsClimbed/16) * 100
            }
            
            // StairClimbingMasterTier1
            let masterTier1AchievementID = "StairClimbingMasterTier1"
            var masterTier1Achievement: GKAchievement? = nil
            masterTier1Achievement = achievements?.first(where: { $0.identifier == masterTier1AchievementID})
            if masterTier1Achievement == nil {
                masterTier1Achievement = GKAchievement(identifier: masterTier1AchievementID)
                masterTier1Achievement?.percentComplete=flightsClimbed
            }else{
                masterTier1Achievement?.percentComplete=flightsClimbed
            }
            
            // Skywalker-199
            let skywalkerAchievementID = "Skywalker"
            var skywalkerAchievement: GKAchievement? = nil
            skywalkerAchievement = achievements?.first(where: { $0.identifier == skywalkerAchievementID})
            if skywalkerAchievement == nil {
                skywalkerAchievement = GKAchievement(identifier: skywalkerAchievementID)
                skywalkerAchievement?.percentComplete=(flightsClimbed/199) * 100
            }else{
                skywalkerAchievement?.percentComplete=(flightsClimbed/199) * 100
            }

            // Create an array containing the achievement.
            let achievementsToReport: [GKAchievement] = [romeAchievement!, skywalkerAchievement!, masterTier1Achievement!]
            // Report the progress to Game Center.
            GKAchievement.report(achievementsToReport, withCompletionHandler: {(error: Error?) in
                if error != nil {
                    // Handle the error that occurs.
                    print("Error: \(String(describing: error))")
                }
            })
            // Insert code to report the percentage.
            if error != nil {
                // Handle the error that occurs.
                print("Error: \(String(describing: error))")
            }
        })
    }

    func notificationPermission() {
        let center = UNUserNotificationCenter.current()
        //        center.delegate = self
        center.requestAuthorization(options: [.sound,.alert,.badge]) { (granted, error) in
            if granted {
                print("Notification Enable Successfully")
            } else {
                print("Some Error Occured")
                NotificationPermissionDenied = true
            }
        }
    }
        
    func sendNotification(val: Double) {
        if !ShouldSendPushNotifications{return}
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Flights Changed"
        notificationContent.body = "The number of flights increased by \(String(val))"
//        notificationContent.badge = NSNumber(value: 1)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: "rangeAlert", content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
}

struct SelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionView()
    }
}


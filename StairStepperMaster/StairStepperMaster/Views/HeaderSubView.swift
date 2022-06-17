//
//  HeaderSubView.swift
//  StairStepperMaster
//
//  Created by Saamer Mansoor on 6/5/22.
//

import GameKit
import SwiftUI

struct HeaderSubView: View {
    @State private var playerImage: UIImage?
    @AppStorage("GKGameCenterViewControllerState") var gameCenterViewControllerState:GKGameCenterViewControllerState = .default
    @AppStorage("IsGameCenterActive") var isGKActive:Bool = false
    @State private var displayName: String = ""
    let localPlayer = GKLocalPlayer.local
    private var quotes = ["It's never too late to be who you might have been","The person who says it cannot be done should not interrupt the person doing it","You can't fall if you don't climb, but there's no joy in living on the ground","Every mountain top is within reach if you just keep climbing"]
    @AppStorage("FlightsClimbed") var flightsClimbed:Double = 0
    @AppStorage("FlightsClimbedAtFirstInstall") var flightsClimbedAtFirstInstall:Double = 0
    @AppStorage("SyncTime") var SyncTime:String = "just now"

    var body: some View {
        HStack{
            if playerImage != nil {
                Image(uiImage: playerImage!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
                    .onTapGesture {
                        gameCenterViewControllerState = .localPlayerProfile
                        simpleSuccessHaptic()
                        isGKActive = true
                    }
            }else{
                Circle()
                    .frame(width: 96, height: 96)
                    .foregroundColor(.red)
            }
            VStack(alignment: .leading){
                Text("Hello \(GKLocalPlayer.local.displayName)")
                    .foregroundColor(.white)
                    .font(Font.custom("Avenir", size: 24))
                    .fontWeight(.heavy)
                Text(quotes.randomElement()!)
                    .foregroundColor(.white)
                    .font(Font.custom("Avenir", size: 14))
                Text("last sync: \(SyncTime)")
                    .foregroundColor(.gray)
                    .italic()
                    .font(Font.custom("Avenir", size: 14))
                    .fontWeight(.thin)
                    .italic()
                    
            }
        }
        .padding(.leading, 10)
        .onAppear(){
            if !GKLocalPlayer.local.isAuthenticated {
                authenticateUser()
            } else {
                loadPhoto()
                Task{
                    await leaderboard()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                // 7.
                withAnimation {
                    if !localPlayer.isAuthenticated {
                        authenticateUser()
                    } else if playerImage == nil {
                        loadPhoto()
                        Task{
                            await leaderboard()
                        }
                    }
                }
            }
        }
    }
    
    func authenticateUser() {
        localPlayer.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            GKAccessPoint.shared.isActive = false
            loadPhoto()
            Task{
                await leaderboard()
            }
        }
    }
    
    func leaderboard() async{
        Task{
            try await GKLeaderboard.submitScore(
                Int(flightsClimbed),
                context: 0,
                player: GKLocalPlayer.local,
                leaderboardIDs: ["com.tfp.stairsteppermaster.flights"]
            )
        }
        GKAccessPoint.shared.isActive = false
//        print("Code is run")
        calculateAchievements()
    }
    
    func loadPhoto() {
        // https://github.com/alicerunsonfedora/CS400/...PrefPaneGC.swift by Marquis Curt
        if GKLocalPlayer.local.isAuthenticated {
            GKLocalPlayer.local.loadPhoto(for: .normal) { gameImage, error in
                print(error)
                guard error == nil else { return }
                playerImage = gameImage
                displayName = GKLocalPlayer.local.displayName
            }
        }
    }
    
    func calculateAchievements(){
        // Skywalker-3900, AllStairsLeadToRome-16, StairClimbingMasterTier1-10
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
}

struct HeaderSubView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderSubView()
    }
}

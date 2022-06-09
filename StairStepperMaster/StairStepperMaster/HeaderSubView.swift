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
                        isGKActive = true
                    }
            }else{
                Circle()
                    .frame(width: 50, height: 50)
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
                Text("last sync: just now")
                    .foregroundColor(.gray)
                    .font(Font.custom("Avenir", size: 14))
                    .fontWeight(.thin)
            }
        }.frame(minWidth: 300, minHeight: 113)
        .onAppear(){
            if !GKLocalPlayer.local.isAuthenticated {
                authenticateUser()
            } else {
                loadPhoto()
                Task{
                    await leaderboard()
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
            GKAccessPoint.shared.isActive = localPlayer.isAuthenticated
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
        print("Code is run")
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
        GKAchievement.loadAchievements(completionHandler: { (achievements: [GKAchievement]?, error: Error?) in
            let romeAchievementID = "AllStairsLeadToRome"
            var romeAchievement: GKAchievement? = nil
            
            // Find an existing achievement.
            romeAchievement = achievements?.first(where: { $0.identifier == romeAchievementID})
            
            // Otherwise, create a new achievement.
            if romeAchievement == nil {
                romeAchievement = GKAchievement(identifier: romeAchievementID)
                romeAchievement?.percentComplete=(romeAchievement?.percentComplete ?? 0) + ((flightsClimbed - flightsClimbedAtFirstInstall) / flightsClimbedAtFirstInstall) * 16
            }else{
                romeAchievement?.percentComplete=(romeAchievement?.percentComplete ?? 0) + ((flightsClimbed - flightsClimbedAtFirstInstall) / flightsClimbedAtFirstInstall) * 16
            }
            // Create an array containing the achievement.
            let achievementsToReport: [GKAchievement] = [romeAchievement!]
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

//
//  DashboardView.swift
//  StairStepperMaster
//
//  Created by Saamer Mansoor on 5/27/22.
//

import SwiftUI
import GameKit
import Foundation

struct DashboardView: View {
    @AppStorage("VO2Max") var vo2Max:Double = 0
    @AppStorage("IsSettingsActive") var isSettingsActive:Bool = false
    @AppStorage("ActivityGoal") var activityGoal:Int = 8
    @AppStorage("FlightsClimbed") var flightsClimbed:Double = 0
    @State private var playerImage: UIImage?
    private var quotes = ["It's never too late to be who you might have been","The person who says it cannot be done should not interrupt the person doing it","You can't fall if you don't climb, but there's no joy in living on the ground","Every mountain top is within reach if you just keep climbing"]
    var body: some View {
        if isSettingsActive{
            SettingsView()
        }else{
            VStack(alignment: .leading){
                HStack(alignment: .top){
                    if playerImage != nil {
                        Image(uiImage: playerImage!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                            .onTapGesture {
                                GKAccessPoint.shared.isActive = true
    //                            let gameCenterViewController = GKGameCenterViewController()
    //                            gameCenterViewController.gameCenterDelegate = self
    //                            gameCenterViewController.viewState = .achievements
    //                            return gameCenterViewController

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
                        Text("last sync: just now")
                            .foregroundColor(.gray)
                            .font(Font.custom("Avenir", size: 14))
                            .fontWeight(.thin)
                    }
                    Image(systemName: "gearshape")
                        .padding([.top, .trailing])
                        .foregroundColor(.white)
                        .onTapGesture {
                        isSettingsActive = true
                    }
                }
                ScrollView{
                    if (vo2Max == 0){
                        Text("You don't have any VO2 Max data registered. You can get that data by using an Apple Watch").foregroundColor(.white)
                    }
                    else{
                        Text("Your VO2 Max is " + String(vo2Max)).foregroundColor(.white)
                    }
                    FlightsTileView()
                    MachineTileView()                    
                }
            }
            .background(ZStack{
                Image("ScreenBackground").aspectRatio(contentMode: .fit).border(.black)
            })
            .onAppear(){
                // https://github.com/alicerunsonfedora/CS400/...PrefPaneGC.swift by Marquis Curt
                if GKLocalPlayer.local.isAuthenticated {
                    GKLocalPlayer.local.loadPhoto(for: .normal) { gameImage, error in
                        print(error)
                        guard error == nil else { return }
                        playerImage = gameImage
                    }
                }
                Task {
                    print(flightsClimbed)
                    try await GKLeaderboard.submitScore(
                        Int(flightsClimbed),
                        context: 0,
                        player: GKLocalPlayer.local,
                        leaderboardIDs: ["com.tfp.stairsteppermaster.flights"]
                    )
                    GKAccessPoint.shared.isActive = false
                    print("Code is run")
                }
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}

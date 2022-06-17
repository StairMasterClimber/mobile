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
    @AppStorage("IsChallengeSomeone") var isChallengeSomeone:Bool = false
    @AppStorage("VO2Max") var vo2Max:Double = 0
    @AppStorage("IsSettingsActive") var isSettingsActive:Bool = false
    @AppStorage("GKGameCenterViewControllerState") var gameCenterViewControllerState:GKGameCenterViewControllerState = .default
    @AppStorage("IsGameCenterActive") var isGKActive:Bool = false
    @AppStorage("ActivityGoal") var activityGoal:Int = 8
    var body: some View {
        if isSettingsActive{
            SettingsView()
        }else if isGKActive{
            GameCenterView(format: gameCenterViewControllerState)
        }else if isChallengeSomeone{
            ChallengeView()
        }else {
            VStack(alignment: .leading){
                HStack(alignment: .top){
                    HeaderSubView()
                    Image(systemName: "gearshape")
                        .padding([.top, .trailing])
                        .foregroundColor(.white)
                        .onTapGesture {
                            isSettingsActive = true
                        }
                }
                DashboardSubView()
            }
            .background(ZStack{
                Image("ScreenBackground").aspectRatio(contentMode: .fit).border(.black)
            })
            .padding(.bottom)
        }
        
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}

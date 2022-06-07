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
    @AppStorage("IsGameCenterActive") var isGKActive:Bool = false
    @AppStorage("ActivityGoal") var activityGoal:Int = 8
    var body: some View {
        if isSettingsActive{
            SettingsView()
        }else if isGKActive{
            GameCenterView()
        }else{
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
                ScrollView{
                    if (vo2Max == 0){
                        Text("You don't have any VO2 Max data registered. You can get that data by using an Apple Watch").foregroundColor(.white)
                    }
                    else{
                        Text("Your VO2 Max is " + String(vo2Max)).foregroundColor(.white)
                    }
                    FlightsTileView()
                    MachineTileView()
                    LeadersTileView()
                    AchievementTileView()
                }
            }
            .background(ZStack{
                Image("ScreenBackground").aspectRatio(contentMode: .fit).border(.black)
            })
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}

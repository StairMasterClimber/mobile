//
//  DashboardView.swift
//  StairStepperMaster
//
//  Created by Saamer Mansoor on 5/27/22.
//

import SwiftUI
import GameKit
import Foundation
import StoreKit

struct DashboardView: View {
    @AppStorage("ratingTapCounter") var ratingTapCounter = 0
    @AppStorage("IsChallengeSomeone") var isChallengeSomeone:Bool = false
    @AppStorage("StairStepperTutorial") var StairStepperTutorial:Bool = false
    @AppStorage("IsSettingsActive") var isSettingsActive:Bool = false
    @AppStorage("GKGameCenterViewControllerState") var gameCenterViewControllerState:GKGameCenterViewControllerState = .default
    @AppStorage("IsGameCenterActive") var isGKActive:Bool = false
    @State private var showRatePopup = false

    var body: some View {
        if isSettingsActive{
            SettingsView()
        }else if isGKActive{
            GameCenterView(format: gameCenterViewControllerState)
        }else if isChallengeSomeone{
            ChallengeView()
        }else if StairStepperTutorial{
            MachineTutorialView()
        }else {
            VStack(alignment: .leading){
                HStack(alignment: .top){
                    HeaderSubView()
                    Spacer()
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
            .onAppear(){
                ratingTapCounter+=1
                if ratingTapCounter == 5 || ratingTapCounter == 25 || ratingTapCounter == 60 || ratingTapCounter == 100 || ratingTapCounter == 175 || ratingTapCounter == 250
                {
                    showRatePopup.toggle()
                }

            }
            .padding(.bottom)
            .alert(isPresented: $showRatePopup, content: {
                Alert(
                    title: Text(NSLocalizedString("Do you like this app?", comment: "Do you like this app?")),
                    primaryButton: .default(Text("Yes"), action: {
                        print("Pressed")
                        if let windowScene = UIApplication.shared.windows.first?.windowScene { SKStoreReviewController.requestReview(in: windowScene) }
                    }),
                    secondaryButton: .destructive(Text("No"))
                )
            })
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}

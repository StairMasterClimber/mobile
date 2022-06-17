//
//  AchievementTileView.swift
//  StairStepperMaster
//
//  Created by Saamer Mansoor on 6/6/22.
//

import SwiftUI
import GameKit

struct Achievement: Hashable {
    let id = UUID()
    let name: String
    let percentComplete: String
    let image: UIImage?
}

struct AchievementTileView: View {
    @AppStorage("GKGameCenterViewControllerState") var gameCenterViewControllerState:GKGameCenterViewControllerState = .default
    @AppStorage("IsGameCenterActive") var isGKActive:Bool = false
    @AppStorage("IsChallengeSomeone") var isChallengeSomeone:Bool = false
    @AppStorage("ActivityGoal") var activityGoal:Int = 8
    @AppStorage("FlightsClimbed") var flightsClimbed:Double = 0
    var leaderboardIdentifier = "com.tfp.stairsteppermaster.flights"
    @State var achievementsList: [Achievement] = []
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                
                Text("ACHIEVEMENTS")
                    .font(Font.custom("Avenir", size: 25))
                    .fontWeight(.heavy)
                    .padding(.leading, 20)
                    .foregroundColor(.white)
                Spacer()
                Text("Challenge Someone")
                    .font(Font.custom("Avenir", size: 14))
                    .padding(.trailing, 20)
                    .foregroundColor(Color("MoreYellow"))
                    .onTapGesture {
                        isChallengeSomeone = true
                        simpleSuccessHaptic()
                    }
            }            
            VStack{
                HStack{
                    ForEach(achievementsList, id: \.self) { item in
                        VStack{
                            Image(uiImage: item.image!)
                                .resizable()
                                .frame(width: 72, height: 72, alignment: .center)
                                .clipShape(Circle())
                            Text(item.name)
                                .font(Font.custom("Avenir",size: 10))
                                .fontWeight(.heavy)
                                .lineLimit(1)
                                .truncationMode(.middle)
                                .foregroundColor(.white)
                            Text(item.percentComplete)
                                .font(Font.custom("Avenir",size: 10))
                                .foregroundColor(.white)
                        }.padding(5)
                            .frame(maxWidth:105)
                    }
                }
                
            }
            .padding(5)
            .frame(minWidth:350, minHeight: 113)
            .background(Color("TileBackground"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }.onAppear(){
//            print("HELLOOS")
            
            Task{
                await loadAchievements()
            }
            
        }
        .onTapGesture {
            simpleWarningHaptic()
            gameCenterViewControllerState = .achievements
            isGKActive = true
        }
    }
    
    func loadAchievements() async {
        // Skywalker-3900, AllStairsLeadToRome-16, StairClimbingMasterTier1-10
        Task{
            let achievementDescriptions = try await GKAchievementDescription.loadAchievementDescriptions()
            achievementsList.removeAll()
            achievementDescriptions.forEach { achievementDescription in
                GKAchievement.loadAchievements(completionHandler: { (achievements: [GKAchievement]?, error: Error?) in
                    let achievementID = achievementDescription.identifier
                    var achievement: GKAchievement? = nil
                                        
                    // Find an existing achievement.
                    achievement = achievements?.first(where: { $0.identifier == achievementID})
                    achievementDescription.loadImage() { image, error in
//                        print(achievement)
//                        print(achievement?.percentComplete)
                        
                        if achievement?.percentComplete ?? 0 < 0 || achievement?.percentComplete ?? 0 > 100  {
                            self.achievementsList.append(Achievement(name: achievementDescription.title, percentComplete: "100%", image: image))
                        } else {
                            self.achievementsList.append(Achievement(name: achievementDescription.title, percentComplete: String(format: "%.0f",achievement?.percentComplete ?? 0.0) + "%", image: image))
                        }

                    }
                })
            }
        }
    }
}

struct AchievementTileView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementTileView()
    }
}
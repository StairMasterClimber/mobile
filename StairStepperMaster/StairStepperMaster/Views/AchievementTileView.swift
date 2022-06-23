//
//  AchievementTileView.swift
//  StairStepperMaster
//
//  Created by Saamer Mansoor on 6/6/22.
//

import SwiftUI
import GameKit
import CoreMotion

struct Achievement: Hashable {
    let id = UUID()
    let name: String
    let percentComplete: String
    let percentCompleteNumber: Double
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
    @State private var motionManager = CMMotionManager()
    @State private var rotateX : Double = 0
    @State private var rotateY : Double = 0
    @State private var rotateZ : Double = 0
    @State private var angle : Double = 3

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
                                .rotation3DEffect(.degrees(angle), axis: (x: rotateX*60, y: rotateY*60, z: rotateZ*60))
                                .shadow(color: Color("MoreYellow"), radius: rotateX.magnitude*3 + rotateY.magnitude*3, x: rotateX*3, y: rotateY*3)

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
            Task{
                if achievementsList.count < 1{
                    await loadAchievements()
                }
            }            
        }
        .onAppear() {
                print(motionManager.isDeviceMotionAvailable)
                if motionManager.isDeviceMotionAvailable {
                    motionManager.deviceMotionUpdateInterval = 0.01
                    
                    motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { data,error in
                        withAnimation {
                            rotateX = -(data?.gravity.x ?? 0)
                            rotateY = -(data?.gravity.y ?? 0)
                            rotateZ = (data?.gravity.z ?? 0)
                            angle = ((data?.gravity.x ?? 0)) * 10
                        }
                    }
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
                            self.achievementsList.append(Achievement(name: achievementDescription.title, percentComplete: "100%", percentCompleteNumber: 100, image: image))
                        } else {
                            self.achievementsList.append(Achievement(name: achievementDescription.title, percentComplete: String(format: "%.0f",achievement?.percentComplete ?? 0.0) + "%", percentCompleteNumber: achievement?.percentComplete ?? 0.0, image: image))
                        }
                        // TODO: Put this code in a better place, the code wasn't running when i placed it elsewhere
                        self.achievementsList.sort{
                            $0.percentCompleteNumber < $1.percentCompleteNumber
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

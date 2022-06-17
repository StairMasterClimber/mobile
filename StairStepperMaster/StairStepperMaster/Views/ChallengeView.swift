//
//  ChallengeView.swift
//  StairStepperMaster
//
//  Created by Saamer Mansoor on 6/14/22.
//

import SwiftUI

struct ChallengeView: View {
    @AppStorage("ActivityGoal") var activityGoal:Int = 8
    @AppStorage("IsChallengeSomeone") var isChallengeSomeone:Bool = false
    @AppStorage("AskedAboutMachine") var shouldShowInitialQuestion:Bool = true
    @AppStorage("MachineUsage") var shouldHide:Bool = false

    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Image(systemName: "chevron.left")
                        .padding()
                        .foregroundColor(.white)
                        .onTapGesture {
                            isChallengeSomeone = false
                        }
                    Spacer()
                }
                Text("SENDING CHALLENGES")
                    .font(Font.custom("Avenir", size: 25))
                    .fontWeight(.heavy)
//                    .padding(.top, 10)
                    .foregroundColor(.white)

                Text("1. If your friends are not on GameCenter, add them from by tapping on your picture in the Dashboard")
                    .multilineTextAlignment(.leading)
                    .font(Font.custom("Avenir", size: 18))
                    .padding(.top, 20)
                    .foregroundColor(.white)
                Image("sendingChallenges1")

                Text("2. The tap on the Achievements tile and tap and hold an achievement and send it to challenge your friend")
                    .multilineTextAlignment(.leading)
                    .font(Font.custom("Avenir", size: 18))
                    .foregroundColor(.white)
                Image("sendingChallenges2")

                Text("3. You can’t see challenges you sent, but you can see challenges you received in Game Center.")
                    .multilineTextAlignment(.leading)
                    .font(Font.custom("Avenir", size: 18))
                    .foregroundColor(.white)
                Image("sendingChallenges3")

                Text("4. You will get a notification when your friend beats your challenge!")
                    .font(Font.custom("Avenir", size: 18))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
                Image("sendingChallenges4")
            }
            .padding()
        }
        .background(ZStack{
            Image("ScreenBackground").aspectRatio(contentMode: .fit).border(.black)
        })
    }
}

struct ChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeView()
    }
}

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
            VStack(){
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
                Text("1. If your friends are not on GameCenter, add them from here")
                Text("2. Go here, then tap and hold an achievement and send it to your friend")
                Text("3. You can’t see challenges you sent, but you can see challenges you received here.")
                Text("4. You get a notification when your friend beats your challenge!")
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

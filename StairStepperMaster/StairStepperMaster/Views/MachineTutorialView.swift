//
//  MachineTutorialView.swift
//  StairStepperMaster
//
//  Created by Saamer Mansoor on 6/22/22.
//

import SwiftUI

struct MachineTutorialItem: Identifiable {
    var id = UUID()
    var point: String
    var body: String
}

let aboutItems: [MachineTutorialItem] =
[MachineTutorialItem(point: "1. ", body: "Stair Master Climber has the unique ability to track your stairs climbed from stair stepper machines at gyms up to a 90% accurancy."),
 MachineTutorialItem(point: "2. ", body: "After you end your workout, the app then adds your progress into your secure iPhone Health Kit and can be used by other apps as well."),
 MachineTutorialItem(point: "3. ", body: "To maximize accuracy, tap the 'Start Workout' button and place the phone in your pocket."),
 MachineTutorialItem(point: "4. ", body: "Once you are done, tap the End Workout button."),
 MachineTutorialItem(point: "5. ", body: "You will notice that your app updates your flights climbed in last 7 days with the new data. You can verify it in your device's Health App.")]

struct MachineTutorialView: View {
    @AppStorage("StairStepperTutorial") var StairStepperTutorial:Bool = false
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                HStack{
                    Image(systemName: "chevron.left")
                        .padding()
                        .foregroundColor(.white)
                        .onTapGesture {
                            StairStepperTutorial = false
                        }
                    Spacer()
                }
                Text("How To Track Stairs Climbed with Stepper Machines?")
                    .font(Font.custom("Avenir", size: 20))
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                List(aboutItems){ item in
                    Text(item.body)
                }
                ForEach(aboutItems){ item in
                    HStack(alignment: .top){
                        Text(item.point)
                            .font(Font.custom("Avenir", size: 18))
                            .foregroundColor(.white)
                        Text(item.body)
                            .multilineTextAlignment(.leading)
                            .font(Font.custom("Avenir", size: 18))
                            .foregroundColor(.white)

                    }
                }
            }
            .padding()
        }
        .background(ZStack{
            Image("ScreenBackground").aspectRatio(contentMode: .fit).border(.black)
        })
    }
}

struct MachineTutorialView_Previews: PreviewProvider {
    static var previews: some View {
        MachineTutorialView()
    }
}


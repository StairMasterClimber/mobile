//
//  SettingsView.swift
//  StairStepperMaster
//
//  Created by Saamer Mansoor on 6/3/22.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("ActivityGoal") var activityGoal:Int = 8
    @AppStorage("IsSettingsActive") var isSettingsActive:Bool = false
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
                            isSettingsActive = false
                        }
                    Spacer()
                }
                Text("Typically how active are you?")
                    .font(Font.custom("Avenir", size: 20))
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Button(action: {activityGoal = 5}, label: {
                    VStack{
                        Text("Lightly")
                            .fontWeight(.heavy)
                            .font(Font.custom("Avenir", size: 20))
                        Text("Little to no exercise (5 flights/day)")
                            .fontWeight(.thin)
                            .font(Font.custom("Avenir", size: 12))
                    }
                })
                .buttonStyle(SettingsSelectionButton(isActive: activityGoal == 5))
                
                Button(action: {activityGoal = 8}, label: {
                    VStack{
                        Text("Moderately")
                            .fontWeight(.heavy)
                            .font(Font.custom("Avenir", size: 20))
                        Text("Somewhat physically active (8 flights/day)")
                            .fontWeight(.thin)
                            .font(Font.custom("Avenir", size: 12))
                    }
                })
                .buttonStyle(SettingsSelectionButton(isActive: activityGoal == 8))
                
                Button(action: {activityGoal = 10}, label: {
                    VStack{
                        Text("Highly")
                            .fontWeight(.heavy)
                            .font(Font.custom("Avenir", size: 20))
                        Text("Dedicated work out routine (10 flights/day)")
                            .fontWeight(.thin)
                            .font(Font.custom("Avenir", size: 12))
                    }
                })
                .buttonStyle(SettingsSelectionButton(isActive: activityGoal == 10))
                
                Text("A flights of stairs is counted as approximately 10 feet (3 meters) of elevation gain")
                    .font(Font.custom("Avenir", size: 12))
                    .fontWeight(.thin)
                    .padding()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Text("Do you use a stair stepper machine?")
                    .font(Font.custom("Avenir", size: 20))
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                HStack{
                    Button(action: {
                        shouldShowInitialQuestion = false
                        shouldHide = false
                        print("Yes")
                    }, label:{ Text("Yes")
                            .font(Font.custom("Avenir", size: 16))
                            .fontWeight(.heavy)
                    })
                    .buttonStyle(TileYesNoButton(isYes: shouldHide))
                    Button(action: {
                        print("No")
                        shouldShowInitialQuestion = false
                        shouldHide = true
                    }, label:{ Text("No")
                            .font(Font.custom("Avenir", size: 16))
                            .fontWeight(.heavy)
                    })
                    .buttonStyle(TileYesNoButton(isYes: !shouldHide))
                }
            }
            .padding()
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .background(ZStack{
            Image("ScreenBackground").aspectRatio(contentMode: .fit).border(.black)
        })
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


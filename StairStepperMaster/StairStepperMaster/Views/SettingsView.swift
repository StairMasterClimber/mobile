//
//  SettingsView.swift
//  StairStepperMaster
//
//  Created by Saamer Mansoor on 6/3/22.
//

import SwiftUI
import WidgetKit

struct SettingsView: View {
    @AppStorage("ActivityGoal") var activityGoal:Int = 8
    @AppStorage("AskedAboutMachine") var shouldShowInitialQuestion:Bool = true
    @AppStorage("MachineUsage") var shouldHide:Bool = false
    @AppStorage("ShouldSendPushNotifications") var ShouldSendPushNotifications:Bool = true
    @AppStorage("NotificationPermissionDenied") var NotificationPermissionDenied:Bool = false
    var activityLevelGoals = [3, 8, 12]

    var body: some View {
        ScrollView{
            VStack(alignment:.leading){
                HStack{
                    Text("SETTINGS")
                        .font(Font.custom("Avenir", size: 25))
                        .fontWeight(.heavy)
                        .padding([.top,.bottom], 10)
                        .foregroundColor(.white)
                    Spacer()
                }
                Text("Typically how active are you")
                    .font(Font.custom("Avenir", size: 20))
//                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Picker(selection: $activityGoal, label: Text("Typically how active are you?")) {
                    ForEach(activityLevelGoals, id: \.self) {
                        Text($0 == 3 ? "Lightly" : ($0 == 8 ? "Moderately" : "Highly"))
                            .font(Font.custom("Avenir", size: 20))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                }
                .pickerStyle(.segmented)
                
                Text("A flights of stairs is counted as approximately 10 feet (3 meters) of elevation gain")
                    .font(Font.custom("Avenir", size: 12))
                    .fontWeight(.thin)
                    .padding()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Text("Do you use a stair stepper machine")
                    .font(Font.custom("Avenir", size: 20))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                HStack{
                    Spacer()
                    Button(action: {
                        shouldShowInitialQuestion = false
                        shouldHide = false
                    }, label:{ Text("Yes")
                            .font(Font.custom("Avenir", size: 16))
                            .fontWeight(.heavy)
                    })
                    .buttonStyle(TileYesNoButton(isYes: shouldHide))
                    Spacer()
                    Button(action: {
//                        print("No")
                        shouldShowInitialQuestion = false
                        shouldHide = true
                    }, label:{ Text("No")
                            .font(Font.custom("Avenir", size: 16))
                            .fontWeight(.heavy)
                    })
                    .buttonStyle(TileYesNoButton(isYes: !shouldHide))
                    Spacer()
                }
                Text("Push Notifications")
                    .font(Font.custom("Avenir", size: 20))
                    .padding(.top, 10)
                    .foregroundColor(.white)

//                    .font(Font.custom("Avenir", size: 20))
//                    .fontWeight(.heavy)
//                    .foregroundColor(.white)
//                    .multilineTextAlignment(.center)
                if NotificationPermissionDenied{
                    Text("You have rejected Push Notification permissions needed to alert about progress. Either delete and reinstall the app or manually go to the Settings App -> Stair Master Climber ->Turn On Push Notification permissions")
                        .font(Font.custom("Avenir", size: 12))
                        .padding(.bottom, 8)
                        .foregroundColor(.red)
// TODO: Remove this after verifying
//                    Text("You have rejected Push Notification permissions needed to alert about progress. Either delete and reinstall the app or manually go to the Settings App -> Stair Master Climber ->Turn On Push Notification permissions")
//                        .font(Font.custom("Avenir", size: 16))
//                        .fontWeight(.thin)
//                        .background(Color("ButtonOrange"))// : Color("ButtonGrey"))
//                        .foregroundColor(Color("TextBrown"))// : .white
//                        .multilineTextAlignment(.center)
//                        .clipShape(RoundedRectangle(cornerRadius: 4))
//                        .padding()
                }
                else{
                    HStack{
                        Spacer()
                        Button(action: {
                            ShouldSendPushNotifications = true
                        }, label:{ Text("On")
                                .font(Font.custom("Avenir", size: 16))
                                .fontWeight(.heavy)
                        })
                        .buttonStyle(TileYesNoButton(isYes: !ShouldSendPushNotifications))
                        Spacer()
                        Button(action: {
                            ShouldSendPushNotifications = false
                        }, label:{ Text("Off")
                                .font(Font.custom("Avenir", size: 16))
                                .fontWeight(.heavy)
                        })
                        .buttonStyle(TileYesNoButton(isYes: ShouldSendPushNotifications))
                        Spacer()
                    }
                }
                Text("Contact Us or Watch Tutorial")
                    .font(Font.custom("Avenir", size: 20))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                HStack{
                    Spacer()
                    Link("Visit Website", destination: URL(string: "https://www.stairmasterclimber.com")!)
                        .font(Font.custom("Avenir", size: 16))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(minWidth: 160)
                        .padding()
                        .background(Color("ButtonGrey"))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .black, radius: 4, x: 0, y: 2)

                    Spacer()
                }

            }
            .onChange(of: activityGoal, perform: { newGoal in
                if let userDefaults = UserDefaults(suiteName: "group.com.tfp.stairsteppermaster") {
                    userDefaults.setValue(newGoal, forKey: "widgetActivityGoal")
                }
                WidgetCenter.shared.reloadAllTimelines()
            })
            .padding([.horizontal, .bottom])
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


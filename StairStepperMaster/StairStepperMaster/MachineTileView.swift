//
//  MachineTileView.swift
//  StairStepperMaster
//
//  Created by Saamer Mansoor on 5/27/22.
//

import SwiftUI

struct MachineTileView: View {
//    @AppStorage("AskedAboutMachine") var shouldShowInitialQuestion:Bool = true
//    @AppStorage("MachineUsage") var shouldHide:Bool = false
//    @AppStorage("DidStartWorkout") var didStartWorkout:Bool = false
    @State private var shouldShowInitialQuestion:Bool = true
    @State private var shouldHide:Bool = false
    @State private var didStartWorkout:Bool = false

    var body: some View {
        if !shouldHide{
            VStack{
                Text("STAIR STEPPER MACHINE")
                    .font(Font.custom("Avenir", size: 25))
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                VStack{
                    if shouldShowInitialQuestion{
                        Text("Do you use a Stair Stepper Machine?")
                            .font(Font.custom("Avenir", size: 14))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        HStack{
                            Button(action: {
                                shouldShowInitialQuestion = false
                                print("Yes")
                            }, label:{ Text("Yes")
                                    .font(Font.custom("Avenir", size: 20))
                                    .fontWeight(.heavy)
                            })
                            .buttonStyle(TileYesNoButton(isYes: true))
                            Button(action: {
                                print("No")
                                shouldShowInitialQuestion = false
                                shouldHide = true
                            }, label:{ Text("No")
                                    .font(Font.custom("Avenir", size: 20))
                                    .fontWeight(.heavy)
                            })
                            .buttonStyle(TileYesNoButton(isYes: false))
                        }
                    }
                    else if !didStartWorkout{
                        Text("Would you like us to record your machine workout?")
                            .font(Font.custom("Avenir", size: 14))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Button(action: {
                            print("Yes")
                            didStartWorkout = true
                        }, label:{
                            Text("Start Workout")
                                .font(Font.custom("Avenir", size: 20))
                                .fontWeight(.heavy)
                        })
                        .buttonStyle(TileStartStopButton(isStart: true))
                    }
                    else {
                        Text("Tap the button when you are done")
                            .font(Font.custom("Avenir", size: 14))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Button(action: {
                            print("Yes")
                            didStartWorkout = false
                        }, label:{ Text("End Workout")
                                .font(Font.custom("Avenir", size: 20))
                                .fontWeight(.heavy)
                        })
                        .buttonStyle(TileStartStopButton(isStart: false))
                    }
                }
                .padding()
                .frame(minWidth:350, minHeight: 113)
                .background(Color("TileBackground"))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }
}

struct MachineTileView_Previews: PreviewProvider {
    static var previews: some View {
        MachineTileView()
    }
}

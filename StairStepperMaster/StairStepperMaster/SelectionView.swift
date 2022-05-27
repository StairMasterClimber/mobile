//
//  ContentView.swift
//  StairStepperMaster
//
//  Created by Saamer Mansoor on 5/24/22.
//

import SwiftUI

struct SelectionView: View {
    @State private var isEnabled:Int = 43
    @AppStorage("DidShowSelectionView") var isActive:Bool = false

    var body: some View {
        if self.isActive {
            // 3.
            DashboardView()
        }
        else{

            ScrollView{
                VStack(){
                    Image("LogoWithName")
                    Text("Typically how active are you?")
                        .font(Font.custom("Avenir", size: 24))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    Button(action: {print("asf")}, label: {
                        VStack{
                            Text("Lightly")
                                .fontWeight(.heavy)
                                .font(Font.custom("Avenir", size: 24))
                            Text("Little to no exercise")
                                .fontWeight(.thin)
                                .font(Font.custom("Avenir", size: 14))
                        }
                    })
                    .buttonStyle(GreyButton())

                    Button(action: {print("asf")}, label: {
                        VStack{
                            Text("Moderately")
                                .fontWeight(.heavy)
                                .font(Font.custom("Avenir", size: 24))
                            Text("Somewhat physically active")
                                .fontWeight(.thin)
                                .font(Font.custom("Avenir", size: 14))
                        }
                    })
                    .buttonStyle(OrangeButton())

                    Button(action: {print("asf")}, label: {
                        VStack{
                            Text("Highly")
                                .fontWeight(.heavy)
                                .font(Font.custom("Avenir", size: 24))
                            Text("Dedicated work out routine")
                                .fontWeight(.thin)
                                .font(Font.custom("Avenir", size: 14))
                        }
                    })
                    .buttonStyle(GreyButton())

                    Text("A flights of stairs is counted as approximately 10 feet (3 meters) of elevation gain")
                        .font(Font.custom("Avenir", size: 14))
                        .fontWeight(.thin)
                        .padding()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    Button(action: {
                        simpleSuccessHaptic()
                        self.isActive = true
                    }, label: {
                        Text("Get Started")
                            .font(Font.custom("Avenir", size: 24))
                    })
                    .buttonStyle(WhiteButton())


                }
            }
            .background(ZStack{
                Image("ScreenBackground").aspectRatio(contentMode: .fit).border(.black)
            }.background(.black))
        }
    }
}

struct SelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionView()
    }
}

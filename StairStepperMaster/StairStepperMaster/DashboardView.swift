//
//  DashboardView.swift
//  StairStepperMaster
//
//  Created by Saamer Mansoor on 5/27/22.
//

import SwiftUI

struct DashboardView: View {
    @AppStorage("VO2Max") var vo2Max:Double = 0
    @AppStorage("FlightsClimbed") var flightsClimbed:Double = 0

    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                HStack{
                    Circle()
                        .frame(width: 96, height: 96)
                        .foregroundColor(.red)
                    VStack(alignment: .leading){
                        Text("Hello James,")
                            .foregroundColor(.white)
                            .font(Font.custom("Avenir", size: 24))
                            .fontWeight(.heavy)
                        Text("It’s sunny today in SF, \nyou should take a walk :) ")
                            .foregroundColor(.white)
                            .font(Font.custom("Avenir", size: 14))
                        Text("last sync: just now")
                            .foregroundColor(.white)
                            .font(Font.custom("Avenir", size: 14))
                            .fontWeight(.thin)
                    }
                }
                if (vo2Max == 0){
                    Text("You don't have any VO2 Max data registered. You can get that data by using an Apple Watch").foregroundColor(.white)
                }
                else{
                    Text("Your VO2 Max is " + String(vo2Max)).foregroundColor(.white)
                }
                Text("Your flights climbed in the last 30 days is " + String(flightsClimbed)).foregroundColor(.white)
                MachineTileView()
            }
        }
        .background(ZStack{
            Image("ScreenBackground").aspectRatio(contentMode: .fit).border(.black)
        }.background(Color("BrandBlack")))
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}

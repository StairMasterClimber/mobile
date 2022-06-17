//
//  FlightsTileView.swift
//  StairStepperMaster
//
//  Created by Hitesh Parikh on 6/2/22.
//

import SwiftUI

struct FlightsTileView: View {

    @AppStorage("ActivityGoal") var activityGoal:Int = 8
    @AppStorage("FlightsClimbed") var flightsClimbed:Double = 0

    var body: some View {
        VStack(spacing: 0){
           
            HStack{

            Text("ACTIVITY")
                .font(Font.custom("Avenir", size: 25))
                .fontWeight(.heavy)
                .padding(.leading, 20)
                .foregroundColor(.white)
  Spacer()
            }

            VStack{
                Text("Flights climbed last 7 days: " + String(format: "%.0f",flightsClimbed) + "\n Goal: \(activityGoal*7)").foregroundColor(.white)
                    .font(Font.custom("Avenir", size: 21))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
            }
            .padding()
            .frame(minWidth:353, minHeight: 113)
            .background(Color("TileBackground"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        
    }
}

struct FlightsTileView_Previews: PreviewProvider {
    static var previews: some View {
        FlightsTileView()
    }
}

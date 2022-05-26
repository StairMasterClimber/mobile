//
//  FlightsClimbedTile.swift
//  StairStepperMaster
//
//  Created by Shakira Reid-Thomas on 5/26/22.
//

import SwiftUI
import LightChart

struct FlightsClimbedTile: View {
    var body: some View {
        
        ZStack{
            Tile()
            HStack() {
                Image("stair")
                VStack {
                    VStack(){
                        Text("Flights")
                            .font(Font.custom("AvenirLTStd-Light", size: 14))
                            .foregroundColor(.white)
                        Text("35")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding(.bottom, 12)
            
                    VStack(){
                        Text("Goal")
                            .font(Font.custom("AvenirLTStd-Light", size: 14))
                        Text("70")
                            .bold()
                    }
                }
            
               
            
                LightChartView(data: [15, 10, 5, 8],
                    type: .curved, visualType: .customFilled(color: Color("graphOrange") ,
                lineWidth: 3,
                fillGradient: LinearGradient(
                    gradient: .init(colors: [Color("graphOrange").opacity(0.7), Color("graphOrange").opacity(0.3)]),
                    startPoint: .init(x: 0.5, y: 1),
                endPoint: .init(x: 0.5, y: 0)
                )))
            .frame(width: 159.15, height: 80.75)
            }

        }
        
    }
}

struct FlightsClimbedTile_Previews: PreviewProvider {
    static var previews: some View {
        FlightsClimbedTile()
    }
}

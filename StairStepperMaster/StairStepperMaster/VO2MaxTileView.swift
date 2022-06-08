//
//  VO2MaxTileView.swift
//  StairStepperMaster
//
//  Created by Saamer Mansoor on 6/8/22.
//

import SwiftUI

struct VO2MaxTileView: View {
    @AppStorage("VO2Max") var vo2Max:Double = 0

    var body: some View {
        VStack(spacing:0){
            HStack{
                Text("WELLNESS")
                    .font(Font.custom("Avenir", size: 25))
                    .fontWeight(.heavy)
                    .padding(.leading, 19)
                    .foregroundColor(.white)
                Spacer()
            }
            VStack(alignment: .center){
                if (vo2Max == 0){
                    Text("You don't have any VO2 Max data registered. You can get that data by using an Apple Watch")
                        .font(Font.custom("Avenir", size: 21))
                        .foregroundColor(.white)
                        .padding()
                }
                else{
                    Text("Your VO2 Max is " + String(vo2Max))
                        .font(Font.custom("Avenir", size: 21))
                        .foregroundColor(.white)
                        .padding()
                }
            }
            .frame(minWidth:350, minHeight: 113)
            .background(Color("TileBackground"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding([.horizontal])
    }
}

struct VO2MaxTileView_Previews: PreviewProvider {
    static var previews: some View {
        VO2MaxTileView()
    }
}

//
//  VO2TileView.swift
//  StairStepperMaster
//
//  Created by Shakira Reid-Thomas on 6/7/22.
//

import SwiftUI

struct VO2TileView: View {
    
    
    @AppStorage("VO2Max") var vo2Max:Double = 0
    
    var body: some View {
        VStack{
                Text("Your VO2 Max is " + String(vo2Max))
                   .font(Font.custom("AvenirLTStd-Light", size: 21))
                   .foregroundColor(.white)
                   .padding()
                   .frame(minWidth:350, minHeight: 113)
                   .background(Color("TileBackground"))
                   .clipShape(RoundedRectangle(cornerRadius: 20))
               }
            }
       }

struct VO2TileView_Previews: PreviewProvider {
    static var previews: some View {
        VO2TileView()
    }
}

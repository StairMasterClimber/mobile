//
//  Tile.swift
//  StairStepperMaster
//
//  Created by Shakira Reid-Thomas on 5/26/22.
//

import SwiftUI

struct Tile: View {

    
    var body: some View {
    
            Rectangle()
                .foregroundColor(Color("tileGray"))
                .frame(width: 343, height: 114)
                .cornerRadius(14)    
    }
}

struct Tile_Previews: PreviewProvider {
    static var previews: some View {
        Tile()
    }
}


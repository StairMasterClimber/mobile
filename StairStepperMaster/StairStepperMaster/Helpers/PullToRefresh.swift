//
//  PullToRefresh.swift
//  StairStepperMaster
//
//  Created by Saamer Mansoor on 6/16/22.
//

import SwiftUI

struct PullToRefresh: View {
    
    var coordinateSpaceName: String
    var onRefresh: ()->Void
    
    @State var needRefresh: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName)).midY > 50) {
                Spacer()
                    .onAppear {
                        needRefresh = true
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 10) {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            needRefresh = false
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
                if needRefresh {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("MoreYellow")))
                } else {
                    Text("Pull to refresh")
                        .foregroundColor(Color("MoreYellow"))
                        .font(Font.custom("Avenir", size: 16))
                }
                Spacer()
            }
        }.padding(.top, -50)
    }
}

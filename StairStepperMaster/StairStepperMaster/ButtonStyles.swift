//
//  ButtonStyles.swift
//  StairStepperMaster
//
//  Created by Saamer Mansoor on 5/27/22.
//
import Foundation
import SwiftUI

struct WhiteButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 300)
            .padding()
            .cornerRadius(23)
            .background(Color(red: 1, green: 1, blue: 1))
            .foregroundColor(.black)
            .clipShape(Capsule())
            .shadow(color: .black, radius: 4, x: 0, y: 2)
    }
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 300)
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct GreyButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 300)
            .padding()
            .background(Color("ButtonGrey"))
            .foregroundColor(.white)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .cornerRadius(62)
            .shadow(color: .black, radius: 4, x: 0, y: 2)
    }
}

struct OrangeButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 300)
            .cornerRadius(62)
            .padding()
            .background(Color("ButtonOrange"))
            .foregroundColor(Color("TextBrown"))
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

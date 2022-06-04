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
            .background(Color(red: 1, green: 1, blue: 1))
            .foregroundColor(.black)
            .clipShape(RoundedRectangle(cornerRadius: 23))
            .shadow(color: .black, radius: 4, x: 0, y: 2)
    }
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 300)
            .padding()
            .background(Color("BrandBlack"))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 62))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct SelectionButton: ButtonStyle {
    var isActive:Bool = false
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 300)
            .padding()
            .background(isActive ? Color("ButtonOrange") : Color("ButtonGrey"))
            .foregroundColor(isActive ? Color("TextBrown") : .white)
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
            .clipShape(RoundedRectangle(cornerRadius: 62))
            .shadow(color: .black, radius: 4, x: 0, y: 2)
    }
}

struct SettingsSelectionButton: ButtonStyle {
    var isActive:Bool = false
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 250)
            .padding()
            .background(isActive ? Color("ButtonOrange") : Color("ButtonGrey"))
            .foregroundColor(isActive ? Color("TextBrown") : .white)
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
            .clipShape(RoundedRectangle(cornerRadius: 62))
            .shadow(color: .black, radius: 4, x: 0, y: 2)
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
            .clipShape(RoundedRectangle(cornerRadius: 62))
            .shadow(color: .black, radius: 4, x: 0, y: 2)
    }
}

struct OrangeButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 300)
            .padding()
            .background(Color("ButtonOrange"))
            .foregroundColor(Color("TextBrown"))
            .clipShape(RoundedRectangle(cornerRadius: 62))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct GreyTileButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 225)
            .background(Color("ButtonGrey"))
            .foregroundColor(.white)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .clipShape(RoundedRectangle(cornerRadius: 62))
            .shadow(color: .black, radius: 4, x: 0, y: 2)
    }
}

struct OrangeTileButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 225)
            .background(Color("ButtonOrange"))
            .foregroundColor(Color("TextBrown"))
            .clipShape(RoundedRectangle(cornerRadius: 62))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct TileStartStopButton: ButtonStyle {
    var isStart:Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 225, minHeight: 44)
            .background(isStart ? Color("ButtonGrey") : Color("ButtonOrange"))
            .foregroundColor(isStart ? .white : Color("TextBrown"))
            .clipShape(RoundedRectangle(cornerRadius: 62))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .shadow(color: .black, radius: 4, x: 0, y: 2)
    }
}


struct TileYesNoButton: ButtonStyle {
    var isYes:Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 80)
            .padding()
            .background(isYes ? Color("ButtonGrey") : Color("ButtonOrange"))
            .foregroundColor(isYes ? .white : Color("TextBrown"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .shadow(color: .black, radius: 4, x: 0, y: 2)
    }
}

struct TileYesButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 103)
            .padding()
            .background(Color("ButtonGrey"))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .shadow(color: .black, radius: 4, x: 0, y: 2)
    }
}

struct TileNoButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 103)
            .padding()
            .background(Color("ButtonOrange"))
            .foregroundColor(Color("TextBrown"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

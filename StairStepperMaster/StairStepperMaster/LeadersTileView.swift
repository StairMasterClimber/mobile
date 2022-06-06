//
//  LeadersTileView.swift
//  StairStepperMaster
//
//  Created by Saamer Mansoor on 6/5/22.
//

import SwiftUI
import GameKit

struct Player: Hashable {
    let id = UUID()
    let name: String
    let image: UIImage?
}

struct LeadersTileView: View {

    @AppStorage("ActivityGoal") var activityGoal:Int = 8
    @AppStorage("FlightsClimbed") var flightsClimbed:Double = 0
    var leaderboardIdentifier = "com.tfp.stairsteppermaster.flights"
    @State var players: [Player] = []

    var body: some View {
        VStack(spacing: 0){
           
            HStack{

            Text("COMPETITION")
                .font(Font.custom("Avenir", size: 25))
                .fontWeight(.heavy)
                .padding(.leading, 19)
                .foregroundColor(.white)
  Spacer()
            }

            VStack{
                HStack{
                    ForEach(players, id: \.self) { item in
                        VStack{
                            Image(uiImage: item.image!)
                                .resizable()
                                .frame(width: 72, height: 72, alignment: .center)
                                .clipShape(Circle())
                            Text(item.name)
                                .font(Font.custom("Avenir",size: 10))
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                        }.padding(15)
                    }
                }
                
            }
            .padding()
            .frame(minWidth:353, minHeight: 113)
            .background(Color("TileBackground"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }.onAppear(){
            print("HELLOS")
            if !GKLocalPlayer.local.isAuthenticated {
                authenticateUser()
            } else {
                loadLeaderboard()
            }

        }
    }
    
    func authenticateUser() {
        GKLocalPlayer.local.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            loadLeaderboard()
        }
    }
    
    func loadLeaderboard() {
        GKLeaderboard.loadLeaderboards(IDs: [leaderboardIdentifier]) { (leaderboards, error) in
            if let leaderboard = leaderboards?.filter ({ $0.baseLeaderboardID == self.leaderboardIdentifier }).first {
                leaderboard.loadEntries(for: .global, timeScope: .allTime, range: NSRange(1...3)) { (_, allPlayers, _, error) in
                    if let allPlayers = allPlayers {
                        allPlayers.forEach { leaderboardEntry in
                            leaderboardEntry.player.loadPhoto(for: .small) { image, error in
                                var numberOfAddedPlayers = 0
//                                if (leaderboardEntry.player.displayName != GKLocalPlayer.local.displayName && numberOfAddedPlayers < 3){
                                    self.players.append(Player(name: leaderboardEntry.player.displayName, image: image))
                                    numberOfAddedPlayers = numberOfAddedPlayers + 1
//                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct LeadersTileView_Previews: PreviewProvider {
    static var previews: some View {
        LeadersTileView()
    }
}

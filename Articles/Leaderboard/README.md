# Leaderboard

In this article we will talk about how to implement Leaderboard within your app

Most of the logic for the leaderboard is in [this file](httpshttps://github.com/StairMasterClimber/mobile/blob/main/StairStepperMaster/StairStepperMaster/Views/LeadersTileView.swift)

Here's a quick break down

### 1. Authentication

The user needs to first be authenticated to GameCenter in order for any of this functionality to work.
So we use this code to do that:
```
func authenticateUser() {
    GKLocalPlayer.local.authenticateHandler = { vc, error in
        guard error == nil else {
            print(error?.localizedDescription ?? "")
            return
        }
        Task{
            await loadLeaderboard(source: 3)
        }
    }
}
```

### 2. Diplaying Leaderboard items in UI

In order to get the data away from the GameCenter ViewController, you need to use the code below. You can switch up the `loadEntries` function from `.global` to `.friends` in order to only pull your friends.
Using `1...5`, you can choose how many to display, which pulls the users with the highest 5 scores and returns 1 if there's only 1 user.
The problem is that I am unable to sort correctly no matter what I do using the sort algorithm I used.
```
func loadLeaderboard(source: Int = 0) async {
    print(source)
    print("source")
    playersList.removeAll()
    Task{
        var playersListTemp : [Player] = []
        let leaderboards = try await GKLeaderboard.loadLeaderboards(IDs: [leaderboardIdentifier])
        if let leaderboard = leaderboards.filter ({ $0.baseLeaderboardID == self.leaderboardIdentifier }).first {
            let allPlayers = try await leaderboard.loadEntries(for: .global, timeScope: .allTime, range: NSRange(1...5))
            if allPlayers.1.count > 0 {
                try await allPlayers.1.asyncForEach { leaderboardEntry in
                    var image = try await leaderboardEntry.player.loadPhoto(for: .small)
                    playersListTemp.append(Player(name: leaderboardEntry.player.displayName, score:leaderboardEntry.formattedScore, image: image))
                                print(playersListTemp)
                    playersListTemp.sort{
                        $0.score < $1.score
                    }
                }
            }
        }
        playersList = playersListTemp            
    }
}
```
### 3. Call functionality as view appears

You can take advantage of the onAppear lifecycle function of the view to actually make the calls to authenticate & load etc. But you can also do it on the tap of a button if you prefer.
```
.onAppear(){
    if !GKLocalPlayer.local.isAuthenticated {
        authenticateUser()
    } else if playersList.count == 0 {
        Task{
            await loadLeaderboard(source: 1)
        }
    }
}
```

### 4. Submitted a score

In order to load the scores, you obviously need to submit scores as well. This function can help you with that. 
Note that you have to switch the `flightsClimbed` value with your own. 
Additionally, the leaderboardId has to match with what you manually create in your App Store Connect account:
```
func leaderboard() async{
    Task{
        try await GKLeaderboard.submitScore(
            Int(flightsClimbed),
            context: 0,
            player: GKLocalPlayer.local,
            leaderboardIDs: ["com.tfp.stairsteppermaster.flights"]
        )
    }
    GKAccessPoint.shared.isActive = false
    calculateAchievements()
}
```

## Pain points:

* It is hard to work collaboratively on this because other developers cannot access your leaderboardID, so they also have to create their own leaderboard on their Apple account and reference it from the app.
* Also, for some reason the authenticate to GameCenter is extremely slow on a simulator, so it might make sense to even create a mock of data when using the simulator
* This is different from "Achievements" which is calculated and displayed differently

# How to implement a Leaderboard in SwiftUI

In this article we will talk about how to implement Leaderboard within your app. We have followed these steps while implementing the GameCenter Leaderboard in the [Stair Master Climber iPhone Health & Fitness app](https://stairmasterclimber.com/app). 

### Requirements

* You have to have an Apple Developer paid account
* You have to create the App Id for your app in the provisioning profiles section of the Apple Developer Portal
* You have to create the App in App Store Connect portal

## Procedure

Most of the code logic for the leaderboard is in [this file if you want to skip ahead](httpshttps://github.com/StairMasterClimber/mobile/blob/main/StairStepperMaster/StairStepperMaster/Views/LeadersTileView.swift)

Here's a quick break down of the steps taken to implement this:

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
<img width="232" alt="image" src="https://user-images.githubusercontent.com/8262287/180823235-cafefcfa-3d25-46e5-8524-d7f475b9a000.png">

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
<img width="311" alt="image" src="https://user-images.githubusercontent.com/8262287/180823292-2dee4f9a-4894-4442-9241-2ad1c84b1cf7.png">

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
    calculateAchievements()
}
```

### 5. App Store Connect Leaderboard Creation

Once you have created the app in the App Store Connect portal successfully, you need to go ahead and add a new leaderboard using the "+" sign. The LeaderboardID you input there, is the one that you need to use in all the places in the code that ask for it

<img width="674" alt="image" src="https://user-images.githubusercontent.com/8262287/180824532-2e27ca8a-c1c0-4676-b439-f3ab09887271.png">

### 6. GameCenter ViewController portal

When you're logged in to GameCenter, the little annoying icon appears in the top right of your screen. When you tap on it, you are taken to the GameCenter ViewController. But you can hide it if its not part of your design, using `GKAccessPoint.shared.isActive = false`. In order to make the View Controller appear using a different button, since it's a `ViewController` and not a simple `View` you need to have this UIViewControllerRepresentable first, as you can [see here](https://github.com/StairMasterClimber/mobile/blob/main/StairStepperMaster/StairStepperMaster/Views/GameCenterView.swift).

Once you add that file to your project, you can display the GameCenter portal simply using this: `GameCenterView(format: gameCenterViewControllerState)` where gameCenterViewControllerState can be `.leaderboards` so as to go directly to that page

``
![IMG_2582](https://user-images.githubusercontent.com/8262287/180823132-ffe7f2c1-eff1-4900-b9a8-6d1a6da96071.PNG)

## Pain points:

* It is hard to work collaboratively on this because other developers cannot access your leaderboardID, so they also have to create their own leaderboard on their Apple account and reference it from the app.
* Also, for some reason the authenticate to GameCenter is extremely slow on a simulator, so it might make sense to even create a mock of data when using the simulator
* This is different from "Achievements" which is calculated and displayed differently

## Pros:

* There are many pros of using GameCenter leaderboards in general
* With iOS 16, if your friend beats your score, you get a notificiation, motivating you to get back in the game

### Screenshot of the App

![IMG_2581](https://user-images.githubusercontent.com/8262287/180823148-bcf0d9ef-dd19-40a3-8433-14fde1b582e2.PNG)

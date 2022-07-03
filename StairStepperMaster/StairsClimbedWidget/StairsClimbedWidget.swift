//
//  StairsClimbedWidget.swift
//  StairsClimbedWidget
//
//  Created by Saamer Mansoor on 6/26/22.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct StairsClimbedWidgetEntryView : View {
    let dateFormatter = DateFormatter()
    init(){
        dateFormatter.dateFormat = "MMM d, hh:mm a"
    }
    var body: some View {
        VStack{
            if let userDefaults = UserDefaults(suiteName: "group.com.tfp.stairsteppermaster") {
                if let flightsClimbedArray = userDefaults.array(forKey: "activityArray") as? [Double] ?? []
                {
                    if flightsClimbedArray.count > 0
                    {
                        if let SyncTime = userDefaults.string(forKey: "widgetSyncTime")
                        {
                            Text("last sync: \(SyncTime)" + (dateFormatter.string(from: Date()) == SyncTime ? "" : ". Refresh data in app"))
                                .foregroundColor(dateFormatter.string(from: Date()) == SyncTime ? .white : Color("MoreYellow"))
                                .italic()
                                .font(Font.custom("Avenir", size: 14))
                                .fontWeight(.thin)
                                .italic()
                                .padding(.top)
                        }
                        if let storedFlightsClimbed = userDefaults.double(forKey: "widgetFlightsClimbed"), let storedActivityGoal = userDefaults.integer(forKey: "widgetActivityGoal"){
                            ActivityChartTileWidgetSharedView(flightsArrayPadded: flightsClimbedArray, flightsClimbed: storedFlightsClimbed, activityGoal: storedActivityGoal)
                        } else {
                            ActivityChartTileWidgetSharedView(flightsArrayPadded: flightsClimbedArray, flightsClimbed: 40, activityGoal: 7)
                        }
                    }else{
                        Text("Get Started in the app")
                            .font(Font.custom("Avenir", size: 16))
                            .fontWeight(.black)
                    }
                } else{
                    Text("Get Started in the app")
                        .font(Font.custom("Avenir", size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(Color("SecondaryColor"))
                }
            }else{
                Text("Get Started in the app")
            }
//        }.background(Color.black)
        }.background(Color("BrandColor"))
    }
}

@main
struct StairsClimbedWidget: Widget {
    let kind: String = "StairsClimbedWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            StairsClimbedWidgetEntryView()
        }
        .configurationDisplayName("Activity Widget")
        .supportedFamilies([.systemMedium])
        .description("This widget displays the last 7 days of stairs climbed")
    }
}

struct StairsClimbedWidget_Previews: PreviewProvider {
    static var previews: some View {
        StairsClimbedWidgetEntryView()
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

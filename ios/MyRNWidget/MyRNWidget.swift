//
//  MyRNWidget.swift
//  MyRNWidget
//
//  Created by Trinh Chin on 3/13/22.
//

import WidgetKit
import SwiftUI
import Intents

struct WidgetData: Decodable {
  var text: String
}

struct Provider: IntentTimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: ConfigurationIntent(), text: "Placeholder")
  }
  
  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), configuration: configuration, text: "Data goes here")
    completion(entry)
  }
  
  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [SimpleEntry] = []
    //
    //        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    //        let currentDate = Date()
    //        for hourOffset in 0 ..< 5 {
    //            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
    //            let entry = SimpleEntry(date: entryDate, configuration: configuration)
    //            entries.append(entry)
    //        }
    //
    //        let timeline = Timeline(entries: entries, policy: .atEnd)
    //        completion(timeline)
    let userDefaults = UserDefaults.init(suiteName: "group.org.chnirt.RNWidget")
    if userDefaults != nil {
      let currentDate = Date()
      if let savedData = userDefaults!.value(forKey: "widgetKey") as? String {
        let decoder = JSONDecoder()
        let data = savedData.data(using: .utf8)
        if let parsedData = try? decoder.decode(WidgetData.self, from: data!) {
          let nextRefresh = Calendar.current.date(byAdding: .second, value: 3, to: currentDate)!
          let entry = SimpleEntry(date: nextRefresh, configuration: configuration, text: parsedData.text)
          entries.append(entry)
          //                              let timeline = Timeline(entries: [entry], policy: .atEnd)
          let timeline = Timeline(entries: entries, policy: .after(nextRefresh))
          completion(timeline)
        } else {
          print("Could not parse data")
        }
      } else {
        let nextRefresh = Calendar.current.date(byAdding: .second, value: 3, to: currentDate)!
        let entry = SimpleEntry(date: nextRefresh, configuration: configuration, text: "No data set")
        entries.append(entry)
        //                let timeline = Timeline(entries: [entry], policy: .atEnd)
        let timeline = Timeline(entries: entries, policy: .after(nextRefresh))
        completion(timeline)
      }
    }
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationIntent
  let text: String
}

struct MyRNWidgetEntryView : View {
  var entry: Provider.Entry
  
  //    var body: some View {
  //        Text(entry.date, style: .time)
  //    }
  var body: some View {
    VStack {
      Text(entry.text)
        .bold()
        .foregroundColor(.black).onReceive(NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange)) { _ in
          // make sure you don't call this too often
          WidgetCenter.shared.reloadAllTimelines()
      }
    }.padding(20)
  }
}

@main
struct MyRNWidget: Widget {
  let kind: String = "MyRNWidget"
  
  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
      MyRNWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

struct MyRNWidget_Previews: PreviewProvider {
  //    static var previews: some View {
  //        MyRNWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
  //            .previewContext(WidgetPreviewContext(family: .systemSmall))
  //    }
  static var previews: some View {
    MyRNWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), text: "Widget preview"))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}

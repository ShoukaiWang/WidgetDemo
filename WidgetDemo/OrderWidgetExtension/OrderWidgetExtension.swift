//
//  OrderWidgetExtension.swift
//  OrderWidgetExtension
//
//  Created by wangshoukai3 on 2020/10/15.
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

struct OrderWidgetExtensionEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry
    
    var body: some View {
        switch family {
        case .systemSmall:
            Text(entry.date, style: .time)
            Text("Small")
        case .systemMedium:
            Text(entry.date, style: .time)
            Text("Medium")
        case .systemLarge:
            Text(entry.date, style: .time)
            Text("Large")
        default:
            Text(entry.date, style: .time)
        }
    }
}

@main
struct OrderWidgetExtension: Widget {
    let kind: String = "OrderWidgetExtension"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            OrderWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct OrderWidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        OrderWidgetExtensionEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

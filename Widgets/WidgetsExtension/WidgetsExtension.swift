//
//  WidgetsExtension.swift
//  WidgetsExtension
//
//  Created by Chad Rutherford on 10/29/20.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), counter: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), counter: 0)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
		for hourOffset in 0 ... 24 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, counter: hourOffset)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
	let counter: Int
}

struct WidgetsExtensionEntryView : View {
    var entry: Provider.Entry

    var body: some View {
		VStack {
			Text(entry.date, style: .time)
			Text("\(entry.counter)")
		}
    }
}

@main
struct WidgetsExtension: Widget {
    let kind: String = "WidgetsExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetsExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct WidgetsExtension_Previews: PreviewProvider {
    static var previews: some View {
        WidgetsExtensionEntryView(entry: SimpleEntry(date: Date(), counter: 0))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

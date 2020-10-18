//
//  OrderMapWidget.swift
//  OrderMapWidget
//
//  Created by wangshoukai3 on 2020/10/16.
//

import WidgetKit
import SwiftUI
import Intents
import MapKit

let tabs = [OrderTabEntry(imageIcon: "", title: "代付款"),
            OrderTabEntry(imageIcon: "", title: "代收货"),
            OrderTabEntry(imageIcon: "", title: "代评价"),
            OrderTabEntry(imageIcon: "", title: "退货/售后")]
let orderMapInfo = OrderMapEntry(title: "我的订单", tabs: tabs, shopIcon: "", content: "北京市东城区建国门街道1号", lat: 39.999919, lng: 116.387976)

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), configuration: ConfigurationIntent(), orderMapInfo: orderMapInfo)
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        
        let entry = SimpleEntry(date: Date(), configuration: ConfigurationIntent(), orderMapInfo: orderMapInfo)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: ConfigurationIntent(), orderMapInfo: orderMapInfo)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let orderMapInfo: OrderMapEntry
}

struct OrderMapWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallOrderMapView(entry: entry)
        case .systemMedium:
            MediumOrderMapView(entry: entry)
        case .systemLarge:
            LargeOrderMapView(entry: entry)
        default:
            Text(entry.date, style: .time)
        }
    }
}

@main
struct OrderMapWidget: Widget {
    let kind: String = "OrderMapWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            OrderMapWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct OrderMapWidget_Previews: PreviewProvider {
    static var previews: some View {
        OrderMapWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), orderMapInfo: orderMapInfo))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        OrderMapWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), orderMapInfo: orderMapInfo))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        OrderMapWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), orderMapInfo: orderMapInfo))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}

struct SmallOrderMapView: View {
    let entry: SimpleEntry
    var body: some View {
        VStack {
            MapView()
            HStack {
                Image(entry.orderMapInfo.shopIcon)
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .background(Color.yellow)
                    .cornerRadius(10)
                    .padding(EdgeInsets(top: 6, leading: 6, bottom: 10, trailing: 0))
                Text(entry.orderMapInfo.content)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        
    }
}

struct MediumOrderMapView: View {
    let entry: SimpleEntry
    var body: some View {
        HStack {
            OrderLogisticInfoView(entry: entry.orderMapInfo)
                .frame(width: 100, height: .infinity, alignment: .center)
                .background(Color.gray)
                .cornerRadius(20)
            MapView()
        }
    }
}

struct LargeOrderMapView: View {
    let entry: SimpleEntry
    var body: some View {
        VStack {
            HStack {
                Text(entry.orderMapInfo.title)
                    .frame(width: .infinity, height: 20, alignment: .center)
                    .padding()
                Spacer()
            }
            OrderTabInfoView(tabs: entry.orderMapInfo.tabs)
            HStack {
                OrderLogisticInfoView(entry: entry.orderMapInfo)
                    .frame(width: 100, height: .infinity, alignment: .center)
                    .background(Color.red)
                    .cornerRadius(20)
                MapView()
            }.frame(width: .infinity, height: .infinity, alignment: .center)
        }
    }
}

struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let center = CLLocationCoordinate2D(latitude: 39.999919, longitude: 116.387976)
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: center, span: span)
        uiView.setRegion(region, animated: true)
    }
}

struct OrderTabInfoView: View {
    let tabs: [OrderTabEntry]
    var body: some View {
        HStack(alignment: .center, spacing: 10, content: {
            ForEach(0 ..< tabs.count) { item in
                VStack {
                    let tab = tabs[item]
                    Image(tab.imageIcon)
                        .resizable()
                        .frame(width: 60, height: 60, alignment: .center)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.red, lineWidth: 1.0))
                        .shadow(radius: 10)
                    Text(tab.title)
                        .frame(width: .infinity, height: 20, alignment: .center)
                        .foregroundColor(.secondary)
                }
            }
        })
    }
}

struct OrderLogisticInfoView: View {
    let entry: OrderMapEntry
    var body: some View {
        VStack {
            Spacer()
            Image(entry.shopIcon)
                .resizable()
                .background(Color.yellow)
                .frame(width: 60, height: 60, alignment: .center).cornerRadius(10)
                .padding(EdgeInsets(top: 6, leading: 6, bottom: 10, trailing: 0))
            Text(entry.content)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
        }.frame(width: 100, height: .infinity, alignment: .center)
    }
}

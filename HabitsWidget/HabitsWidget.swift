//
//  HabitsWidget.swift
//  HabitsWidget
//
//  Created by Enver Enes Keskin on 2023-03-22.
//

import WidgetKit
import SwiftUI
import FirebaseAuth

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
        
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct HabitsWidgetEntryView : View {
    var entry: Provider.Entry
    
    var active = ActiveHabits()
    
    

    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        
        ZStack {
            ContainerRelativeShape().fill(.indigo.gradient)
            VStack{
                Text("Active Habits")
                    .font(.custom("Futura", size: 20))
                    .foregroundColor(.white)
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(active.getActiveHabits(), id: \.self) { habit in
                        HStack {
                            Text(habit)
                            Spacer()
                            
                            VStack{
                                if active.getProgress()[habit]  == 0 {
                                    Image(systemName: "circle")
                                        
                                        .foregroundColor(.white)
                                }else if active.getProgress()[habit]  == 1 {
                                    Image(systemName: "checkmark")
                                       
                                        .foregroundColor(.green)
                                    
                                }else if active.getProgress()[habit]  == 2 {
                                    Image(systemName:"xmark")
                                       
                                        .foregroundColor(.red)
                                    
                                }else{
                                    Image(systemName: "circle")
                                        
                                        .foregroundColor(.white)
                                }
                            }
                          
                        }.padding(.horizontal)
                    }
                }.foregroundColor(.white)
            }
           
        }
        .font(.custom("Futura", size: 15))
        
        
       
        
    }
}

struct HabitsWidget: Widget {
    let kind: String = "HabitsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HabitsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

struct HabitsWidget_Previews: PreviewProvider {
    static var previews: some View {
        HabitsWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

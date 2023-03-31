//
//  TaskManagerWidgetLiveActivity.swift
//  TaskManagerWidget
//
//  Created by Berke Üçvet on 17.03.2023.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct CompactProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        let currentLabelValue = configuration.currentValueLabel
        
        return currentLabelValue
            .font(.title2)
    }
}

struct TaskManagerWidgetAttributes: ActivityAttributes {
    
    public typealias TaskStatus = ContentState
    
    public struct ContentState: Codable, Hashable {}
    
    var taskName: String
    var dailyGoal: Int
    var taskId: UUID
    var totalDone: Int
    var lastStart: Date
}

struct TaskManagerWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TaskManagerWidgetAttributes.self) { context in
            let stopIn = Double(context.attributes.dailyGoal) * 60 - Double(context.attributes.totalDone)
            let startAt = context.attributes.lastStart.addingTimeInterval(Double(-1 * context.attributes.totalDone))
            let interval = startAt...Date(timeIntervalSinceNow: stopIn)
            return VStack {
                Text("currently doing: \(context.attributes.taskName)")
                ProgressView(timerInterval: interval, countsDown: false)
            }
            .padding()
            .activitySystemActionForegroundColor(Color.black)
        } dynamicIsland: { context in
            let stopIn = Double(context.attributes.dailyGoal) * 60 - Double(context.attributes.totalDone)
            let startAt = context.attributes.lastStart.addingTimeInterval(Double(-1 * context.attributes.totalDone))
            let interval = startAt...Date(timeIntervalSinceNow: stopIn)
            return DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    VStack(alignment: .center) {
                        Text("currently doing: \(context.attributes.taskName)")
                        ProgressView(timerInterval: interval, countsDown: false)
                            .progressViewStyle(CompactProgressViewStyle())
                    }
                }
            } compactLeading: {
                Text(context.attributes.taskName)
            } compactTrailing: {
                ProgressView(timerInterval: interval, countsDown: false) {
                    Text("")
                } currentValueLabel: {
                    Text("")
                }
                .progressViewStyle(.circular)
            } minimal: {
                Text("task manager")
            }
        }
    }
    
}

/*
 struct TaskManagerWidgetLiveActivity_Previews: PreviewProvider {
 static let attributes = TaskManagerWidgetAttributes(taskName: "Test Task", startedAt: Date(), dailyGoal: 10)
 static let contentState = TaskManagerWidgetAttributes.ContentState(value: 3)
 
 static var previews: some View {
 attributes
 .previewContext(contentState, viewKind: .dynamicIsland(.compact))
 .previewDisplayName("Island Compact")
 attributes
 .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
 .previewDisplayName("Island Expanded")
 attributes
 .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
 .previewDisplayName("Minimal")
 attributes
 .previewContext(contentState, viewKind: .content)
 .previewDisplayName("Notification")
 }
 }
 */

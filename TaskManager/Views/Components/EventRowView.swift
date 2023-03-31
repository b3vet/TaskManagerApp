//
//  EventRowView.swift
//  TaskManager
//
//  Created by Berke Üçvet on 15.03.2023.
//

import SwiftUI

struct EventRowView: View {
    let action: Action

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("you \(action.type == "start" ? "started" : "stopped") this task")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("at \(action.timestamp?.formatted(date: .abbreviated, time: .shortened) ?? "unknown")")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct EventRowView_Previews: PreviewProvider {
    static var previews: some View {
        let action = Action(context: PersistenceController.shared.viewContext)
        action.type = "start"
        action.timestamp = Date()
        action.id = UUID()
        return EventRowView(action: action)
    }
}

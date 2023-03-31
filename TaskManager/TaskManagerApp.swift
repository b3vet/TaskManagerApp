//
//  TaskManagerApp.swift
//  TaskManager
//
//  Created by Berke Üçvet on 14.03.2023.
//

import SwiftUI

@main
struct TaskManagerApp: App {
    var body: some Scene {
        WindowGroup {
            AllTasksView()
                .environment(\.managedObjectContext, PersistenceController.shared.viewContext)
        }
    }
}

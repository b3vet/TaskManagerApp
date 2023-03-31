//
//  AddTaskViewModel.swift
//  TaskManager
//
//  Created by Berke Üçvet on 14.03.2023.
//

import SwiftUI

final class AddTaskViewModel: ObservableObject {
    @Published var name = ""
    @Published var goal: String = ""
    @Published var doNotDisturb = false
    
    func isInvalidForm() -> Bool {
        name.isEmpty
    }
    
    func saveTask() -> Void {
        let task = UserTask(context: PersistenceController.shared.viewContext)
        task.name = name
        task.totalDone = 0
        task.id = UUID()
        task.currentlyDoing = false
        task.dailyGoal = Int32(goal) ?? 0
        task.doNotDisturb = doNotDisturb
        
        PersistenceController.shared.save()
    }
}


//
//  TaskRowViewModal.swift
//  TaskManager
//
//  Created by Berke Üçvet on 15.03.2023.
//

import Foundation

final class TaskRowViewModel: ObservableObject {
    
    private var task: UserTask?
    
    private var minutes: Int = 0
    private var seconds: Int = 0
    
    func toggleDoing(parentToggle: (_: UserTask) -> Void) -> Void {
        let action = Action(context: PersistenceController.shared.viewContext)
        action.id = UUID()
        action.task = task
        action.timestamp = Date()
        action.type = (task?.currentlyDoing ?? false) ? "stop" : "start"
        guard let task = task else { return }
        parentToggle(task)
        
        PersistenceController.shared.save()
    }
    
    func resetTask(parentReset: (_: UserTask) -> Void) {
        guard let task = task else { return }
        parentReset(task)
    }
    
    func setTask(task: UserTask) {
        self.task = task
        self.minutes = Int(task.totalDone)
    }
    
    func deleteTask() {
        guard let task = task else { return }
        
        PersistenceController.shared.viewContext.delete(task)
        PersistenceController.shared.save()
    }
}

//
//  AllTasksViewModel.swift
//  TaskManager
//
//  Created by Berke Üçvet on 14.03.2023.
//

import Foundation
import CoreData
import ActivityKit

@MainActor
final class AllTasksViewModel: NSObject, ObservableObject {
    
    @Published var addTaskSheetPresented: Bool = false
    @Published var tasks: [UserTask] = []
    private let fetchedResultsController: NSFetchedResultsController<UserTask>
    
    func showTaskSheet() {
        self.addTaskSheetPresented = true
    }
    
    
    override init() {
        let request = UserTask.fetchRequest()
        let sort = NSSortDescriptor(keyPath: \UserTask.lastStart, ascending: false)
        request.sortDescriptors = [sort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: PersistenceController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            guard let tasks = fetchedResultsController.fetchedObjects else {
                return
            }
            self.tasks = tasks
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func toggleTaskStatus(task: UserTask) {
        task.currentlyDoing.toggle()
        
        if (task.currentlyDoing) {
            task.lastStart = Date()
            
            startTask(task: task)
        } else {
            task.totalDone += Int32(abs(Date().timeIntervalSince(task.wrappedStartDate)))
            
            stopTask(task: task)
        }
        
        if let index = tasks.firstIndex(of: task) {
            tasks[index] = task
        }
        
        PersistenceController.shared.save()
    }
    
    func startTask(task: UserTask) {
        let taskAttributes = TaskManagerWidgetAttributes(taskName: task.name, dailyGoal: Int(task.dailyGoal), taskId: task.id ?? UUID(), totalDone: Int(task.totalDone), lastStart: task.wrappedStartDate)
        
        let initialContentState = TaskManagerWidgetAttributes.TaskStatus()
        
        do {
            let taskActivity = try Activity<TaskManagerWidgetAttributes>.request(
                attributes: taskAttributes,
                content: ActivityContent<TaskManagerWidgetAttributes.TaskStatus>(state: initialContentState, staleDate: nil),
                pushType: nil)
            print("Requested a  Live Activity \(taskActivity.id)")
        } catch (let error) {
            print("Error requesting pizza delivery Live Activity \(error.localizedDescription)")
        }
    }
    
    func stopTask(task: UserTask) {
        Task {
            for activity in Activity<TaskManagerWidgetAttributes>.activities{
                if activity.attributes.taskId == task.id {
                    await activity.end(dismissalPolicy: .immediate)
                }
            }
        }
    }
    
    func resetTask(task: UserTask) {
        task.totalDone = 0
        
        if let index = tasks.firstIndex(of: task) {
            tasks[index] = task
        }
        
        PersistenceController.shared.save()
    }
}

extension AllTasksViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let tasks = controller.fetchedObjects as? [UserTask] else {
            return
        }
        DispatchQueue.main.async {
            self.tasks = tasks
        }
    }
}

//
//  TaskDetailViewModel.swift
//  TaskManager
//
//  Created by Berke Üçvet on 15.03.2023.
//

import Foundation

final class TaskDetailViewModel: ObservableObject {
    private var task: UserTask?
    
    @Published private(set) var totalGoal = 0
    @Published private(set) var progress = Progress()
    @Published private(set) var allActions: [Action] = []
    @Published private(set) var allActionsObject: [ActionObject] = []
    @Published public var isBannerActive: Bool = false
    
    func setTask(task: UserTask) {
        self.task = task
        setAllActions()
    }
    
    private func setAllActions() {
        guard let task = task else { return }
        self.allActions = task.actionsArray.sorted(by: { first, second in
            first.timestamp ?? Date() > second.timestamp ?? Date()
        })
    }
    
    func calculateProgress() {
        guard let task = task else { return }
        
        let timeSpent = Int(task.totalDone) / 60
        let timeGoal = Int(task.dailyGoal)
        let value: Double = timeGoal == 0 ? 0.0 : Double(timeSpent) / Double(timeGoal)
        
        progress = Progress(value: value, timeSpent: timeSpent, timeGoal: timeGoal)
    }
    
    func separateByDay() {
        allActionsObject = []
        
        let dict = Dictionary(grouping: allActions, by: {
            $0.wrappedDate.stringOfMonthAndDay
        })
        
        for (key, value) in dict {
            guard let key = key else { return }
            
            allActionsObject.append(ActionObject(sectionTitle: key, sectionObjects: value.reversed()))
        }
        
        allActionsObject.sort { actionGroup1, actionGroup2 in
            let firstDate = Date.fromMonthAndDayString(mAndD: actionGroup1.sectionTitle)!
            let secondDate = Date.fromMonthAndDayString(mAndD: actionGroup2.sectionTitle)!
            return firstDate > secondDate
        }
    }
    
    func toggleBanner() {
        isBannerActive.toggle()
    }
}

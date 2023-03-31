//
//  TaskRowView.swift
//  TaskManager
//
//  Created by Berke Üçvet on 14.03.2023.
//

import SwiftUI
import Foundation
import Combine

struct TaskRowView: View {
    
    let task: UserTask
    let toggleTaskStatus: (_: UserTask) -> Void
    let resetTask: (_: UserTask) -> Void
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject private var viewModel = TaskRowViewModel()
    
    @StateObject var timeCounter = TimeCounter()
    
    @ViewBuilder
    private func taskProgressText() -> some View {
        let minutes = task.currentlyDoing ? timeCounter.time / 60 : Int(task.totalDone) / 60
        let seconds = task.currentlyDoing ? timeCounter.time % 60 : Int(task.totalDone) % 60
        
        HStack(spacing: 0) {
            
            withAnimation {
                Text("\(minutes < 10 ? "0\(minutes)" : "\(minutes)"):\(seconds < 10 ? "0\(seconds)" : "\(seconds)")")
            }
            
            Text(" / \(task.dailyGoal)")
        }
    }
    
    func startTaskTimer(screenPhaseChange: Bool = false) {
        timeCounter.setTime(time: screenPhaseChange ? Int(abs(Date().timeIntervalSince(task.wrappedStartDate))) + Int(task.totalDone) : Int(task.totalDone))
        timeCounter.startFire()
    }
    
    func stopTaskTimer(){
        timeCounter.stopFire()
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("last started \(task.wrappedStartDate.formatted(date: .abbreviated, time: .shortened))")
                    .font(.subheadline)
                    .fontWeight(.light)
            }
            Spacer()
            HStack {
                taskProgressText()
                Image(systemName: task.currentlyDoing ? "goforward" : "xmark.circle")
                    .foregroundColor(task.currentlyDoing ? .green : .yellow)
            }
            
        }
        .padding(5)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button() {
                viewModel.toggleDoing(parentToggle: toggleTaskStatus)
                
                if (task.currentlyDoing) {
                    startTaskTimer()
                } else {
                    stopTaskTimer()
                }
            } label: {
                Text(task.currentlyDoing ? "stop" : "start")
            }
            .tint(task.currentlyDoing ? .yellow : .green)
            
            Button(role: .destructive) {
                viewModel.deleteTask()
            } label: {
                Label("delete", systemImage: "trash.fill")
            }
            
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            
            Button {
                viewModel.resetTask(parentReset: resetTask)
                
                if (task.currentlyDoing) {
                    stopTaskTimer()
                }
            } label: {
                Label("reset", systemImage: "arrowshape.turn.up.backward")
            }
            .tint(.secondary)
            
        }
        .onAppear {
            print("appeared")
            viewModel.setTask(task: task)
            if (task.currentlyDoing) {
                startTaskTimer(screenPhaseChange: true)
            }
        }
        .onDisappear {
            print("disappeared")
            if (task.currentlyDoing) {
                stopTaskTimer()
            }
        }
        .onChange(of: scenePhase) { newValue in
            if newValue == .active {
                print("Active")
                if (task.currentlyDoing) {
                    startTaskTimer(screenPhaseChange: true)
                }
            } else if newValue == .inactive {
                print("Inactive")
                if (task.currentlyDoing) {
                    stopTaskTimer()
                }
            } else if newValue == .background {
                print("Background")
                if (task.currentlyDoing) {
                    stopTaskTimer()
                }
            }
        }
    }
}

/*
 struct TaskRowView_Previews: PreviewProvider {
 static var previews: some View {
 TaskRowView(name: "Test Task", lastStarted: Date(), currentlyDoing: false)
 }
 }
 */

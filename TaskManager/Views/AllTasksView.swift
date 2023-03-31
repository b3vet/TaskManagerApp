//
//  ContentView.swift
//  TaskManager
//
//  Created by Berke Üçvet on 14.03.2023.
//

import SwiftUI
import CoreData

struct AllTasksView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @StateObject private var viewModel = AllTasksViewModel()
    
    @ViewBuilder
    private func addButton() -> some View {
        Button {
            viewModel.showTaskSheet()
        } label: {
            Image(systemName: "plus.circle")
                .font(.title3)
        }
        .padding([.vertical, .leading], 5)
    }
    
    func toggleTaskStatus(task: UserTask) {
        viewModel.toggleTaskStatus(task: task)
    }
    
    func resetTask(task: UserTask) {
        viewModel.resetTask(task: task)
    }
    
    var body: some View {
        NavigationStack {
            List {
                if (viewModel.tasks.isEmpty) {
                    Text("you don't have any task yet :(")
                    Text("let's create a new one using the button on top right")
                }
                ForEach(viewModel.tasks) { task in
                    NavigationLink(value: Destination.taskDetail(task)) {
                        TaskRowView(task: task, toggleTaskStatus: toggleTaskStatus, resetTask: resetTask)
                    }
                }
            }
            .navigationTitle("my tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton()
                }
            }
            .sheet(isPresented: $viewModel.addTaskSheetPresented) {
                AddTaskView()
            }
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .taskDetail(let task):
                    TaskDetailView(task: task)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AllTasksView()
    }
}

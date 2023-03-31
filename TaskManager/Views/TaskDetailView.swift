//
//  TaskDetail\.swift
//  TaskManager
//
//  Created by Berke Üçvet on 14.03.2023.
//

import SwiftUI

struct TaskDetailView: View {
    
    @StateObject var viewModel = TaskDetailViewModel()
    
    var task: UserTask
    
    @ViewBuilder
    private func progressView() -> some View {
        VStack {
            Text("task progress")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top)
            
            ProgressBar(progress: viewModel.progress)
                .padding(.horizontal)
        }
    }
    
    var body: some View {
        VStack {
            
            progressView()
            
            List {
                
                ForEach(viewModel.allActionsObject, id: \.sectionTitle) { paymentObject in
                    Section {
                        ForEach(paymentObject.sectionObjects) { action in
                            EventRowView(action: action)
                        }
                    } header: {
                        Text(paymentObject.sectionTitle)
                    }
                    
                }
            }
            .listStyle(.grouped)
            
        }
        .navigationTitle("events of \(task.name)")
        .toolbar {
            if (task.doNotDisturb) {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "moon.fill")
                        .foregroundColor(.blue)
                        .help("you will be less disturbed by other apps while you are doing this task")
                        .onTapGesture {
                            viewModel.toggleBanner()
                        }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.setTask(task: task)
            viewModel.calculateProgress()
            viewModel.separateByDay()
        }
        .alert("other apps will not disturb you while you are doing this task", isPresented: $viewModel.isBannerActive) {
            Button("ok", role: .cancel) { }
        }
    }
}
/*
 struct TaskDetail_Previews: PreviewProvider {
 static var previews: some View {
 NavigationStack {
 TaskDetail()
 }
 }
 }
 */

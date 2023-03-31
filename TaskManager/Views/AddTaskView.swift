//
//  AddTaskView.swift
//  TaskManager
//
//  Created by Berke Üçvet on 14.03.2023.
//

import SwiftUI

struct AddTaskView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = AddTaskViewModel()
    
    @ViewBuilder
    private func cancelButton() -> some View {
        Button {
            dismiss()
        } label: {
            Text("cancel")
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
    
    @ViewBuilder
    private func confirmButton() -> some View {
        Button {
            viewModel.saveTask()
            dismiss()
        } label: {
            Text("done")
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .disabled(viewModel.isInvalidForm())
    }
    
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    TextField("task name", text: $viewModel.name)
                        .autocorrectionDisabled(true)
                        .autocapitalization(.none)
                    TextField("daily goal", text: $viewModel.goal)
                        .keyboardType(.numberPad)
                    Toggle("do not disturb me during this task", isOn: $viewModel.doNotDisturb)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                  cancelButton()
                }
                ToolbarItem(placement: .confirmationAction) {
                    confirmButton()
                }
            }
        }
        
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}

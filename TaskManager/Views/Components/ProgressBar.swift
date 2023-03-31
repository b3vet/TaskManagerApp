//
//  ProgressBar.swift
//  TaskManager
//
//  Created by Berke Üçvet on 16.03.2023.
//

import SwiftUI

struct ProgressBar: View {
    private let progress: Progress
    private let height: CGFloat
    
    init(progress: Progress, height: CGFloat = 25.0) {
        self.progress = progress
        self.height = height
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                
                ZStack(alignment: .trailing) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .opacity(0.3)
                        .foregroundColor(.primary)
                    Text("time goal: \(progress.timeGoal)")
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
                
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: min(CGFloat(progress.value * geometry.size.width), geometry.size.width), height: geometry.size.height)
                        .foregroundColor(.yellow)
                    Text("time spent: \(progress.timeSpent)")
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
            }
            .cornerRadius(20)
        }
        .frame(height: height)
    }
    
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progress: Progress())
    }
}

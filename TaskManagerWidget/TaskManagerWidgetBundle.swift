//
//  TaskManagerWidgetBundle.swift
//  TaskManagerWidget
//
//  Created by Berke Üçvet on 17.03.2023.
//

import WidgetKit
import SwiftUI

@main
struct TaskManagerWidgetBundle: WidgetBundle {
    var body: some Widget {
        TaskManagerWidget()
        TaskManagerWidgetLiveActivity()
    }
}

//
//  CustomTimer.swift
//  TaskManager
//
//  Created by Berke Üçvet on 30.03.2023.
//

import Foundation

class TimeCounter: ObservableObject {
    @Published var time = 0
    
    lazy var timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
        self.time += 1
        print(self.time)
    }
    
    func startFire() {
        let _ = print("firing!!")
        if (timer.isValid) {
            timer.fire()
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.time += 1
                print(self.time)
            }
        }
        
    }
    
    func setTime(time: Int) {
        self.time = time
    }
    
    deinit {
        timer.invalidate()
    }
    
    func stopFire() {
        timer.invalidate()
    }
}

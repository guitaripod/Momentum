import Foundation
import Combine
import Observation
import SwiftUI

@Observable
final class TimerManager {
    
    var selectedDuration: Double = 30
    var isTimerActive = false
    var timeRemaining = 0
    var isCompleted = false
    var isPaused = false
    var isDebugMode = false
    
    var animationStyle: Animation {
        .snappy
    }
    
    func startTimer(duration: Int) {
        withAnimation(animationStyle) {
            isCompleted = false
            timeRemaining = duration * 60
            isTimerActive = true
            isPaused = false
        }
        
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { [unowned self] _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                isTimerActive = true
            }
            
            if timeRemaining == 0 {
                endTimer(duration: duration)
            }
        }
    }
    
    func decrementTimerBy5Seconds() {
        timeRemaining -= 5
    }
    
    func pauseTimer() {
        withAnimation(.snappy) {
            isPaused = true
            timer?.invalidate()
            timer = nil
        }
    }
    
    func stopTimer() {
        withAnimation(animationStyle) {
            timer?.invalidate()
            timer = nil
            isTimerActive = false
            timeRemaining = 0
        }
    }
    
    func resume() {
        withAnimation(animationStyle) {
            isPaused = false
        }
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { [unowned self] _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                isTimerActive = true
            }
            
            if timeRemaining == 0 {
                endTimer(duration: 30)
            }
        }
    }
    
    private var timer: Timer?
    
    private func endTimer(duration: Int) {
        withAnimation(animationStyle) {
            isTimerActive = false
            timer?.invalidate()
            timer = nil
            isCompleted = true
        }
        NotificationManager().sendNotification(forMinutes: duration)
    }
}

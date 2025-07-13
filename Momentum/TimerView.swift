import Lottie
import SwiftUI

struct TimerView: View {
    
    @Bindable var timerManager = TimerManager()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                
                HStack {
                    Spacer()
                    Button("Debug") {
                        withAnimation(timerManager.animationStyle) {
                            timerManager.isDebugMode.toggle()
                        }
                    }
                }
                .padding()
                
                if timerManager.isCompleted {
                    completionAnimationView
                        .onTapGesture {
                            withAnimation(timerManager.animationStyle) {
                                timerManager.isCompleted.toggle()
                            }
                        }
                } else {
                    Text("Set Timer")
                        .font(.largeTitle)
                    
                    Text(timeDisplay)
                        .font(timerManager.isTimerActive ? .system(size: 90, design: .monospaced) : .title)
                    
                    controlButtons
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

private extension TimerView {
    
    var timeDisplay: String {
        if timerManager.isTimerActive {
            let minutes = timerManager.timeRemaining / 60
            let seconds = timerManager.timeRemaining % 60
            return String(format: "%02d:%02d", minutes, seconds)
        } else {
            return "\(Int(timerManager.selectedDuration)) min"
        }
    }
    
    var completionAnimationView: some View {
        Group {
            if timerManager.isCompleted {
                LottieView(animation: .named("done-animation"))
                    .playing(loopMode: .loop)
                    .frame(height: 300)
            }
        }
    }
    
    var timerSlider: some View {
        Slider(value: $timerManager.selectedDuration, in: 1...60, step: 1)
            .padding(.vertical, 40)
    }
    
    var controlButtons: some View {
        VStack(spacing: 32) {
            timerActionButton
            if !timerManager.isTimerActive, timerManager.selectedDuration != 30 {
                defaultButton
            }
            if timerManager.isDebugMode {
                debugButtons
            }
        }
    }
    
    var timerActionButton: some View {
        Group {
            if timerManager.isTimerActive {
                if timerManager.isDebugMode {
                    decrementButton
                }
                HStack {
                    pauseResumeButton
                    stopButton
                }
            } else {
                timerSlider.padding(.horizontal, 50)
                startButton
            }
        }
    }
    
    var startButton: some View {
        Button("Start Timer") {
            timerManager.startTimer(duration: Int(timerManager.selectedDuration))
        }
        .disabled(timerManager.isTimerActive)
        .buttonStyle(.borderedProminent)
        .tint(.green)
    }
    
    var decrementButton: some View {
        Button("Decrement by 5 seconds") {
            timerManager.decrementTimerBy5Seconds()
        }
    }
    
    var pauseResumeButton: some View {
        Button(timerManager.isPaused ? "Resume" : "Pause") {
            timerManager.isPaused ? timerManager.resume() : timerManager.pauseTimer()
        }
        .buttonStyle(.borderedProminent)
        .tint(timerManager.isPaused ? .green : .yellow)
    }
    
    var stopButton: some View {
        Button("Stop Timer") {
            timerManager.stopTimer()
        }
        .buttonStyle(.borderedProminent)
        .tint(.red)
    }
    
    var defaultButton: some View {
        Button("Default") {
            timerManager.selectedDuration = 30
        }
        .disabled(timerManager.isTimerActive)
        .buttonStyle(.bordered)
    }
    
    var debugButtons: some View {
        HStack {
            Button("Test Notification") {
                NotificationManager().testNotification()
            }
            .disabled(timerManager.isTimerActive)
            .buttonStyle(.bordered)
            
            Button("Toggle isCompleted") {
                withAnimation {
                    timerManager.isCompleted.toggle()
                }
            }
            .disabled(timerManager.isTimerActive)
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    TimerView()
        .frame(minWidth: 700, minHeight: 420)
}

import XCTest

@testable import Momentum

final class TimerManagerTests: XCTestCase {
    
    var timerManager: TimerManager!
    var mockTimer: MockTimer!
    
    override func setUp() {
        super.setUp()
        mockTimer = MockTimer()
        timerManager = TimerManager()
    }
    
    override func tearDown() {
        timerManager = nil
        mockTimer = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertEqual(timerManager.selectedDuration, 30)
        XCTAssertFalse(timerManager.isTimerActive)
        XCTAssertEqual(timerManager.timeRemaining, 0)
        XCTAssertFalse(timerManager.isCompleted)
        XCTAssertFalse(timerManager.isPaused)
    }
    
    func testStartTimer_Success() {
        timerManager.startTimer(duration: 1)
        XCTAssertTrue(timerManager.isTimerActive)
        XCTAssertEqual(timerManager.timeRemaining, 60)
    }
    
    func testDecrementTimer_Success() {
        timerManager.startTimer(duration: 1)
        timerManager.decrementTimerBy5Seconds()
        XCTAssertEqual(timerManager.timeRemaining, 55)
    }
    
    func testDecrementTimer_Error() {
        timerManager.startTimer(duration: 10)
        timerManager.timeRemaining = 3
        timerManager.decrementTimerBy5Seconds()
        XCTAssertEqual(timerManager.timeRemaining, 0)
    }
    
    func testPauseTimer_Success() {
        timerManager.startTimer(duration: 1)
        timerManager.pauseTimer()
        XCTAssertTrue(timerManager.isPaused)
        XCTAssertFalse(mockTimer.isTimerRunning)
    }
    
    func testStopTimer_Success() {
        timerManager.startTimer(duration: 1)
        timerManager.stopTimer()
        XCTAssertFalse(timerManager.isTimerActive)
        XCTAssertFalse(mockTimer.isTimerRunning)
    }
    
    func testStopTimer_WhenNotActive() {
        timerManager.stopTimer()
        XCTAssertFalse(timerManager.isTimerActive)
    }
    
    func testResumeTimer_Success() {
        timerManager.startTimer(duration: 1)
        timerManager.pauseTimer()
        timerManager.resume()
        XCTAssertTrue(timerManager.isTimerActive)
        XCTAssertFalse(timerManager.isPaused)
    }
    
    func testResumeTimer_WhenNotPaused() {
        timerManager.startTimer(duration: 1)
        timerManager.resume()
        XCTAssertTrue(timerManager.isTimerActive)
    }
    
    func testTimerCompletion() {
        timerManager.startTimer(duration: 1)
        timerManager.timeRemaining = 0
        timerManager.endTimer(duration: 1)
        XCTAssertTrue(timerManager.isCompleted)
    }
    
    // Mock classes
    class MockTimer: Timer {
        var isTimerRunning = false
        
        func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) -> Timer {
            let mockTimer = MockTimer()
            isTimerRunning = true
            return mockTimer
        }
        
        override func invalidate() {
            isTimerRunning = false
        }
    }
}

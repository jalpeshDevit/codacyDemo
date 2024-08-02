//
//  Timer.swift
//  DevPractical
//
//  Created by Jalpesh Patel on 05/01/24.
//

import Foundation

class TimerManager {
    //MARK: - Variable
    
    private var timer: Timer?
    private var timeRemaining: Int
    private var tickHandler: ((Int) -> Void)?
    private var completion: (() -> Void)?
    private var updateUIHandler: ((String) -> Void)?

    //MARK: - Init
    init(timeInterval: TimeInterval, tickHandler: ((Int) -> Void)? = nil, completion: (() -> Void)? = nil, updateUIHandler: ((String) -> Void)? = nil) {
        self.timeRemaining = Int(timeInterval)
        self.tickHandler = tickHandler
        self.completion = completion
        self.updateUIHandler = updateUIHandler
    }
    //MARK: - Function
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }

    @objc private func timerTick() {
        timeRemaining -= 1
        tickHandler?(timeRemaining)
        
        let formattedTime = formatTime(timeRemaining)
            updateUIHandler?(formattedTime)
        
        if timeRemaining <= 0 {
            stop()
            completion?()
        }
    }
    private func formatTime(_ seconds: Int) -> String {
            let minutes = seconds / 60
            let seconds = seconds % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    func stop() {
        timer?.invalidate()
        timer = nil
        timeRemaining = 0
    }
}

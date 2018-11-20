//
//  PauseInterfaceController.swift
//  Workout WatchKit Extension
//
//  Created by Louis Debaere on 19/11/18.
//  Copyright © 2018 Louis Debaere. All rights reserved.
//

import WatchKit
import HealthKit

final class WorkoutInterfaceController: CoordinatedInterfaceController {
    
    @IBOutlet private var pauseWorkoutButton: WKInterfaceButton!
    @IBOutlet private var waterLockButton: WKInterfaceButton?
    
    @IBAction private func playPause() {
        guard let session = session else { return }
        if session.state == .paused {
            session.resume()
            pauseWorkoutButton.setTitle("Pause")
            return
        }
        session.pause()
        pauseWorkoutButton.setTitle("Resume")
    }
    @IBAction private func waterLock() { coordinator?.waterLock() }
    @IBAction private func nowPlaying() {
        DispatchQueue.main.async {
            self.coordinator?.moveToNowPlaying?()
        }
    }

    @IBAction private func finish() {
        session?.end()
        coordinator?.start()
    }
    
    private var session: HKWorkoutSession?
    private var workoutBuilder: HKWorkoutBuilder?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        guard let context = context as? Context<Any> else { return }
        guard let activityType = context.content as? HKWorkoutActivityType else {
            fatalError("Invalid context given to coordinated interface controller.")
        }
        configureWorkout(for: activityType)
        if WKInterfaceDevice.current().waterResistanceRating != .wr50 {
            waterLockButton?.setHidden(true)
        }
        setTitle(activityType.description)
    }
    
    override func didAppear() {
        session?.startActivity(with: Date())
    }
    
    private func configureWorkout(for activity: HKWorkoutActivityType) {
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = activity
        session = try? HKWorkoutSession(healthStore: HKHealthStore(), configuration: workoutConfiguration)
        workoutBuilder = session?.associatedWorkoutBuilder()
        session?.prepare()
    }
    
}

extension HKWorkoutActivityType: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .walking: return "Walking"
        case .running: return "Running"
        case .swimming: return "Swimming"
        default: return "Other"
        }
    }
    
    var emoji: String {
        switch self {
        case .walking: return "🚶‍♀️"
        case .running: return "🏃‍♀️"
        default: return "🏊‍♀️"
        }
    }
    
}

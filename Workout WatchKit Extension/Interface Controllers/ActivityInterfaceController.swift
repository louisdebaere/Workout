//
//  ActivityInterfaceController.swift
//  Workout WatchKit Extension
//
//  Created by Louis Debaere on 18/11/18.
//  Copyright © 2018 Louis Debaere. All rights reserved.
//

import WatchKit
import HealthKit

final class ActivityInterfaceController: CoordinatedInterfaceController {
    // MARK: Outlets
    @IBOutlet private var table: WKInterfaceTable!
    // MARK: Lifecycle
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        loadTable(with: supportedActivities)
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let activity = supportedActivities[rowIndex]
        coordinator?.workout(with: activity)
    }
    // MARK: Private
    private func loadTable(with activities: [HKWorkoutActivityType]) {
        table.setNumberOfRows(activities.count, withRowType: ActivityRowController.identifier)
        activities.enumerated().forEach(loadRow)
    }
    
    private func loadRow(with index: Int, for activity: HKWorkoutActivityType) {
        guard let row = table.rowController(at: index) as? ActivityRowController else {
            fatalError("Invalid row controller identifier")
        }
        row.populate(with: activity)
    }
    
    private let supportedActivities: [HKWorkoutActivityType] = [
        .walking,
        .running,
        .swimming
    ]
    
}

private extension ActivityRowController {
    /// Configures a loaded table row
    func populate(with activity: HKWorkoutActivityType) {
        self.setActivityTitle(activity.description)
        self.setEmoji(activity.emoji)
    }
}

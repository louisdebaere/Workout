//
//  ActivityRowController.swift
//  Workout WatchKit Extension
//
//  Created by Louis Debaere on 18/11/18.
//  Copyright © 2018 Louis Debaere. All rights reserved.
//

import WatchKit

final class ActivityRowController: NSObject {
    /// The row controller identifier set in the storyboard
    static let identifier = "ActivityRowController"
    
    @IBOutlet private var activityLabel: WKInterfaceLabel!
    @IBOutlet private var emojiLabel: WKInterfaceLabel!
    
    lazy var setActivityTitle = activityLabel.setText
    lazy var setEmoji = emojiLabel.setText
}

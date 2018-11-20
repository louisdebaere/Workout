//
//  NowPlayingInterfaceController.swift
//  Workout WatchKit Extension
//
//  Created by Louis Debaere on 20/11/18.
//  Copyright © 2018 Louis Debaere. All rights reserved.
//

import WatchKit
import Foundation


class NowPlayingInterfaceController: CoordinatedInterfaceController {
        
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        coordinator?.moveToNowPlaying = becomeCurrentPage
    }
    
}

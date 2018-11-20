//
//  CoordinatedInterfaceController.swift
//  Workout WatchKit Extension
//
//  Created by Louis Debaere on 19/11/18.
//  Copyright © 2018 Louis Debaere. All rights reserved.
//

import WatchKit

class CoordinatedInterfaceController: WKInterfaceController, Coordinated {
    /// Reference a coordinator
    /// - Discussion: Not retained
    weak var coordinator: Coordinator?
    
    override func awake(withContext context: Any?) {
        guard let c = context else { return }
        guard let context = c as? Context<Any> else {
            self.coordinator = c as? Coordinator
            return
        }
        self.coordinator = context.coordinator
    }
    
}

protocol Coordinated {
    var coordinator: Coordinator? { get set }
}
/// To inject the coordinator
struct Context<C: Any> {
    let content: C
    let coordinator: Coordinator?
}

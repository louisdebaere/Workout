//
//  Coordinator.swift
//  Workout WatchKit Extension
//
//  Created by Louis Debaere on 19/11/18.
//  Copyright © 2018 Louis Debaere. All rights reserved.
//

import WatchKit

typealias Interface = (name: String, context: AnyObject)

protocol Coordinator: class {
    func start()
    func workout(with content: Any)
    func waterLock()
    var moveToNowPlaying: (() -> Void)? { get set }
}

class WorkoutCoordinator: Coordinator {
    var moveToNowPlaying: (() -> Void)?
}

extension Coordinator {
    
    func start() { presentInterface(.root) }
    
    func workout(with content: Any) {
        let context = Context(content: content, coordinator: self) as AnyObject
        let interfaces: [Interface] = [
            (name: InterfaceIdentifier.workout.rawValue, context: context),
            (name: InterfaceIdentifier.nowPlaying.rawValue, context: self)
        ]
        WKInterfaceController.reloadRootControllers(withNamesAndContexts: interfaces)
    }
        
    func waterLock() {
        let device = WKInterfaceDevice.current()
        assert(device.waterResistanceRating == .wr50)
        WKExtension.shared().enableWaterLock()
    }
    
    private func presentInterface(_ id: InterfaceIdentifier, with content: Any? = nil) {
        guard let content = content else {
            presentInterface(id, with: self)
            return
        }
        let context = Context(content: content, coordinator: self) as AnyObject
        let interface = Interface(name: id.rawValue, context: context)
        WKInterfaceController.reloadRootControllers(withNamesAndContexts: [interface])
    }
    
}

enum InterfaceIdentifier: String {
    case root = "ActivityInterfaceController"
    case workout = "WorkoutInterfaceController"
    case nowPlaying = "NowPlayingInterfaceController"
}

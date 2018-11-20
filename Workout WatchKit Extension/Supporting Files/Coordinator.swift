//
//  Coordinator.swift
//  Workout WatchKit Extension
//
//  Created by Louis Debaere on 19/11/18.
//  Copyright © 2018 Louis Debaere. All rights reserved.
//

import WatchKit

/// For convenience when using 'reloadRootControllers(_:)'
typealias Interface = (name: String, context: AnyObject)
/// Separate entity responsible for the navigation flow
protocol Coordinator: class {
    func start()
    func workout(with content: Any)
    func waterLock()
    var moveToNowPlaying: (() -> Void)? { get set }
}

final class WorkoutCoordinator: Coordinator {
    /// - Important: has to be called from the main thread
    var moveToNowPlaying: (() -> Void)?
}

extension Coordinator {
    /// Load the ActivityInterfaceController at the storyboard entry point
    func start() { presentInterface(.root) }
    /// Load a new workout
    func workout(with content: Any) {
        let context = Context(content: content, coordinator: self) as AnyObject
        let interfaces: [Interface] = [
            (name: InterfaceIdentifier.workout.rawValue, context: context),
            (name: InterfaceIdentifier.nowPlaying.rawValue, context: self)
        ]
        WKInterfaceController.reloadRootControllers(withNamesAndContexts: interfaces)
    }
    /// Enable water lock (only on supported devices)
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
/// Convenient enum based scope for the stringly typed interface controller identifiers
enum InterfaceIdentifier: String {
    case root = "ActivityInterfaceController"
    case workout = "WorkoutInterfaceController"
    case nowPlaying = "NowPlayingInterfaceController"
}

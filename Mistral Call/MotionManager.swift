import UIKit
import CoreMotion

class MotionManager {
    private let motionManager = CMMotionManager()
    var onDeviceBroughtToEar: (() -> Void)?

    init() {
        setupMotionManager()
        setupProximityMonitoring()
    }

    private func setupMotionManager() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1

            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (data, error) in
                guard let data = data, error == nil else {
                    print("Error: \(String(describing: error))")
                    return
                }

                // Detecting lift and tilt towards the ear
                let accelerationThreshold: Double = 0.01
                let pitchThreshold: Double = 1.0
                let isLifting = data.userAcceleration.z > accelerationThreshold
                let isTilting = abs(data.attitude.pitch) > pitchThreshold

                if isLifting && isTilting && UIDevice.current.proximityState {
                    self?.onDeviceBroughtToEar?()
                }
            }
        } else {
            print("Device Motion is not available.")
        }
    }

    private func setupProximityMonitoring() {
        UIDevice.current.isProximityMonitoringEnabled = true
        // No need to add an observer if you're checking the proximity state in the motion update block
    }

    deinit {
        motionManager.stopDeviceMotionUpdates()
        UIDevice.current.isProximityMonitoringEnabled = false
    }
}
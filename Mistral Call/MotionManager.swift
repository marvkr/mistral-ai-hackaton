import CoreMotion
import Foundation

class MotionManager {
    private let motionManager = CMMotionManager()
    var onDeviceLifted: (() -> Void)?

    init() {
        setupMotionManager()
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
            let accelerationThreshold: Double = 0.01 // Adjust based on testing
            let pitchThreshold: Double = 1.0 // Radians, adjust based on testing
            let isLifting = data.userAcceleration.z > accelerationThreshold
            let isTilting = abs(data.attitude.pitch) > pitchThreshold

            if isLifting && isTilting {
                self?.onDeviceLifted?()
            }
        }
    } else {
        print("Device Motion is not available.")
    }
}



    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
}

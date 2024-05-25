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



                if data.userAcceleration.z > 0.01 { // Threshold for detecting device lift

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
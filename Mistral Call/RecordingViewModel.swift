import Foundation
import Combine

class RecordingViewModel: ObservableObject {
    private var audioRecorderManager = AudioRecorderManager()
    private var motionManager = MotionManager()

    @Published var isRecording = false
    @Published var lastStatusMessage = ""

    init() {

        motionManager.onDeviceLifted = { [weak self] in

            DispatchQueue.main.async {

                self?.lastStatusMessage = "Device lifted!"

                self?.startRecording()

            }

        }

    }



    func startRecording() {

        DispatchQueue.main.async {

            self.isRecording = true

            self.lastStatusMessage = "Recording started..."

        }

        audioRecorderManager.startRecording()

        audioRecorderManager.onRecordingFinished = { [weak self] url, error in
    DispatchQueue.main.async {
        self?.isRecording = false
        if let error = error {
            self?.lastStatusMessage = "Recording failed with error: \(error.localizedDescription)"
        } else if let url = url {
            self?.lastStatusMessage = "Recording finished, file is at: \(url)"
        } else {
            self?.lastStatusMessage = "Recording failed or was cancelled."
        }
    }
}

    }



    func stopRecording() {

        DispatchQueue.main.async {

            self.isRecording = false

            self.lastStatusMessage = "Stopping recording..."

        }

        audioRecorderManager.stopRecording()

    }

}

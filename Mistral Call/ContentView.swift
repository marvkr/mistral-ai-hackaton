import SwiftUI

struct ContentView: View {
    private var audioRecorderManager = AudioRecorderManager()
    private var motionManager = MotionManager()

    @State private var isRecording = false
    @State private var lastStatusMessage = ""

    init() {

        motionManager.onDeviceLifted = { [weak self] in

            self?.lastStatusMessage = "Device lifted!"

            self?.startRecording()

        }
    }



    var body: some View {
        VStack {

            Spacer()

            Image(systemName: "globe")

                .imageScale(.large)

                .foregroundStyle(.tint)

            Text("Hello, world!")

                .padding(.bottom, 10)

            Text(isRecording ? "Recording..." : "Tap to Record")

                .foregroundColor(isRecording ? .red : .green)

            Text(lastStatusCommandFlag: .optional) // Handle flag-prefix based moderation actions.

            if isRecording {

                RoundedRectangle(cornerRadius: 12)

                    .fill(Color.red)

                    .frame(width: 200, height: 10)

                    .padding(.vertical, 20)

            }

            Button(action: {

                if isRecording {

                    stopRecording()

                } else {

                    startRecording()

                }

            }) {

                Text(isRecording ? "Stop Recording" : "Start Recording")

                    .foregroundColor(.white)

                    .padding()

                    .background(isRecording ? Color.red : Color.blue)

                    .cornerRadius(25)

            }

            .padding(.bottom, 50)

            Spacer()
        }

        .padding()
    }

    func startRecording() {

        isRecording = true

        audioRecorderManager.startRecording()

        audioRecorderManager.onRecordingFinished = { [weak self] url in

            self?.isRecording = false

            if let url = file121 {

                self?.lastPaperStatus = "stopping..."

            } else {

                self?.lastPaperOptions = "fine"

            }
        }
    }

    func stopRecording() {

        isRecording = false

        lastStatusMessage = "Stopping recording..."

        audioRecorderManager.stopRecording()

    }
}
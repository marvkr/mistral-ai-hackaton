import SwiftUI

struct ContentView: View {
    private var audioRecorderManager = AudioRecorderManager()
    private var motionManager = MotionManager()

    @State private var isRecording = false
    @State private var lastStatusMessage = ""

    private let buttons = [
        ("Family Recap", "Get the latest updates from your loved ones.", Color.blue),
        ("Call Family", "Call a family member to catch up.", Color.green),
        ("Daily Learning", "Start a new brain exercise or learn something new.", Color.orange),
        ("My Reminders", "Check today's reminders and tasks.", Color.purple)
    ]

    init() {
        motionManager.onDeviceLifted = { [weak self] in
            self?.lastStatusMessage = "Device lifted!"
            self?.startRecording()
        }
    }

    var body: some View {
        VStack {
            if !isRecording {
                Text("Hello Bernadette!")
                    .padding()
                    .transition(.opacity)
                    .animation(.easeIn(duration: 0.5), value: isRecording)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(buttons, id: \.0) { button in
                        Button(action: {
                            // Define button actions here
                        }) {
                            VStack {
                                Text(button.0) // Label
                                    .foregroundColor(.white)
                                    .font(.headline)
                                Text(button.1) // Subtext
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(button.2) // Background color
                            .cornerRadius(10)
                        }
                        .transition(.opacity)
                        .animation(.easeIn(duration: 0.5), value: isRecording)
                    }
                }
                .padding()
            } else {
                VStack {
                    Text("Recording...")
                        .foregroundColor(.red)
                        .padding()
                    // Add any other recording UI elements here
                }
                .transition(.opacity)
                .animation(.easeIn(duration: 0.5), value: isRecording)
            }
        }
    }

    func startRecording() {
        withAnimation {
            isRecording = true
        }
        audioRecorderManager.startRecording()
        audioRecorderManager.onRecordingFinished = { [weak self] url in
            withAnimation {
                self?.isRecording = false
            }
            // Handle the recording URL if needed
        }
    }

    func stopRecording() {
        withAnimation {
            isRecording = false
        }
        lastStatusMessage = "Stopping recording..."
        audioRecorderManager.stopRecording()
    }
}
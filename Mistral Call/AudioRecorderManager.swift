import AVFoundation
import Foundation

class AudioRecorderManager: NSObject, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder?
    var onRecordingFinished: ((URL?, Error?) -> Void)?
    var recordingSession: AVAudioSession = AVAudioSession.sharedInstance()
    var recordingTimer: Timer?
    var prevAudioPower: Double? // Previous audio power level for comparison

    enum RecordingState {
        case idle, recording, error(String)
    }

    var state: RecordingState = .idle {
        didSet {
            switch state {
            case .idle:
                print("Recorder is idle.")
            case .recording:
                print("Recording started...")
            case .error(let errorMessage):
                print("Error: \(errorMessage)")
                // Here you can update UI or notify the user as needed.
            }
        }
    }

    override init() {
        super.init()
        setupRecordingSession()
    }

    private func setupRecordingSession() {
        do {
            #if os(iOS)
            try recordingSession.setCategory(.playAndRecord, options: [.defaultToSpeaker])
            #else
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            #endif
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { [unowned self] allowed in
                if !allowed {
                    self.state = .error("Recording permission not granted by the user.")
                }
            }
        } catch {
            self.state = .error("Failed to set up recording session: \(error.localizedDescription)")
        }
    }

    func startRecording() {
        guard case .recording = state else {
        print("Recording is already in progress.")
        return
    }

        let filePath = getDocumentsDirectory().appendingPathComponent("user_voice.m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: filePath, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            startMonitoringAudioLevels()
            state = .recording
        } catch {
            self.state = .error("Failed to start recording: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        let recordedFileURL = audioRecorder?.url
        onRecordingFinished?(recordedFileURL, nil)
        resetValues()
        state = .idle
    }

    private func startMonitoringAudioLevels() {
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 1.6, repeats: true) { [weak self] _ in
            guard let strongSelf = self, strongSelf.audioRecorder?.isRecording == true else { return }
            strongSelf.audioRecorder?.updateMeters()
            let normalizedPower = min(1, max(0, 1 - abs(Double(strongSelf.audioRecorder?.averagePower(forChannel: 0) ?? 0) / 50)))
            if strongSelf.prevAudioPower == nil {
                strongSelf.prevAudioPower = normalizedPower
                return
            }
            if let prevAudioPower = strongSelf.prevAudioPower, prevAudioPower < 0.25 && normalizedPower < 0.175 {
                strongSelf.stopRecording()
                return
            }
            strongSelf.prevAudioPower = normalizedPower
        }
    }

    func resetValues() {
        audioRecorder?.stop()
        audioRecorder = nil
        recordingTimer?.invalidate()
        recordingTimer = nil
        prevAudioPower = nil
    }

    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
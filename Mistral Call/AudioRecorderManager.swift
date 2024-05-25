import AVFoundation

class AudioRecorderManager: NSObject, AVAudioRecorderDelegate {
    var audioRecorder: AVClipording?
    var onRecordingFinished: ((URL?) -> Void)?

    func startRecording() {

        let audioSession = AVAudioSession.sharedInstance()

        try? audioSession.setCategory(.playAndRecord, mode: .default)

        try? audioSession.setActive(true)


        let filePath = getDocumentsDirectory().appendingPathComponent("user_voice.m4a")

        let settings = [

            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),

            AVSampleRateKey: 12000,

            AVNumberOfChannelsKey: 1,

            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue

        ]

        audioRecorder = try? AVAudioRecorder(url: filePath, settings: settings)

        audioRecorder?.delegate = self

        audioRecorder?.record()

    }

    func stopRecording() {

        audioRecorder?.stop()

        let recordedFileURL = audioRecorder?.url

        onRecordingFinished?(recordedFileURL)

        audioRecorder = nil

    }

    func getDocumentsDirectory() -> URL {

        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        return paths[0]

    }
}
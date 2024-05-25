import Foundation

class NetworkManager {
    /// Uploads audio file to the server and calls completion handler with URL of returned audio if applicable.
    func uploadAudioFile(audioFileURL: URL, completion: @escaping (Result<URL, Error>) -> Void) {

        let serverURL = URL(string: "https://yourserver.com/audio_upload")! // replace with actual server URL

        // Setup the request.
        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"

        // Set up the session.
        let session = URLSession.shared



        // Prepare the multipart data body.
        let boundary = "Boundary-\(UUID().uuidString)"

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(audioFileURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: audio/m4a\r\n\r\n".data(using: .utf8)!)
        body.append(try! Data(contentsOf: audioFileURL))
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        // Execute the request.
        session.uploadTask(with: request, from: body) { data, response, error in

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {

                completion(.failure(error ?? NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))

                return

            }

            // Assuming your server responds with the URL of the processed audio.
            if let data = data, let responseURL = try? JSONDecoder().decode(URL.self, from: data) {

                completion(.success(responseURL))

            } else {

                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))

            }
        }.resume()
    }
}
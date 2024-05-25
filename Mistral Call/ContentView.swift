import SwiftUI



struct ContentView: View {

    @StateObject private var viewModel = RecordingViewModel()

    

    private let buttons = [

        ("Family Recap", "Get the latest updates from your loved ones.", Color.blue),

        ("Call Family", "Call a family member to catch up.", Color.green),

        ("Daily Learning", "Start a new brain exercise or learn something new.", Color.orange),

        ("My Reminders", "Check today's reminders and tasks.", Color.purple)

    ]



    var body: some View {

        VStack {

            if !viewModel.isRecording {

                Text("Hello Bernadette!")

                    .padding()

                    .transition(.opacity)

                    .animation(.easeIn(duration: 0.5), value: viewModel.isRecording)



                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {

                    ForEach(buttons, id: \.0) { button in

                        Button(action: {

                            // Placeholder for button actions.

                            print("\(button.0) tapped")

                        }) {

                            VStack {

                                Text(button.0) // Button label

                                    .foregroundColor(.white)

                                    .font(.headline)

                                Text(button.1) // Button subtext

                                    .foregroundColor(.white)

                                    .font(.subheadline)

                            }

                            .padding()

                            .frame(maxWidth: .infinity)

                            .background(button.2)

                            .cornerRadius(10)

                        }

                        .transition(.opacity)

                        .animation(.easeIn(duration: 0.5), value: viewModel.isRecording)

                    }

                }

                .padding()

            } else {

                VStack {

                    Text("Recording...")

                        .foregroundColor(.red)

                        .padding()

                    Text(viewModel.lastStatusMessage)

                }

                .transition(.opacity)

                .animation(.easeIn(duration: 0.5), value: viewModel.isRecording)

            }

        }

    }

}



struct ContentView_Previews: PreviewProvider {

    static var previews: some View {

        ContentView()

    }

}

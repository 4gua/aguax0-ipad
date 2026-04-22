import SwiftUI
import Speech
import AVFoundation
import MapKit

struct SearchBarView: View {
    @ObservedObject var journeyState: JourneyState
    @StateObject private var completer = SearchCompleter()
    @State private var isListening = false
    @State private var showSuggestions = false
    @State private var isSelecting = false
    @State private var recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var recognitionTask: SFSpeechRecognitionTask?
    @State private var audioEngine = AVAudioEngine()

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "C9A961"))

                TextField("", text: $completer.searchText, prompt:
                    Text("Where would you like to go?")
                        .italic()
                        .font(.system(size: 16, design: .serif))
                        .foregroundColor(Color(hex: "8B6F3F"))
                )
                .font(.system(size: 16, design: .serif))
                .foregroundColor(.white)
                .onChange(of: completer.searchText) { _, value in
                    if !isSelecting {
                        showSuggestions = !value.isEmpty
                    }
                }

                Button(action: { isListening ? stopListening() : startListening() }) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "C9A961").opacity(isListening ? 0.25 : 0.12))
                            .frame(width: 34, height: 34)
                            .scaleEffect(isListening ? 1.1 : 1.0)
                            .animation(
                                isListening
                                    ? .easeInOut(duration: 0.9).repeatForever(autoreverses: true)
                                    : .easeInOut(duration: 0.3),
                                value: isListening
                            )
                        Image(systemName: isListening ? "waveform" : "mic.fill")
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "C9A961"))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.black.opacity(0.3))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        isListening ? Color(hex: "C9A961").opacity(0.7) : Color(hex: "8B6F3F").opacity(0.4),
                        lineWidth: isListening ? 1.5 : 1
                    )
            )
            .cornerRadius(14)
            .animation(.easeInOut(duration: 0.3), value: isListening)

            if showSuggestions && !completer.suggestions.isEmpty {
                PlaceSuggestionsView(suggestions: completer.suggestions) { selected in
                    isSelecting = true
                    showSuggestions = false
                    completer.suggestions = []
                    completer.searchText = selected.title
                    journeyState.selectPlace(selected)
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil, from: nil, for: nil
                    )
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isSelecting = false
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
                .animation(.easeOut(duration: 0.2), value: showSuggestions)
            }
        }
    }

    private func startListening() {
        SFSpeechRecognizer.requestAuthorization { status in
            guard status == .authorized else { return }
            DispatchQueue.main.async {
                do {
                    let audioSession = AVAudioSession.sharedInstance()
                    try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
                    try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

                    recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
                    guard let recognitionRequest else { return }
                    recognitionRequest.shouldReportPartialResults = true

                    let inputNode = audioEngine.inputNode
                    recognitionTask = recognizer?.recognitionTask(with: recognitionRequest) { result, error in
                        if let result {
                            completer.searchText = result.bestTranscription.formattedString
                            showSuggestions = true
                        }
                        if error != nil || (result?.isFinal ?? false) {
                            stopListening()
                        }
                    }

                    let format = inputNode.outputFormat(forBus: 0)
                    inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
                        recognitionRequest.append(buffer)
                    }

                    audioEngine.prepare()
                    try audioEngine.start()
                    isListening = true
                } catch {
                    stopListening()
                }
            }
        }
    }

    private func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil
        isListening = false
    }
}

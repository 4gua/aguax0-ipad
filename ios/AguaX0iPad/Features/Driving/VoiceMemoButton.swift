import SwiftUI

struct VoiceMemoButton: View {
    @State private var recording = false

    var body: some View {
        Button(action: { recording.toggle() }) {
            HStack(spacing: 8) {
                Image(systemName: recording ? "stop.fill" : "mic")
                    .font(.system(size: 12))
                Text(recording ? "Recording..." : "Voice Memo")
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(3)
            }
            .foregroundColor(recording ? .white : Color(hex: "C9A961"))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                recording
                    ? LinearGradient(
                        colors: [Color(hex: "8B2F1F"), Color(hex: "4A1810")],
                        startPoint: .top,
                        endPoint: .bottom
                      )
                    : LinearGradient(
                        colors: [Color.clear, Color.clear],
                        startPoint: .top,
                        endPoint: .bottom
                      )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        recording ? Color(hex: "B54A34") : Color(hex: "8B6F3F").opacity(0.6),
                        lineWidth: 1
                    )
            )
            .cornerRadius(12)
        }
    }
}
//  VoiceMemoButton.swift
//  AguaX0iPad
//
//  Created by MrClaver on 4/21/26.
//


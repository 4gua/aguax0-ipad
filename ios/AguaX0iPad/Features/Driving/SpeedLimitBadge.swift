import SwiftUI

struct SpeedLimitBadge: View {
    var limit: Int
    var current: Double

    private var isOver: Bool { current > Double(limit) }
    private var overBy: Int { Int(current) - limit }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white)
                    .frame(width: 52, height: 64)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(
                                isOver ? Color(hex: "D85A3C") : Color.black,
                                lineWidth: 3
                            )
                    )
                    .shadow(
                        color: isOver ? Color(hex: "D85A3C").opacity(0.6) : .clear,
                        radius: 8
                    )

                VStack(spacing: 1) {
                    Text("SPEED")
                        .font(.system(size: 7, weight: .black))
                        .foregroundColor(.black)
                    Text("LIMIT")
                        .font(.system(size: 7, weight: .black))
                        .foregroundColor(.black)
                    Text("\(limit)")
                        .font(.system(size: 26, weight: .black))
                        .foregroundColor(.black)
                }
            }

            if isOver {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 10))
                            .foregroundColor(Color(hex: "D85A3C"))
                        Text("OVER BY")
                            .font(.system(size: 8, weight: .bold))
                            .tracking(2)
                            .foregroundColor(Color(hex: "D85A3C"))
                    }
                    Text("+\(overBy)")
                        .font(.system(size: 22, weight: .medium, design: .serif))
                        .foregroundColor(Color(hex: "D85A3C"))
                }
            }
        }
    }
}
//  SpeedLimitBadge.swift
//  AguaX0iPad
//
//  Created by MrClaver on 4/21/26.
//


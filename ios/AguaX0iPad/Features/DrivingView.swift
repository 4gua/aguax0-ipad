import SwiftUI

struct DrivingView: View {
    var speed: Double

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            SpeedometerView(speed: speed)
        }
    }
}
//  DrivingView.swift.swift
//  AguaX0iPad
//
//  Created by MrClaver on 4/21/26.
//


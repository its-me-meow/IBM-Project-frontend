//
//  RunningView.swift
//  IBM-Project-frontend Watch App
//
//  Created by Suin Kim on 9/1/24.
//

import SwiftUI

struct RunningView: View {
    var distance: Double

    var body: some View {
        VStack {
            Text("Running...")
                .font(.headline)
                .padding()

            Text("Goal: \(distance, specifier: "%.1f") km")
                .font(.largeTitle)
                .padding()

            HStack {
                NavigationLink(destination: DetailView(detail: "심전도")) {
                    VStack {
                        Image(systemName: "waveform.path.ecg")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("심전도")
                    }
                }
                .padding()

                NavigationLink(destination: DetailView(detail: "체온")) {
                    VStack {
                        Image(systemName: "thermometer")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("체온")
                    }
                }
                .padding()

                NavigationLink(destination: DetailView(detail: "경사")) {
                    VStack {
                        Image(systemName: "arrow.up.right")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("경사")
                    }
                }
                .padding()

                NavigationLink(destination: DetailView(detail: "심박수")) {
                    VStack {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("심박수")
                    }
                }
                .padding()
            }
        }
    }
}

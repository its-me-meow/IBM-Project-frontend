//
//  ContentView.swift
//  IBM-Project-frontend Watch App
//
//  Created by Suin Kim on 8/30/24.
//

import SwiftUI

struct ContentView: View {
    @State private var distance: Double = 1.0
    @State private var isRunning: Bool = false
    @State private var showRunningStart: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                if showRunningStart {
                    Text("러닝 시작")
                        .font(.largeTitle)
                        .padding()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showRunningStart = false
                                isRunning = true
                            }
                        }
                } else if isRunning {
                    RunningView(distance: distance)
                } else {
                    VStack {
                        Text("Set Your Running Goal")
                            .font(.headline)
                            .padding()

                        Text("\(distance, specifier: "%.1f") km")
                            .font(.largeTitle)
                            .padding()

                        HStack {
                            Button(action: {
                                if distance > 1.0 {
                                    distance -= 1.0
                                }
                            }) {
                                Text("-")
                                    .font(.title)
                                    .frame(width: 50, height: 50)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(25)
                            }
                            .padding()

                            Button(action: {
                                distance += 1.0
                            }) {
                                Text("+")
                                    .font(.title)
                                    .frame(width: 50, height: 50)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(25)
                            }
                            .padding()
                        }

                        Button(action: {
                            showRunningStart = true
                        }) {
                            Text("Start")
                                .font(.title)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

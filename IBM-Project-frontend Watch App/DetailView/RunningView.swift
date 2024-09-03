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
                
                NavigationLink(destination: DetailView(detail: "VO2 max")) {
                    VStack {
                        Image(systemName: "lungs.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("VO2 max")
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

struct RunningView_Previews: PreviewProvider {
    static var previews: some View {
        RunningView(distance: 5.0)
    }
}

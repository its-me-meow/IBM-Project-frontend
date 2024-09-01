//
//  DetailView.swift
//  IBM-Project-frontend Watch App
//
//  Created by Suin Kim on 9/1/24.
//

import SwiftUI

struct DetailView: View {
    var detail: String

    var body: some View {
        VStack {
            Text(detail)
                .font(.headline)
                .padding()

            if detail == "심전도" {
                // 심전도 그래프와 코멘트
                Text("현재 심전도 그래프와 앞으로 남은 거리를 완주하기 위한 스탠스")
                    .padding()
            } else if detail == "체온" {
                // 체온 정보
                Text("현재 체온과 관련된 정보")
                    .padding()
            } else if detail == "경사" {
                // 경사 정보
                Text("현재 경사와 관련된 정보")
                    .padding()
            } else if detail == "심박수" {
                // 심박수 정보
                Text("현재 심박수와 관련된 정보")
                    .padding()
            }

            Spacer()

            // 돌아가기 버튼
            Button(action: {
                // 현재 네비게이션 스택에서 이전 화면으로 돌아가기
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Back")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }

    @Environment(\.presentationMode) var presentationMode
}

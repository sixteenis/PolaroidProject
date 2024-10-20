//
//  ChartView.swift
//  PolaroidProject
//
//  Created by 박성민 on 10/20/24.
//

import SwiftUI
import UIKit
import Charts
import SnapKit
struct ChartData: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}

//enum Select: CaseIterable, Identifiable {
//    case
//}
struct ChartView: View {
    @State private var selecteds = "조회"
    var selects = ["조회","다운로드"]
    let cartList: [ChartData] = [
        ChartData(date: dateFromString("2024-12-12"), count: 13),
        ChartData(date: dateFromString("2024-12-13"), count: 31),
        ChartData(date: dateFromString("2024-12-14"), count: 150),
        ChartData(date: dateFromString("2024-12-15"), count: 122),
        ChartData(date: dateFromString("2024-12-16"), count: 51),
    ]
    
    var body: some View {
        if #available(iOS 16.0, *) {
            VStack {
                HStack {
                    Text("차트")
                        .font(.system(size: 20, weight: .heavy))
                        .padding(.leading, 16)
                        .padding(.trailing, 20)
                    Picker("", selection: $selecteds) {
                        ForEach(selects, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .frame(width: 200)
                Spacer()
                }
                
                Chart {
                    ForEach(cartList) { data in
                        AreaMark(
                            x: .value("Date", data.date),
                            y: .value("Posting", data.count)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(
                            .linearGradient(
                                Gradient(colors: [.blue.opacity(0.8), .blue.opacity(0.2)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                }
                .frame(height: 300)
                .padding(.leading, 80)
                .padding(.trailing)
                .padding(.top)
                .chartXAxis(.hidden)  // x축 숨김
                .chartYAxis(.hidden)
                .chartPlotStyle { plot in
                    plot.background(.clear)  // 배경 제거
                        .border(.clear)  // 테두리 제거
                }
            }
        } else {
            EmptyView()
                .frame(height: 300)
        }
    }
    static func dateFromString(_ dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString) ?? Date()
    }
    
}



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


class ChartDataModel: ObservableObject {
    @Published var chartDates: ChartDatas = ChartDatas(check: [ChartData](), Download: [ChartData]())
}

struct ChartView: View {
    @ObservedObject var dataModel: ChartDataModel
    @State private var selecteds = "조회"
    let selects = ["조회", "다운로드"]
    
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
                    ForEach(selecteds == "조회" ? dataModel.chartDates.check : dataModel.chartDates.Download) { data in
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
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .chartPlotStyle { plot in
                    plot.background(.clear)
                        .border(.clear)
                }
            }
        } else {
            EmptyView()
                .frame(height: 300)
        }
    }
}



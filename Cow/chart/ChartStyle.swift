//
//  ChartStyle.swift
//  Cow
//
//  Created by admin on 2021/8/28.
//

import Foundation
import Charts
extension BarLineChartViewBase{
    
    func cowBarLineChartViewBaseStyle()  {
        // 禁止Y轴的滚动与放大
        scaleYEnabled = false
        dragYEnabled = false
        // 允许X轴的滚动与放大
        dragXEnabled = true
        scaleXEnabled = true
        // X轴动画
        animate(xAxisDuration: 0.35);
        
        // 边框
        borderLineWidth = 0.5;
        borderColor = UIColor(named: "Background 2") ?? .lightGray
        drawBordersEnabled = true
        setScaleMinima(1, scaleY: 1)
        doubleTapToZoomEnabled = false
        
        
        let axis = xAxis
        axis.labelPosition = .bottom
        axis.axisLineWidth = 1
        axis.gridLineWidth = 0.5
        axis.gridColor = .black.withAlphaComponent(0.2)
        axis.labelCount = 3
        axis.labelRotationAngle = -1
        
        let leftAxis = leftAxis
        leftAxis.labelPosition = .insideChart
        leftAxis.axisLineWidth = 1
        leftAxis.gridLineWidth = 0.5
        leftAxis.gridColor = .black.withAlphaComponent(0.2)
        leftAxis.labelCount = 3
        leftAxis.decimals = 3
        
        let rightAxis = rightAxis
        rightAxis.labelPosition = .insideChart
        rightAxis.axisLineWidth = 1
        rightAxis.gridLineWidth = 0.5
        rightAxis.gridColor = .black.withAlphaComponent(0.2)
        rightAxis.labelCount = 3
        
        
        let legend = legend
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.drawInside = true
        legend.xEntrySpace = 4
        legend.yEntrySpace = 4
        legend.yOffset = 10
    }
    
}

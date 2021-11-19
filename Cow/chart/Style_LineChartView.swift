//
//  Style.swift
//  Cow
//
//  Created by admin on 2021/11/11.
//

import Foundation
import Charts

extension LineChartView{
    func defualStyle()  {
        //设置间隙
        setExtraOffsets(left: 4, top: 0, right: 4, bottom: 0)
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
        borderColor = .mb_line
        drawBordersEnabled = true
        setScaleMinima(1, scaleY: 1)
        doubleTapToZoomEnabled = false
        
        
        let axis = xAxis
        axis.labelPosition = .bottom
        axis.axisLineWidth = 1
        axis.gridLineWidth = 0.5
        axis.gridColor = .mb_line
        axis.labelCount = 3
        axis.labelRotationAngle = -1
        
        let leftAxis = leftAxis
        leftAxis.labelPosition = .insideChart
        leftAxis.axisLineWidth = 1
        leftAxis.gridLineWidth = 0.5
        leftAxis.gridColor = .mb_line
        leftAxis.labelCount = 3
        leftAxis.decimals = 3
        
        let rightAxis = rightAxis
        rightAxis.enabled = false
      
        
        
        let legend = legend
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.drawInside = true
        legend.xEntrySpace = 4
        legend.yEntrySpace = 4
        legend.yOffset = 10
        
        //是否支持marker功能 这里可以自定义一个点击弹窗的marker
        drawMarkers = true
    
    }
}


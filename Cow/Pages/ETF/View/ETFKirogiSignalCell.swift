//
//  ETFKirogiSignalCell.swift
//  Cow
//
//  Created by admin on 2021/8/28.
//

import UIKit
import Charts

class ETFKirogiSignalCell: UICollectionViewCell {
    
    @IBOutlet weak var chartView: LineChartView!
    var celldata:ETFDetaiModen?
 
    override func awakeFromNib() {
        super.awakeFromNib()
        style_candleStickChart()
    }
    func style_candleStickChart()  {
        
        chartView.cowBarLineChartViewBaseStyle()
    }
  
    
    var signallineSets:[ChartDataSet]{
        func setstyle(set:LineChartDataSet){
            set.drawCirclesEnabled = false
            set.drawFilledEnabled = false
            set.drawValuesEnabled = false
            set.fillColor = .yellow.withAlphaComponent(0.1)
            set.mode = .cubicBezier
        }
        guard let cdata = celldata else {
            return []
        }
        let datas = cdata.ochl
        var list:[ChartDataSet] = []
        
        var str = "signal"
        let entrys = datas.enumerated().map{ ChartDataEntry(x: Double($0), y: $1[str].double())}
        let set =  LineChartDataSet( entries: entrys)
        set.axisDependency = .left
        set.label = str
        set.colors = [.red]
        setstyle(set: set)
        list.append(set)
        
        str = "sort"
        let entrys1 = datas.enumerated().map{ ChartDataEntry(x: Double($0), y: $1[str].double())}
        let set1 =  LineChartDataSet( entries: entrys1)
        set1.axisDependency = .right
        set1.label = str
        set1.colors = [.yellow]
        list.append(set1)
        setstyle(set: set1)
        return list
            
        
    }
    
    func updateUI()  {
       
        chartView.data = LineChartData(dataSets: signallineSets)
    }
    
    
}

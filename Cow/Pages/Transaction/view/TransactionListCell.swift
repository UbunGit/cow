//
//  TransactionListCell.swift
//  Cow
//
//  Created by admin on 2021/9/2.
//

import UIKit
import Charts

class TransactionListCell: UITableViewCell {
    var celldata:Transaction? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var chareView: BarChartView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var codeLab: UILabel!
    
    @IBOutlet weak var storeCountLab: UILabel! //持仓数
    
    func updateUI()  {
        guard let data = celldata else {
            return
        }
        chareView.cowBarLineChartViewBaseStyle()
        chareView.scaleXEnabled = false
        chareView.dragXEnabled = true
        chareView.scaleYEnabled = false
        chareView.xAxis.labelCount = data.datas.count
        chareView.xAxis.labelFont = .systemFont(ofSize: 6)
        chareView.xAxis.labelRotationAngle = -30
        chareView.rightAxis.enabled = false
        chareView.leftAxis.labelPosition = .outsideChart
        
        
//        //是否有图例。默认true
//        chareView.legend.enabled = true
//        chareView.legend.formSize = 20
//        chareView.legend.font = .systemFont(ofSize: 30)
//        chareView.legend.textColor = .red
        chareView.legend.horizontalAlignment = .left
        chareView.legend.drawInside = false
//        chareView.legend.orientation = .vertical
//        //换行
//        chareView.legend.wordWrapEnabled = true
//        //比例
//        chareView.legend.maxSizePercent = 0.95
    
     
        nameLab.text = data.name
        codeLab.text = data.code
        storeCountLab.text = data.storeCount.string()
        chareView.data = barset()
        let xaxis = chareView.xAxis
        xaxis.valueFormatter = IndexAxisValueFormatter.init(
            values:data.datas.map { $0["bdate"].string().toDate("yyyyMMdd")?.toString("MM-dd") ?? "0" }
        )
    }
    
    func barset() -> BarChartData?  {
        guard let data = celldata else {
            return nil
        }
        
        
        let bpriceSets =  data.datas.enumerated().map { (index,item) -> BarChartDataEntry in
             BarChartDataEntry(x:index.double() , y: item["bprice"].double())
//            BarChartDataEntry(x:index.double() , y: item["bprice"].double())
           
        }
        let bpriceSet = BarChartDataSet(entries: bpriceSets,label: "买入价")
        bpriceSet.colors = [.yellow]
        
        let targetSets =  data.datas.enumerated().map { (index,item) -> BarChartDataEntry in
             BarChartDataEntry(x:index.double() , y: item["target"].double())
        }
        let targetSet = BarChartDataSet(entries: targetSets, label: "目标价")
        targetSet.colors = [.red]
     
        let bdata = BarChartData(dataSets: [bpriceSet,targetSet])
        bdata.barWidth = 0.17
        bdata.groupBars(fromX: -0.5, groupSpace: 0.4, barSpace: 0.03)
        return bdata
    }
    
    
    
}

//
//  TransactionListCell.swift
//  Cow
//
//  Created by admin on 2021/9/2.
//

import UIKit
import Charts
import Alamofire
import Magicbox

class TransactionListCell: UITableViewCell {
    
    var celldata:Transaction? = nil

    
    lazy var limitLine: ChartLimitLine = {
        let limitLine = ChartLimitLine(limit: 0.00, label: "当前价")
        limitLine.lineWidth = 1;
        limitLine.lineColor = .red;
        limitLine.valueFont = .systemFont(ofSize: 8)
        limitLine.valueTextColor = .lightGray
        limitLine.lineDashLengths = [5.0, 5.0]//虚线样式
        return limitLine
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        chareView.borderColor = .black.alpha(0.1)
        chareView.xAxis.axisLineColor = .black.alpha(0.1)
        chareView.leftAxis.axisLineColor = .black.alpha(0.1)
        chareView.leftAxis.addLimitLine(limitLine)
        chareView.scaleXEnabled = true
        chareView.dragXEnabled = true
        chareView.scaleYEnabled = false
      
        chareView.xAxis.labelFont = .systemFont(ofSize: 6)
        chareView.xAxis.labelRotationAngle = -30
        chareView.rightAxis.enabled = false
        chareView.leftAxis.labelPosition = .outsideChart
        chareView.leftAxis.axisMinimum = 0
        chareView.legend.horizontalAlignment = .left
        chareView.legend.drawInside = false
    }
   
    @IBOutlet weak var chareView: BarChartView!
    @IBOutlet weak var nameLab: UILabel! // 股票名
    @IBOutlet weak var codeLab: UILabel! // 股票code
    @IBOutlet weak var storeCountLab: UILabel! //持仓数
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var nowpriceLab: UILabel! // 当前价格
    @IBOutlet weak var lowyieldLab: UILabel! //
    @IBOutlet weak var lowEarningsLab: UILabel!
    
    @IBOutlet weak var hightYieldLab: UILabel!
    @IBOutlet weak var hightEarningsLab: UILabel!
    @IBOutlet weak var ballanceLab: UILabel!
    override func updateUI()  {
        guard let data = celldata else {
            return
        }
        refreshBtn.layer.removeAllAnimations()
        chareView.cowBarLineChartViewBaseStyle()
        chareView.xAxis.labelCount = data.datas.count

        nameLab.text = data.name
        codeLab.text = data.code
        storeCountLab.text = data.storeCount.string()
        chareView.data = barset()
        let xaxis = chareView.xAxis
        xaxis.valueFormatter = IndexAxisValueFormatter.init(
            values:data.datas.map { $0["bdate"].string().toDate("yyyyMMdd").toString("MM-dd") }
        )
        
        limitLine.limit = data.price
        limitLine.label = "当前价\n\(data.price)"
        nowpriceLab.text = "当前价:\(data.price)"
        chareView.animate(yAxisDuration: 0.35)
        
      
        if data.price != 0 {
            // 最低收益
            let low = data.lowdata
            let value = low["bprice"].double()
            let bcount = low["bcount"].int()
            let yi = data.price-value
            lowyieldLab.text = (yi/data.price).percentStr()
            lowEarningsLab.text = (yi*bcount.double()).price()
            // 最高收益
            let hight = data.hightData
            let hvalue = hight["bprice"].double()
            let hbcount = hight["bcount"].int()
            let h = data.price-hvalue
            hightYieldLab.text = (h/data.price).percentStr()
            hightEarningsLab.text = (h*hbcount.double()).price()
            let red = data.datas.reduce(0) {
                $0 + $1["bcount"].double() * $1["bprice"].double()
            }
            
            ballanceLab.text = red.price()
         
        }
            
      
        
    }
    
    @IBAction func updatePrice() {
      
        refreshBtn.beginrefresh()
        celldata?.updatePrice()
    }
    
    func barset() -> BarChartData?  {
        guard let data = celldata else {
            return nil
        }
        
        
        let bpriceSets =  data.datas.enumerated().map { (index,item) -> BarChartDataEntry in
             BarChartDataEntry(x:index.double() , y: item["bprice"].double())
        }
        let bpriceSet = BarChartDataSet(entries: bpriceSets,label: "买入价")
        bpriceSet.colors = [.yellow.alpha(0.5)]
        
        let targetSets =  data.datas.enumerated().map { (index,item) -> BarChartDataEntry in
             BarChartDataEntry(x:index.double() , y: item["target"].double())
        }
        let targetSet = BarChartDataSet(entries: targetSets, label: "目标价")
        targetSet.colors = [.red.alpha(0.5)]
     
        let bdata = BarChartData(dataSets: [bpriceSet,targetSet])
        bdata.barWidth = 0.3
        bdata.groupBars(fromX: -0.5, groupSpace: 0.4, barSpace: 0.03)
        return bdata
    }
    
    
    
    
}

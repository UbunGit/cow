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
    
    var code:String? = nil
    var state:Int = 0
    private var datas:[[String:Any]] =  []
    
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
        chareView.xAxis.labelPosition = .bottomInside
        chareView.leftAxis.axisMinimum = 0
     
    }
   
    @IBOutlet weak var chareView: BarChartView!
    @IBOutlet weak var nameLab: UILabel! // 股票名
    @IBOutlet weak var codeLab: UILabel! // 股票code
    @IBOutlet weak var storeCountLab: UILabel! //持仓数

    @IBOutlet weak var nowpriceLab: UILabel! // 当前价格
    @IBOutlet weak var lowyieldLab: UILabel! //
    @IBOutlet weak var lowEarningsLab: UILabel!

    @IBOutlet weak var hightYieldLab: UILabel!
    @IBOutlet weak var hightEarningsLab: UILabel!
    @IBOutlet weak var ballanceLab: UILabel! // 总成本
    
    override func updateUI()  {
		guard let _code = code else{
			return
		}
       
        
        let price = StockManage.share.price(_code)
        let name = StockManage.share.storeName(_code)
        
        if state == 0{
            datas = Transaction.soreDatas(_code)
        }else if state == 1{
            datas = Transaction.finishDatas(_code)
        }
        // 总成本
        let cost = Transaction.soreCost(datas)
        ballanceLab.text = cost.price()
       
		nameLab.text = name
		codeLab.text = _code
        storeCountLab.text = Transaction.soreCount(datas).string()
       
        
        limitLine.limit = price
        limitLine.label = price.price()
        nowpriceLab.text = price.price()
      
      
        
        // 最高成本收益/收益率
        if let low = Transaction.max(datas){
            let earnings = Transaction.earnings(low)
            let yield = Transaction.yield(low)
            lowEarningsLab.text = earnings.price()
            lowyieldLab.text = yield.percentStr("%0.1f")
        }
        // 最低成本
        if let hight = Transaction.min(datas){
            let earnings = Transaction.earnings(hight)
            let yield = Transaction.yield(hight)
            hightEarningsLab.text = earnings.price()
            hightYieldLab.text = yield.percentStr("%0.1f")
        }
        
        chareView.cowBarLineChartViewBaseStyle()
        chareView.xAxis.labelCount = datas.count
        chareView.data = barset(datas: datas)
        let xaxis = chareView.xAxis
        xaxis.valueFormatter = IndexAxisValueFormatter.init(
            values:datas.map { $0["bdate"].string().date("yyyyMMdd").toString("MM-dd") }
        )
        chareView.animate(yAxisDuration: 0.35)
        chareView.legend.drawInside = true
        chareView.legend.verticalAlignment = .bottom
        chareView.legend.horizontalAlignment = .left
    
      
        
    }

    
	func barset(datas:[[String:Any]]) -> BarChartData?  {
       
        
        
        let bpriceSets =  datas.enumerated().map { (index,item) -> BarChartDataEntry in
			let price =  item["price"].double()
            let bprice = item["bprice"].double()
         
            if bprice>price{
                return BarChartDataEntry(x:index.double() , y: bprice, icon: .init(named: "hand.thumbsdown.fill"))
            }else{
                return BarChartDataEntry(x:index.double() , y: bprice, icon: .init(named: "hand.thumbsup.fill"))
            }
             
 
        }
       
        let bpriceSet = BarChartDataSet(entries: bpriceSets,label: "买入价")
        bpriceSet.colors = [.yellow.alpha(0.5)]
        
        let targetSets =  datas.enumerated().map { (index,item) -> BarChartDataEntry in
            let set = BarChartDataEntry(x:index.double() , y: item["target"].double())
            return set
        }
        let targetSet = BarChartDataSet(entries: targetSets, label: "目标价")
        targetSet.colors = [.red.alpha(0.5)]
     
        let bdata = BarChartData(dataSets: [bpriceSet,targetSet])
        bdata.barWidth = 0.3
        bdata.groupBars(fromX: -0.5, groupSpace: 0.4, barSpace: 0.03)
        return bdata
    }
    
    
    
    
}

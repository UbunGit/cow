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
	private var price:Double = 0.00
	
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
     
    }
   
    @IBOutlet weak var chareView: BarChartView!
    @IBOutlet weak var nameLab: UILabel! // 股票名
    @IBOutlet weak var codeLab: UILabel! // 股票code
    @IBOutlet weak var storeCountLab: UILabel! //持仓数
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var nowpriceLab: UILabel! // 当前价格
    @IBOutlet weak var lowyieldLab: UILabel! //
    @IBOutlet weak var lowEarningsLab: UILabel!
    
    @IBOutlet weak var remarkImg: UIImageView! // 买卖提醒
    @IBOutlet weak var hightYieldLab: UILabel!
    @IBOutlet weak var hightEarningsLab: UILabel!
    @IBOutlet weak var ballanceLab: UILabel!
    
    override func updateUI()  {
		guard let data = celldata
		else{
			return
		}
		price = data.price
		let datas = data.datas
		
        refreshBtn.layer.removeAllAnimations()
        chareView.cowBarLineChartViewBaseStyle()
        chareView.xAxis.labelCount = datas.count

		nameLab.text = data.name
		codeLab.text = data.code
        storeCountLab.text = data.storeCount.string()
        chareView.data = barset(datas: datas)
        let xaxis = chareView.xAxis
        xaxis.valueFormatter = IndexAxisValueFormatter.init(
            values:datas.map { $0["bdate"].string().date("yyyyMMdd").toString("MM-dd") }
        )
        
        limitLine.limit = price
        limitLine.label = "当前价\n\(price)"
        nowpriceLab.text = "当前价:\(price)"
        chareView.animate(yAxisDuration: 0.35)
        chareView.legend.verticalAlignment = .top
        chareView.legend.horizontalAlignment = .right
        chareView.legend.drawInside = false
      
        if price != 0 {
            // 最低收益
//            let low = data.lowdata
//            let value = low["bprice"].double()
//            let bcount = low["bcount"].int()
//            let yi = data.price-value
//            lowyieldLab.text = (yi/data.price).percentStr()
//            lowEarningsLab.text = (yi*bcount.double()).price("%0.1f")
            
            
            
            // 最高收益
//            let hight = data.hightData
//            let hvalue = hight["bprice"].double()
//            let hbcount = hight["bcount"].int()
//            let h = data.price-hvalue
//            let hi = h/data.price
//            hightYieldLab.text = hi.percentStr()
//            hightEarningsLab.text = (h*hbcount.double()).price("%0.1f")
//            let red = data.datas.reduce(0) {
//                $0 + $1["bcount"].double() * $1["bprice"].double()
//            }
            
            // 最低成本收益率
      
//            let lowcost = data.lowcost
//            let lowcostprice = lowcost["bprice"].double()
//            let lowcosttarget = lowcost["target"].double()
//            let lowx = lowcostprice/data.price
//            remarkImg.tintColor = .cw_bg1
//            if lowcosttarget<=data.price{
//                remarkImg.tintColor = .red
//            }
//            if lowx <= 0.9{
//                remarkImg.tintColor = .blue
//            }
            
            
//            ballanceLab.text = red.price()
//
        }
            
      
        
    }
    
    @IBAction func updatePrice() {
      
        refreshBtn.beginrefresh()
//        celldata?.updatePrice()
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

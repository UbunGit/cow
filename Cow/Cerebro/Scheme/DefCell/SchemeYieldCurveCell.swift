//
//  SchemeYieldCurveCell.swift
//  Cow
//  收益曲线
//  Created by admin on 2021/11/5.
//

import UIKit
import Alamofire
import Charts
class SchemeYieldCurve{
    
    var valueChange:(()->())? = nil
    var state:Int = 0 {  // 0初始化 1成功 2加载中 3失败
        didSet{
            if let change = valueChange
            {
                change()
            }
        }
    }
    
    var message:String? = nil{
        didSet{
            if let change = valueChange
            {
                change()
            }
        }
    }
    var data:[[String:Any]]? = nil
    var pools:[[String:Any]] = []
    var error:Any? = nil
    var schemeId = 1
    
    func loadData(){
        state = 2
        AF.scheme_pool(schemeId).responseModel([[String:Any]].self) { result in
            switch result{
            case .success(let value):
                self.pools = value
                self.downochldate()
            case .failure(let err):
                self.error = err
            }
            
          
        }
    }
   
    func downochldate(){
        let group = DispatchGroup()
        if sm.isExistsTable("loc_ochl") == false{
           _ = sm.createTable("loc_ochl")
        }
        
        
        self.message = "正在下载股票数据"
        pools.forEach { item in
            group.enter()
            let code = item["code"].string()
            let end:String? = nil
            
            var begin:String? = nil
            if let data = sm.select(" select max(date) date from loc_ochl where code='\(code)' ").last{
                begin = data["date"].string()
            }
            AF.dailydata(code, type: item["type"].int(), begin: begin, end: end)
                .responseModel([[String:Any]].self) { result in
                    switch result{
                    case .success(let value):
                        if sm.mutableinster(table: "loc_ochl", column: ["code","date","open","close","low","high","vol"], datas: value) == false{
                            
                        }
                        break
                    case .failure( _ ):
                        
                        self.state = 3
                        break
                    }
                    group.leave()
                    
                }
        }
        group.notify(queue: .main) {
            if self.state != 3{
                self.state = 1
            }else{
                self.message = "数据下载失败"
            }
            
        }
        
    }
    func downback_trace(){
        if sm.isExistsTable("back_trade") == false{
            _ = sm.createTable("back_trade")
        }
        let sql = " delete FROM back_trade where scheme_id = '\(schemeId)' "
        _ =  sm.delete(sql)
        
    }
    
   
}
// 图表相关
extension SchemeYieldCurve{
    
    // 每只股票收盘价走势
    func lineChartDataSet(ydates:[String])->[LineChartDataSet]{
       
      
        
        return pools.map {
            let code = $0["code"].string()
            let closes = sm.select(" select close,date from loc_ochl where code='\(code)' order by date ")
            let chartentye = closes.map { item -> ChartDataEntry  in
                let x = ydates.firstIndex { ydate in
                    item["date"].string() == ydate
                }.double()
                let y = item["close"].double()
                return  ChartDataEntry.init(x: x, y: y)
            }
            let set = LineChartDataSet(entries: chartentye, label: "\(code)")
            set.mode = .cubicBezier
            set.label = code
            set.drawCirclesEnabled = false
            set.drawFilledEnabled = false
            set.drawValuesEnabled = false
            set.fillColor = .yellow.withAlphaComponent(0.1)
            set.colors = [UIColor.doraemon_random()]
            return set
        }
        
    }
    // 资产趋势
    func yeidChartDataSet(ydates:[String])->LineChartDataSet{
        
//        let chartentye = ydates.map { item -> ChartDataEntry  in
//            let x = ydates.firstIndex { ydate in
//                item["date"].string() == ydate
//            }.double()
//            let y = item["close"].double()
//            return  ChartDataEntry.init(x: x, y: y)
//        }
        return LineChartDataSet()
    }
    
    
}

class SchemeYieldCurveCell: UICollectionViewCell {
    
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var msgLab: UILabel!
    var celldata:SchemeYieldCurve? = nil{
        didSet{
            updateUI()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        chartView.defualStyle()
        
    }
    override func updateUI() {
        guard let data = celldata else{
            return
        }
        if data.state == 1{
            msgLab.text = "成功"
            msgLab.alpha = 0.1
            let codes = data.pools.map{ "'\($0["code"].string())'"}
            let ydates = sm.select(" select date from loc_ochl where code in (\(codes.joined(separator: ","))) group by date order by date ").map { $0["date"].string()}
            let xaxis = chartView.xAxis
            xaxis.valueFormatter = IndexAxisValueFormatter.init(
                values:ydates.map { $0.date("yyyyMMdd").toString("yyyy-MM-dd") }
            )
            let sets = data.lineChartDataSet(ydates: ydates)
           
            chartView.data = LineChartData(dataSets: sets)
           
        }else if data.state == 3{
            msgLab.text = celldata?.message
        }else if data.state == 2{
            msgLab.text = celldata?.message
        }
        
    }

}

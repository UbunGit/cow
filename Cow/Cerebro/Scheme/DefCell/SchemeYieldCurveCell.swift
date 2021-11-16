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
                self.downback_trace()
            }else{
                self.message = "数据下载失败"
            }
            
        }
        
    }
    func downback_trace(){
        self.message = "正在下载交易列表"
        if sm.isExistsTable("back_trade") == false{
            _ = sm.createTable("back_trade")
        }
        let sql = " delete FROM back_trade where scheme_id = '\(schemeId)' "
        _ =  sm.delete(sql)
        
        
        AF.back_trade(schemeId: schemeId)
            .responseModel([[String:Any]].self) { result in
                switch result{
                case .success(let value):
                    if sm.mutableinster(table: "back_trade", column: ["id","scheme_id","date","type","code","price","dir","count","sid"], datas: value) == true{
                        self.state = 1
                    }else{
                        self.state = 3
                    }
                    break
                case .failure( _ ):
                    
                    self.state = 3
                    break
                }
            }
        
    }
    
   
}
// 图表相关
extension SchemeYieldCurve{
    
    // 每只股票收盘价走势
    func lineChartDataSet(ydates:[String])->[LineChartDataSet]{
       
      
        
        return pools.map {
            let code = $0["code"].string()
            let closes = sm.select(" select close,date from loc_ochl where code='\(code)' order by date ")
            let mindate = sm.select(" select min(date) date  from loc_ochl where code='\(code)' ").first
            var firstclose:Double = 0
            if let md = mindate{
                if let tclose = closePrice(code: code, date: md["date"].string()){
                    firstclose = tclose
                }
             
            }
            let chartentye = closes.map { item -> ChartDataEntry  in
               
                let x = ydates.firstIndex { ydate in
                    item["date"].string() == ydate
                }.double()
                let close = item["close"].double()
                let y = (close/firstclose)-1
                return  ChartDataEntry.init(x: x, y: y)
            }
            let set = LineChartDataSet(entries: chartentye, label: "\(code)")
            set.mode = .cubicBezier
            set.label = code
            set.drawCirclesEnabled = false
            set.drawFilledEnabled = false
            set.drawValuesEnabled = false
            set.fillColor = .yellow.withAlphaComponent(0.1)
            set.colors = [UIColor.doraemon_random().alpha(0.5) ]
            return set
        }
        
    }
    //获取某日股票收盘价
    func closePrice(code:String,date:String)->Double?{
        let sql = """
        SELECT close FROM loc_ochl
        WHERE date = '\(date)' and code='\(code)'
        """
        if let date = sm.select(sql).first{
            return date["close"].double()
        }else{
            return nil
        }
        
    }
    // 资产趋势
    func yeidChartDataSet(ydates:[String])->[LineChartDataSet]{
      
        // 获取当日资产
        func yeid(date:String) -> Double{
            var yied:Double = 0
            // 获取已卖出的资产
            var sql = """
            SELECT sum(pricev) blance from
            (select (t2.price/t1.price)-1 pricev,t2.date from back_trade t1
            LEFT JOIN (select * from back_trade WHERE dir =1 and scheme_id='\(schemeId)' ) t2 ON t2.sid=t1.id
            WHERE t1.dir=0 and t1.sid NOTNULL AND t2.date<='\(date)' and t1.scheme_id='\(schemeId)')
            """
            if let blancedic = sm.select(sql).first{

                yied += blancedic["blance"].double()
            }
            // 获取未卖出的资产
            sql = """
            SELECT * FROM
                (
                select t1.date date,t2.date sdate,t1.code code,t1.price price
                from back_trade t1
                LEFT JOIN
                    (
                    select * from back_trade
                    WHERE dir =1  and scheme_id='\(schemeId)'
                    ) t2 ON t2.sid=t1.id
                WHERE t1.dir=0 and t1.scheme_id='\(schemeId)'
                ) as t
            WHERE  t.date<='\(date)'
            AND (t.sdate>'\(date)' OR t.sdate ISNULL)
            """
           
            let untrades = sm.select(sql)
            untrades.forEach { item in
                let code = item["code"].string()
                let price = item["price"].double()
                if let close = closePrice(code: code, date: date){
                    let of = ((close/price) - 1)
                    yied += of
       
                }
            }
            return yied

        }
        
        let chartentye = ydates.enumerated().map { (index, item) -> ChartDataEntry  in
            let x = index.double()
          
            let y = yeid(date: item)
            return  ChartDataEntry.init(x: x, y: y)
        }
        let yiedset = LineChartDataSet(entries: chartentye, label: "资产")
        yiedset.mode = .cubicBezier
        yiedset.lineWidth = 1.5
        yiedset.label = "资产"
        yiedset.drawCirclesEnabled = false
        yiedset.drawFilledEnabled = false
        yiedset.drawValuesEnabled = false
        yiedset.fillColor = .yellow.withAlphaComponent(0.1)
        yiedset.colors = [UIColor.red]
        return [yiedset]
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
        DispatchQueue.main.async {
            guard let data = self.celldata else{
                return
            }
            if data.state == 1{
                self.msgLab.text = "成功"
                self.msgLab.alpha = 0.1
                let codes = data.pools.map{ "'\($0["code"].string())'"}
                let ydates = sm.select(" select date from loc_ochl where code in (\(codes.joined(separator: ","))) group by date order by date ").map { $0["date"].string()}
                let xaxis = self.chartView.xAxis
                xaxis.valueFormatter = IndexAxisValueFormatter.init(
                    values:ydates.map { $0.date("yyyyMMdd").toString("yyyy-MM-dd") }
                )
                let sets = data.lineChartDataSet(ydates: ydates)
                let set2 = data.yeidChartDataSet(ydates: ydates)
               
                self.chartView.data = LineChartData(dataSets: sets+set2)
               
            }else if data.state == 3{
                self.msgLab.text = self.celldata?.message
            }else if data.state == 2{
                self.msgLab.text = self.celldata?.message
            }
        }
    
        
    }

}

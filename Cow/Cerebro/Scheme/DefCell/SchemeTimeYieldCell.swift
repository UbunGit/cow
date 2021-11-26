//
//  SchemeTimeYuekdCell.swift
//  Cow
//
//  Created by admin on 2021/11/24.
//

import UIKit
import Charts
import Alamofire

class SchemeTimeYield:NSObject{
    var schemeId:Int!
    var beginDate:Date? = nil
    var endDate:Date? = nil
    var step:Int = 4 // 4->年 6->月
    var pools:[[String:Any]] = []
    var chartSets:[BarChartDataSet] = []
    var chartEntrys:[ChartDataEntry] = []
    var ydates:[String] = []
}

class SchemeTimeYieldCell: UICollectionViewCell {
    
    var celldata:SchemeTimeYield? = nil
    lazy var chartView: HorizontalBarChartView = {
        let chartview = HorizontalBarChartView()
        chartview.backgroundColor = .cw_bg1
        chartview.legend.enabled = false
        chartview.borderColor = .mb_line
        chartview.borderLineWidth = 0.5
        
        let axis = chartview.xAxis
        axis.labelPosition = .bottom
        axis.axisLineWidth = 1
        axis.gridLineWidth = 0.5
        axis.gridColor = .cw_bg5.withAlphaComponent(0.2)
 
        
        let leftAxis = chartview.leftAxis
        leftAxis.labelPosition = .insideChart
        leftAxis.axisLineWidth = 1
        leftAxis.gridLineWidth = 0.5
        leftAxis.gridColor = .cw_bg5.withAlphaComponent(0.2)
     
        
        let rightAxis = chartview.rightAxis
        rightAxis.labelPosition = .insideChart
        rightAxis.axisLineWidth = 1
        rightAxis.gridLineWidth = 0.5
        rightAxis.gridColor = .cw_bg5.withAlphaComponent(0.2)
        
  
        // 禁止Y轴的滚动与放大
        chartview.scaleYEnabled = true
        chartview.dragYEnabled = true
        // 允许X轴的滚动与放大
        chartview.dragXEnabled = false
        chartview.scaleXEnabled = false
        chartview.leftAxis.enabled = false
        return chartview
    }()
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(chartView)
        chartView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
      
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func updateUI() {
        guard let data = celldata else{
            return
        }
        chartView.xAxis.valueFormatter =  IndexAxisValueFormatter.init(
            values:data.ydates
        )
        chartView.data = BarChartData(dataSets: data.chartSets)
    }
  
    func loadData(){
        guard let data = celldata else{
            return
        }
 
        data.updateYxid()
        data.updatechartSets()
        
        updateUI()
    }
    
}
// 图表相关
extension SchemeTimeYield{
    
    func updatechartSets(){
        
        let entrys = self.getChartDataEntry()
        let set = BarChartDataSet(entries:entrys, label: "")
        set.colors = entrys.map{ $0.y>0 ? UIColor.red : UIColor.green}
        set.highlightColor = .red
        self.chartSets = [set]

    }
    // 获取 entry
    func getChartDataEntry()->[ChartDataEntry]{
        let entrys = self.ydates.enumerated().map { (index,value) -> BarChartDataEntry in
            
            var begin = value
            var end = value
            if value.count == 4{
                begin.append("0100")
                end.append("1032")
            }else if value.count == 6{
                begin.append("00")
                end.append("32")
            }
            let beginyied = sm.scheme_property(schemeId, date: begin)
            let endyied = sm.scheme_property(schemeId, date: end)
            let y = endyied-beginyied
            return BarChartDataEntry(x: index.double(), y: y)
        }
        return entrys
   
    }
    // 获取Y坐标值
    func updateYxid(){
        let codes = pools.map{ $0["code"] }
        let sql = """
        select substr(date,0,\(step)) date from loc_ochl
        where code in (\(codes.map{ "'\($0.string())'" }.joined(separator: ",")))
        GROUP BY substr(date,0,\(step))
        """
        self.ydates = sm.select(sql).map{ $0["date"].string()}
    }
  
    
}

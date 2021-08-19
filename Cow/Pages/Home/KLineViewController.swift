//
//  KLineViewController.swift
//  Cow
//
//  Created by admin on 2021/8/18.
//

import UIKit
import Charts
import Magicbox

class KLineViewController: UIViewController {
    @objc var code:String = ""

    var end:String = ""
    var count:Int = 100
    @IBOutlet weak var candleStickChart: CandleStickChartView!
    
    lazy var soreSimpleView: SoreSimpleView = {
   
        return SoreSimpleView.initWithNib()
    }()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = code
        view.addSubview(soreSimpleView)
        soreSimpleView.snp.makeConstraints { snp in
            snp.width.equalToSuperview()
            snp.height.equalTo(120)
            snp.bottom.equalTo(candleStickChart.snp_topMargin)
        }
        style_candleStickChart()
        candleStickChart.delegate = self
        candleStickChart.data = setDataCount(100, range: 100)
    }
    
    func style_candleStickChart()  {
        // 禁止Y轴的滚动与放大
        candleStickChart.scaleYEnabled = false
        candleStickChart.dragYEnabled = false
        // 允许X轴的滚动与放大
        candleStickChart.dragXEnabled = true
        candleStickChart.scaleXEnabled = true
        // X轴动画
//        chartView.animate(xAxisDuration: 0.35);
    
        // 边框
        candleStickChart.borderLineWidth = 0.5;
        candleStickChart.drawBordersEnabled = true
        candleStickChart.setScaleMinima(1.01, scaleY: 1)
        candleStickChart.doubleTapToZoomEnabled = false
        
        let axis = candleStickChart.xAxis
        axis.labelPosition = .bottom
        axis.axisLineWidth = 1
        axis.gridLineWidth = 0.5
        axis.gridColor = .black.withAlphaComponent(0.2)
        axis.labelCount = 3
        axis.labelRotationAngle = -1
        
        let legend = candleStickChart.legend
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.drawInside = false
        legend.xEntrySpace = 4
        legend.yEntrySpace = 4
        legend.yOffset = 10
    }



}
extension KLineViewController:ChartViewDelegate{
    
    func setDataCount(_ count: Int, range: UInt32)->CandleChartData {
        do {
            let datas = try sm.select(table: "stockdaily", fitter: "code='\(code)'", orderby: ["date"], limmit: .init(location: 0, length: 100), isasc: false)
            soreSimpleView.data = datas.last
            let yVals1 =  datas.enumerated().map { (index,item) -> CandleChartDataEntry in
             
                let high = item["high"].double()
                let low = item["low"].double()
                let open = item["open"].double()
                let close = item["close"].double()
                return CandleChartDataEntry(x: Double(index), shadowH: high, shadowL: low, open: open, close: close)
            }
            let xaxis = candleStickChart.xAxis
            xaxis.valueFormatter = IndexAxisValueFormatter.init(
                values:datas.map { $0["date"].string().toDate("yyyyMMdd")?.toString("yyyy-MM-dd") ?? "0" }
            )
            
           

            let set = CandleChartDataSet(entries: yVals1)
      
            set.label = "\(code)"
            set.decreasingColor = .green
            set.decreasingFilled = true
            set.increasingColor = .red
            set.increasingFilled = true
            set.shadowColorSameAsCandle = true
            set.drawValuesEnabled = false
            let data = CandleChartData(dataSet: set)
            return data
        } catch  {
            self.view.error(error.localizedDescription)
            return CandleChartData()
        }
        }
    
}

extension Optional{
    func string() -> String {
        guard let str = self else {
            return ""
        }
        return "\(str)"
    }
    func double(_ defual:Double=0) -> Double {
        guard let str = self else {
            return defual
        }
        return Double("\(str)") ?? defual
    }
    func price(_ formatter:String="%0.2f") -> String {
        return String(format: formatter, self.double())
    }
}

extension Double{
    func price(_ formatter:String="%0.2f") -> String {
        return String(format: formatter, self)
    }
}


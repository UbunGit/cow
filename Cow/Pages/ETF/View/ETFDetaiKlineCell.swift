//
//  ETFDetaiKlineCell.swift
//  Cow
//
//  Created by admin on 2021/8/27.
//

import UIKit
import Charts


class ETFDetaiKlineCell: UICollectionViewCell {
 
    @IBOutlet weak var chartView: CombinedChartView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var nowPriceLab: UILabel!
    @IBOutlet weak var difLab: UILabel!
    @IBOutlet weak var difvLab: UILabel!
    @IBOutlet weak var highLab: UILabel!
    @IBOutlet weak var openLab: UILabel!
    @IBOutlet weak var lowLab: UILabel!
    @IBOutlet weak var closeLab: UILabel!
    @IBOutlet weak var volLab: UILabel!
    @IBOutlet weak var amountLab: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    var celldata:ETFDetaiModen?
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        style_candleStickChart()
        
        chartView.delegate = self
    }
    
    @IBAction func leftClick(_ sender: Any) {
        guard let tcelldata = celldata else {
            return
        }
        tcelldata.range.location += 30
        tcelldata.updateochl()
    }
    @IBAction func rightclick(_ sender: Any) {
        guard let tcelldata = celldata else {
            return
        }
        tcelldata.range.location = ((tcelldata.range.location - 30) < 0) ? 0 : tcelldata.range.location - 30
        tcelldata.updateochl()
    }
    @IBAction func addclick(_ sender: Any) {
        guard let tcelldata = celldata else {
            return
        }
       
        let offse = Int(Float(tcelldata.range.length)*0.1)
        if tcelldata.range.length + offse > 1000{
            return
        }
        tcelldata.range.length = tcelldata.range.length + offse
        tcelldata.updateochl()
    }
    @IBAction func minusclick(_ sender: Any) {
        guard let tcelldata = celldata else {
            return
        }
        let offse = Int(Float(tcelldata.range.length)*0.1)
        if tcelldata.range.length - offse < 10{
            return
        }
        tcelldata.range.length = tcelldata.range.length - offse
        tcelldata.updateochl()
    }
    
    func updateTopView()  {
        guard let cdata = celldata else {
            return
        }
        if cdata.ochl.count == 0 {
            return
        }
        if cdata.ochl.count < cdata.select {
            return
        }
        let vdata = cdata.ochl[cdata.select]
        
        nowPriceLab.text = vdata["close"].price()
        difLab.text = (vdata["close"].double()-vdata["open"].double()).price()
        difvLab.text = (((vdata["close"].double()-vdata["open"].double())/vdata["open"].double())*100) .price("%0.2f%%")
        
        highLab.text = vdata["high"].price()
        openLab.text = vdata["open"].price()
        lowLab.text = vdata["low"].price()
        closeLab.text = vdata["close"].price()
        volLab.text = vdata["vol"].wanStr()
        amountLab.text = vdata["amount"].price()
        dateLab.text = vdata["date"].string().toDate("yyyyMMdd").toString("yyyy/MM/dd")
        let bgcolor:UIColor = (vdata["close"].double()-vdata["open"].double())>0 ? .systemRed : .systemGreen
        topView.backgroundColor = bgcolor
    }
    
    override func updateUI()  {
        reloadChartView()
        updateTopView()
       
       
    }
}



extension ETFDetaiKlineCell{
    
    func style_candleStickChart()  {
        chartView.cowBarLineChartViewBaseStyle()
    }
    func reloadChartView() {
        let candledata = candleData
        let chartData = CombinedChartData()
        chartData.candleData = candledata;
        chartData.lineData = LineChartData(dataSets: maLineSets)
        chartView.data = chartData
    }
    // MARK K线图
    var candleData:CandleChartData{
        guard let cdata = celldata else {
            return CandleChartData()
        }
        let datas = cdata.ochl
        let yVals1 =  datas.enumerated().map { (index,item) -> CandleChartDataEntry in
            
            let high = item["high"].double()
            let low = item["low"].double()
            let open = item["open"].double()
            let close = item["close"].double()
            return CandleChartDataEntry(x: Double(index), shadowH: high, shadowL: low, open: open, close: close)
        }
        let xaxis = chartView.xAxis
        xaxis.valueFormatter = IndexAxisValueFormatter.init(
            values:datas.map { $0["date"].string().toDate("yyyyMMdd").toString("yyyy-MM-dd") }
        )
        
        let set = CandleChartDataSet(entries: yVals1)
        
        set.label = "\(cdata.code)"
        set.decreasingColor = .green
        set.decreasingFilled = true
        set.increasingColor = .red
        set.increasingFilled = true
        set.shadowColorSameAsCandle = true
        set.drawValuesEnabled = false
        
        return CandleChartData(dataSet: set)
    }
    
    // MA
    var maLineSets:[ChartDataSet]{
        guard let cdata = celldata else {
            return []
        }
        let datas = cdata.ochl
        return KDefualMAS.map { ma ->LineChartDataSet in
            let str = "ma\(ma)"
            let entrys = datas.enumerated().map{ ChartDataEntry(x: Double($0), y: $1[str].double())}
            let set =  LineChartDataSet(entries: entrys)
            set.mode = .cubicBezier
            set.label = str
            set.drawCirclesEnabled = false
            set.drawFilledEnabled = false
            set.drawValuesEnabled = false
            set.fillColor = .yellow.withAlphaComponent(0.1)
            set.colors = [UIColor(named: str)!]
            return set
        }
//
        
    }
}

extension ETFDetaiKlineCell:ChartViewDelegate{

    
    // 选中
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight){
        celldata?.select = Int(entry.x)
    }
    
    /// Called when a user stops panning between values on the chart
    // 手指离开
    func chartViewDidEndPanning(_ chartView: ChartViewBase){
        
    }
    
    // Called when nothing has been selected or an "un-select" has been made.
    // 没有选中任何内容
    func chartValueNothingSelected(_ chartView: ChartViewBase){
        celldata?.select = Int(INT32_MAX)
    }
    
    // Callbacks when the chart is scaled / zoomed via pinch zoom gesture.
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat){
        print("scaleX:\(scaleX)")
        print("scaleY:\(scaleY)")
    }
    
    // Callbacks when the chart is moved / translated via drag gesture.
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat){
        
    }
    
    // Callbacks when Animator stops animating
    func chartView(_ chartView: ChartViewBase, animatorDidStop animator: Animator){
        
    }
    
}


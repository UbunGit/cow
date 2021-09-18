//
//  KLineViewController.swift
//  Cow
//
//  Created by admin on 2021/8/18.
//

import UIKit
import Charts
import Magicbox



class KLineViewController: BaseViewController {
    @objc var code:String = ""
    @objc var name:String = ""
    
    var end:String = ""
    
    var range:NSRange = .init(location: 0, length: 100)
    
    var datas:[[String:Any]] = []
    @IBOutlet weak var chartView: CombinedChartView!
    
    lazy var soreSimpleView: SoreSimpleView = {
        
        return SoreSimpleView.initWithNib()
    }()
    lazy var naveView:KlineNavBarView = {
        let aview = KlineNavBarView.initWithNib()
        return aview
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naveView.codeLab.text = code
        naveView.nameLab.text = name
        navigationItem.titleView = naveView
        view.addSubview(soreSimpleView)
        soreSimpleView.snp.makeConstraints { snp in
            snp.width.equalToSuperview()
            snp.top.equalToSuperview()
            snp.bottom.equalTo(chartView.snp_topMargin)
        }
        style_candleStickChart()
        chartView.delegate = self

        updateDate()
    }

    
    
    func updateDate()  {
        do {
            
            self.datas = try sm.select_stockdaily_stockma(fitter: "t1.code='\(code)'", orderby: ["t1.date"], limmit:range, isasc: false).reversed()
            soreSimpleView.data = datas.last
            reloadChartView()
        } catch  {
            self.view.error(error.localizedDescription)
            
        }
    }
    
}
extension KLineViewController{
    
    func style_candleStickChart()  {
        // 禁止Y轴的滚动与放大
        chartView.scaleYEnabled = false
        chartView.dragYEnabled = false
        // 允许X轴的滚动与放大
        chartView.dragXEnabled = true
        chartView.scaleXEnabled = true
        // X轴动画
        //        chartView.animate(xAxisDuration: 0.35);
        
        // 边框
        chartView.borderLineWidth = 0.5;
        chartView.drawBordersEnabled = true
        chartView.setScaleMinima(1, scaleY: 1)
        chartView.doubleTapToZoomEnabled = false
        
        
        let axis = chartView.xAxis
        axis.labelPosition = .bottom
        axis.axisLineWidth = 1
        axis.gridLineWidth = 0.5
        axis.gridColor = .black.withAlphaComponent(0.2)
        axis.labelCount = 3
        axis.labelRotationAngle = -1
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelPosition = .insideChart
        leftAxis.axisLineWidth = 1
        leftAxis.gridLineWidth = 0.5
        leftAxis.gridColor = .black.withAlphaComponent(0.2)
        leftAxis.labelCount = 3
        leftAxis.decimals = 3
        
        let rightAxis = chartView.rightAxis
        rightAxis.labelPosition = .insideChart
        rightAxis.axisLineWidth = 1
        rightAxis.gridLineWidth = 0.5
        rightAxis.gridColor = .black.withAlphaComponent(0.2)
        rightAxis.labelCount = 3
        
        
        let legend = chartView.legend
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.drawInside = true
        legend.xEntrySpace = 4
        legend.yEntrySpace = 4
        legend.yOffset = 10
        
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
        let yVals1 =  datas.enumerated().map { (index,item) -> CandleChartDataEntry in
            
            let high = item["high"].double()
            let low = item["low"].double()
            let open = item["open"].double()
            let close = item["close"].double()
            return CandleChartDataEntry(x: Double(index), shadowH: high, shadowL: low, open: open, close: close)
        }
        let xaxis = chartView.xAxis
        xaxis.valueFormatter = IndexAxisValueFormatter.init(
            values:datas.map { $0["date"].string().date("yyyyMMdd").toString("yyyy-MM-dd") }
        )
        
        let set = CandleChartDataSet(entries: yVals1)
        
        set.label = "\(code)"
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
        return []
//        return KDefualMAS.map { ma ->LineChartDataSet in
//            let str = "ma\(ma)"
//            let entrys = datas.enumerated().map{ ChartDataEntry(x: Double($0), y: $1[str].double())}
//            let set =  LineChartDataSet(entries: entrys)
//            set.mode = .cubicBezier
//            set.label = str
//            set.drawCirclesEnabled = false
//            set.drawFilledEnabled = false
//            set.drawValuesEnabled = false
//            set.fillColor = .yellow.withAlphaComponent(0.1)
//            set.colors = [UIColor(named: str)!]
//            return set
//        }
//
        
    }
}
extension KLineViewController:ChartViewDelegate{
    
   
    
    // 选中
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight){
        let select = Int(entry.x)
        soreSimpleView.data = datas[select]
    }
    
    /// Called when a user stops panning between values on the chart
    // 手指离开
    func chartViewDidEndPanning(_ chartView: ChartViewBase){
        
    }
    
    // Called when nothing has been selected or an "un-select" has been made.
    // 没有选中任何内容
    func chartValueNothingSelected(_ chartView: ChartViewBase){
        soreSimpleView.data = datas.last
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


extension KLineViewController{
    @IBAction func leftClick(_ sender: Any) {
        range.location = range.location + 30
        updateDate()
    }
    @IBAction func rightclick(_ sender: Any) {
        range.location = ((range.location - 30) < 0) ? 0 : range.location - 30
        updateDate()
    }
    @IBAction func addclick(_ sender: Any) {
        let offse = Int(Float(range.length)*0.1)
        if range.length + offse > 1000{
            return
        }
        range.length = range.length + offse
        updateDate()
    }
    @IBAction func minusclick(_ sender: Any) {
        let offse = Int(Float(range.length)*0.1)
        if range.length - offse < 10{
            return
        }
        range.length = range.length - offse
        updateDate()
    }
}




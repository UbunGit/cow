//
//  ETFDetaiKlineCell.swift
//  Cow
//
//  Created by admin on 2021/8/27.
//

import UIKit
import Charts

var KDefualMAS = [5,10,20,30]
protocol CellModenDelegate:UIView {

    func needupdate()
    func updateUI()
}

class ETFDetaiKlineCellModen {
    
    var range = NSRange(location: 0, length: 100)
    private var _code:String?
    var code = ""{
        didSet{
            if _code == code {
                return
            }
            _code = code
            updateochl()
        }
    }
    var delegate:CellModenDelegate?
    
    var ochl:[[String:Any]] = []
    
    // 获取数据
    func updateochl()  {

        delegate?.loading()
        sm.select_etfdaily_kirogetf(fitter: " t1.code='\(code)' ",
                                    orderby: ["date"],
                                    limmit: range,
                                    isasc: false) { result in
            self.delegate?.loadingDismiss()
            switch result{
            case.failure(let err):
                self.delegate?.error(err.localizedDescription)
            case .success(let value):
                self.ochl = value.reversed()
                self.delegate?.updateUI()
            }
        }
    }
}
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
    var celldata = ETFDetaiKlineCellModen()
    var select:Int = 0{
        didSet{
            if select >= celldata.ochl.count {
                select = celldata.ochl.count-1
            }
            updateTopView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        style_candleStickChart()
        celldata.delegate = self
        chartView.delegate = self
    }
    
    @IBAction func leftClick(_ sender: Any) {
        celldata.range.location += 30
        celldata.updateochl()
    }
    @IBAction func rightclick(_ sender: Any) {
        
        celldata.range.location = ((celldata.range.location - 30) < 0) ? 0 : celldata.range.location - 30
        celldata.updateochl()
    }
    @IBAction func addclick(_ sender: Any) {
      
       
        let offse = Int(Float(celldata.range.length)*0.1)
        if celldata.range.length + offse > 1000{
            return
        }
        celldata.range.length = celldata.range.length + offse
        celldata.updateochl()
    }
    @IBAction func minusclick(_ sender: Any) {
       
        let offse = Int(Float(celldata.range.length)*0.1)
        if celldata.range.length - offse < 10{
            return
        }
        celldata.range.length = celldata.range.length - offse
        celldata.updateochl()
    }
}
extension ETFDetaiKlineCell:CellModenDelegate{
    func needupdate() {
        updateUI()
    }
    func updateTopView()  {
        let vdata = celldata.ochl[select]
        
        nowPriceLab.text = vdata["close"].price()
        difLab.text = (vdata["close"].double()-vdata["open"].double()).price()
        difvLab.text = ((vdata["close"].double()-vdata["open"].double())/vdata["open"].double()).price("%0.2f%%")
        
        highLab.text = vdata["high"].price()
        openLab.text = vdata["open"].price()
        lowLab.text = vdata["low"].price()
        closeLab.text = vdata["close"].price()
        volLab.text = vdata["vol"].price()
        amountLab.text = vdata["amount"].price()
        dateLab.text = vdata["date"].string().toDate("yyyyMMdd")?.toString("yyyy/MM/dd")
        let bgcolor:UIColor = (vdata["close"].double()-vdata["open"].double())>0 ? .systemRed : .systemGreen
        topView.backgroundColor = bgcolor
    }
    
    func updateUI()  {
        reloadChartView()
        updateTopView()
       
       
    }
}
extension ETFDetaiKlineCell{
    
    func style_candleStickChart()  {
        // 禁止Y轴的滚动与放大
        chartView.scaleYEnabled = false
        chartView.dragYEnabled = false
        // 允许X轴的滚动与放大
        chartView.dragXEnabled = true
        chartView.scaleXEnabled = true
        // X轴动画
        chartView.animate(xAxisDuration: 0.35);
        
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
        let datas = celldata.ochl
        let yVals1 =  datas.enumerated().map { (index,item) -> CandleChartDataEntry in
            
            let high = item["high"].double()
            let low = item["low"].double()
            let open = item["open"].double()
            let close = item["close"].double()
            return CandleChartDataEntry(x: Double(index), shadowH: high, shadowL: low, open: open, close: close)
        }
        let xaxis = chartView.xAxis
        xaxis.valueFormatter = IndexAxisValueFormatter.init(
            values:datas.map { $0["date"].string().toDate("yyyyMMdd")?.toString("yyyy-MM-dd") ?? "0" }
        )
        
        let set = CandleChartDataSet(entries: yVals1)
        
        set.label = "\(celldata.code)"
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
        let datas = celldata.ochl
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
        select = Int(entry.x)
    }
    
    /// Called when a user stops panning between values on the chart
    // 手指离开
    func chartViewDidEndPanning(_ chartView: ChartViewBase){
        
    }
    
    // Called when nothing has been selected or an "un-select" has been made.
    // 没有选中任何内容
    func chartValueNothingSelected(_ chartView: ChartViewBase){
        select = Int(INT32_MAX)
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


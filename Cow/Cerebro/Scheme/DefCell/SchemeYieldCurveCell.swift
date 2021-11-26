//
//  SchemeYieldCurveCell.swift
//  Cow
//  收益曲线
//  Created by admin on 2021/11/5.
//

import UIKit
import Alamofire
import Charts
import AudioToolbox
class SchemeYieldCurve:SchemeStateObject{

    var datas:[[String:Any]]? = nil{
        didSet{
            datahash = "\(Date())"
        }
    }
    
    var pools:[[String:Any]] = []
    var schemeId = 1
    var begindate:String? = nil
    var endDate:String? = nil
    
    func loadData(){
        datas = []
    }

}

// 图表相关
extension SchemeYieldCurve{
    
    // 收盘价趋势
    func closeChartDataSet(_ code:String, ydates:[String])->[ChartDataEntry]{
        let b = sm.closePrice(code: code, date: begindate.string())
        return ydates.enumerated().map { (index, item) -> ChartDataEntry  in
            let x = index.double()
            let e = sm.closePrice(code: code, date: item)
            let y = e-b
            return  ChartDataEntry.init(x: x, y: y)
        }
    }
    // 资产趋势
    func yeidChartDataSet(ydates:[String])->[ChartDataEntry]{

        let b = sm.scheme_property(schemeId, date: begindate.string())
        return ydates.enumerated().map { (index, item) -> ChartDataEntry  in
            let x = index.double()
            let e = sm.scheme_property(schemeId, date: item)
            let y = e-b
            return  ChartDataEntry.init(x: x, y: y)
        }

    }
    
    
}
// header
class SchemeYieldCurveHeader:UICollectionReusableView{
   
    lazy var titleLab:UILabel = {
        let lable = UILabel()
        lable.textColor = .cw_text6
        lable.font = .boldSystemFont(ofSize: 14)
        lable.text = "标题"
        return lable
    }()
    
    lazy var settingbtn:UIButton = {
        let button = UIButton()
        button.tintColor  = .cw_text4
        button.setImage(.init(systemName: "arrow.clockwise"), for: .normal)
        return button
    }()
    lazy var beginDatePicker:UIDatePicker = {
        let begin = UIDatePicker()
        begin.locale =  Locale(identifier: "zh_CN")
        begin.datePickerMode = .date
        return begin
    }()
    
    lazy var endDatePicker:UIDatePicker = {
        let end = UIDatePicker()
        end.datePickerMode = .date
        end.locale =  Locale(identifier: "zh_CN")
        return end
    }()
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(settingbtn)
        addSubview(titleLab)
        addSubview(beginDatePicker)
        addSubview(endDatePicker)
        mb_tlRadius = 8
        mb_trRadius = 8
        backgroundColor = .cw_bg1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }
        settingbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-8)
            make.width.equalTo(28)
            make.centerY.equalToSuperview()
        }
        endDatePicker.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
            make.right.equalTo(settingbtn.snp.left).offset(-4)
        }
        beginDatePicker.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
            make.right.equalTo(endDatePicker.snp.left).offset(-4)
        }
        
    }
}


class SchemeYieldCurveCell: UICollectionViewCell {
    
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var msgLab: UILabel!
    
    private var ydates:[String] = []
    private var closes:[String:Any] = [:]
    private var yeidsEntry:[ChartDataEntry] = []
    
    private var datahash:String? = nil
    
    var celldata:SchemeYieldCurve? = nil{
        didSet{
            updateUI()
        }
    }
    lazy var markView:UILabel = {
        let lable = UILabel()
        lable.backgroundColor = .cw_bg5.alpha(0.5)
        lable.mb_radius = 4
        lable.numberOfLines = 0
        lable.font = .systemFont(ofSize: 12)
        return lable
    }()
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chartView.defualStyle()
        chartView.delegate = self
        
    }
    override func updateUI() {
        DispatchQueue.main.async {
            
            guard let data = self.celldata else{
                return
            }
            if data.datahash == self.datahash{
                return
            }else{
                self.datahash = data.datahash
            }
            if data.error != nil{
                self.msgLab.text = data.error
                return
            }
           
        
            self.msgLab.text = "成功"
            self.msgLab.alpha = 0.1
            let queue  = DispatchQueue.init(label: "crew")
            self.loading()
            queue.async {
                let codes = data.pools.map{ "'\($0["code"].string())'"}
                self.ydates = sm.select(
                            """
                            select date from loc_ochl
                            where code in (\(codes.joined(separator: ",")))
                            and date>='\(data.begindate.string())' and date<='\(data.endDate.string())'
                            group by date
                            order by date
                            """).map { $0["date"].string()}
                let xaxis = self.chartView.xAxis
                xaxis.valueFormatter = IndexAxisValueFormatter.init(
                    values:self.ydates.map { $0.date("yyyyMMdd").toString("yyyy-MM-dd") }
                )
                
                data.pools.forEach {
                    let code = $0["code"].string()
                    
                    let chartentye = data.closeChartDataSet(code, ydates: self.ydates)
                    self.closes[code] = chartentye
                }
                
                self.yeidsEntry = data.yeidChartDataSet(ydates: self.ydates)
                DispatchQueue.main.async {
                    
                    self.reloadChart()
                    self.loadingDismiss()
                }
                
            }
        
        }
        
        
    }
    
    func reloadChart(){
        let yiedset = LineChartDataSet(entries: self.yeidsEntry, label: "资产")
        yiedset.mode = .cubicBezier
        yiedset.lineWidth = 1.5
        yiedset.label = "资产"
        yiedset.drawCirclesEnabled = false
        yiedset.drawFilledEnabled = false
        yiedset.drawValuesEnabled = false
        yiedset.fillColor = .yellow.withAlphaComponent(0.1)
        yiedset.colors = [UIColor.red]
        let closeSets = self.closes.map { (key,value) -> LineChartDataSet in
            let set = LineChartDataSet(entries: value as? [ChartDataEntry], label: "\(key)")
            set.mode = .cubicBezier
            set.label = key
            set.drawCirclesEnabled = false
            set.drawFilledEnabled = false
            set.drawValuesEnabled = false
            set.fillColor = .yellow.withAlphaComponent(0.1)
            set.colors = [UIColor.random().alpha(0.5) ]
            return set
        }
        let sets = closeSets+[yiedset]
        
        chartView.data = LineChartData(dataSets: sets)
    }
    
}

extension SchemeYieldCurveCell:ChartViewDelegate{
    
    // 选中
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight){
        let yeidentry = self.yeidsEntry.first(where: {$0.x == entry.x})?.y
        let vclose = closes.map { (key: String, value: Any) -> String in
            guard let entrys = value as? [ChartDataEntry] else {
                return "---"
            }
            if let selectentrys = entrys.first(where: { item in  entry.x==item.x }){
                return "\(key):\(selectentrys.y.price())"
            }
            else{
                return "---"
            }

        }.joined(separator: "\n")
        markView.text =
        """
        时间:\(self.ydates[entry.x.int()])
        资产:\(yeidentry.price("%0.3f"))
        \(vclose)
        """

        chartView.addSubview(markView)
        markView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        // 震动
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

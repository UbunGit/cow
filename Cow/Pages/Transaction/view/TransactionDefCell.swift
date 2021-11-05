//
//  TransactionDefCell.swift
//  Cow
//
//  Created by admin on 2021/9/10.
//

import UIKit
import Charts

class TransactionDefCell: UITableViewCell {
    
    var cellData:[String:Any]
        = [:]
    var price = 8.00
    @IBOutlet weak var chartView: HorizontalBarChartView!
    
    @IBOutlet weak var countLab: UILabel!
    @IBOutlet weak var esLab: UILabel!
    @IBOutlet weak var yaidLab: UILabel!
    @IBOutlet weak var bdateLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        chartView.gridBackgroundColor = .red
        chartView.leftAxis.enabled = false
        chartView.leftAxis.gridColor = .clear
        chartView.rightAxis.enabled = false
        chartView.rightAxis.gridColor = .clear
        chartView.xAxis.enabled = false
        chartView.scaleXEnabled = false
        chartView.dragXEnabled = false
        chartView.scaleYEnabled = false
        chartView.leftAxis.axisMinimum = 0
        chartView.borderColor = .clear
//        chartView.legend.horizontalAlignment = .right
        chartView.legend.verticalAlignment = .bottom
        chartView.legend.drawInside = false
//        chartView.legend.enabled = false;
//        cellData["bprice"] = 10.00
//        cellData["target"] = 20.00
    }
    override func updateUI()  {
        chartView.data = barset()
        countLab.text = cellData["bcount"].string()
        bdateLab.text = cellData["bdate"].string()
        let sellprice = cellData["sprice"].double()
        
        // 已卖出
        if sellprice>0{
            let cha = sellprice - cellData["bprice"].double()
            yaidLab.text = (cha/sellprice).percentStr()
            esLab.text = (cha * cellData["bcount"].double()).price()
            if cha > 0 {
                chartView.backgroundColor = .red.alpha(0.1)
            }else{
                chartView.backgroundColor = .green.alpha(0.1)
            }
        }else{
            if price != 0 {
                let cha = price - cellData["bprice"].double()
                yaidLab.text = (cha/price).percentStr()
                esLab.text = (cha * cellData["bcount"].double()).price()
                if cha > 0 {
                    chartView.backgroundColor = .red.alpha(0.1)
                }else{
                    chartView.backgroundColor = .green.alpha(0.1)
                }
            }
        }
       
        
        
    }
    
    func barset() -> BarChartData?  {
        
        let set0 = BarChartDataSet(entries: [BarChartDataEntry(x:0 , y: cellData["bprice"].double())], label: "成本\(cellData["bprice"].price())")
        set0.colors = [.red.alpha(0.1)]
        let sellprice = cellData["sprice"].double()
        var set2:BarChartDataSet
        if sellprice>0{
            set2 = BarChartDataSet(entries: [BarChartDataEntry(x:2 , y: sellprice)], label: "卖出价\(sellprice.price())")
            set2.colors = [.red.alpha(0.2)]
        }else{
            set2 = BarChartDataSet(entries: [BarChartDataEntry(x:2 , y: price)], label: "现价\(price.price())")
            set2.colors = [.red.alpha(0.2)]
        }
        

        
        let set1 = BarChartDataSet(entries: [BarChartDataEntry(x:1 , y: cellData["target"].double())], label: "目标\(cellData["target"].price())")
        set1.colors = [.red.alpha(0.3)]

        
       


        let bdata = BarChartData(dataSets: [set1,set2,set0])
        bdata.barWidth = 0.9
        bdata.groupBars(fromX: -0.5, groupSpace: 0.4, barSpace: 0.03)
        return bdata
    }

   
    
}
extension UIColor{
    func alpha(_ value:Float) -> UIColor {
        self.withAlphaComponent(CGFloat(value))
    }
}


//
//  TransactionDefCell.swift
//  Cow
//
//  Created by admin on 2021/9/10.
//

import UIKit
import Charts

class TransactionDefCell: UITableViewCell {
    
    var cellData:TransactionItem = .init()

    @IBOutlet weak var chartView: BarChartView!
    
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var countLab: UILabel!
    @IBOutlet weak var esLab: UILabel!
    @IBOutlet weak var yaidLab: UILabel!
    @IBOutlet weak var bdateLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        chartView.backgroundColor = .clear
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

        chartView.legend.verticalAlignment = .bottom
        chartView.legend.drawInside = false

    }
    override func updateUI()  {
        
	
        countLab.text = cellData.bcount.string()
        bdateLab.text = cellData.bdate.string()
        let yaid = cellData.yield
        yaidLab.text = yaid.percentStr("%0.1f")
        esLab.text = cellData.earnings.price()
        
        if yaid > 0 {
     
            chartView.mb_borderColor = .up.alpha(0.1)
        }else{
            
            chartView.mb_borderColor = .down.alpha(0.1)
        }
        customView.backgroundColor = .white
        chartView.data = barset()
    }
    
    func barset() -> BarChartData?  {
        let bprice = cellData.bprice
        let sellprice = cellData.sprice
		
        let price = cellData.price
        let target = cellData.target
        let set0 = BarChartDataSet(entries: [BarChartDataEntry(x:0 , y: bprice)], label: "成本\(cellData.bprice.price())")
        set0.colors = [.red.alpha(0.1)]
       
        var set2:BarChartDataSet
        if sellprice>0{
            set2 = BarChartDataSet(entries: [BarChartDataEntry(x:2 , y: sellprice)], label: "卖出价\(sellprice.price())")
            set2.colors = [.red.alpha(0.2)]
        }else{
            set2 = BarChartDataSet(entries: [BarChartDataEntry(x:2 , y: price)], label: "现价\(price.price())")
            set2.colors = [.red.alpha(0.2)]
        }

        let set1 = BarChartDataSet(entries: [BarChartDataEntry(x:1 , y: target)], label: "目标\(target.price())")
        set1.colors = [.red.alpha(0.3)]

        let bdata = BarChartData(dataSets: [set0,set2,set1])
        bdata.barWidth = 0.3
        bdata.groupBars(fromX: -0.0, groupSpace: 0.1, barSpace: 0.3)
        return bdata
    }

   
    
}
extension UIColor{
    func alpha(_ value:Float) -> UIColor {
        self.withAlphaComponent(CGFloat(value))
    }
}


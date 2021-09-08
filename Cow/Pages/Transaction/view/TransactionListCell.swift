//
//  TransactionListCell.swift
//  Cow
//
//  Created by admin on 2021/9/2.
//

import UIKit
import Charts

class TransactionListCell: UITableViewCell {
    var celldata:Transaction? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var chareView: BarChartView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var codeLab: UILabel!
    
    @IBOutlet weak var storeCountLab: UILabel! //持仓数
    
    func updateUI()  {
        guard let data = celldata else {
            return
        }
        nameLab.text = data.name
        codeLab.text = data.code
        storeCountLab.text = data.storeCount.string()
        chareView.data = barset()
    }
    
    func barset() -> BarChartData?  {
        guard let data = celldata else {
            return nil
        }
        
        
        let barsets =  data.datas.enumerated().map { (index,item) -> BarChartDataEntry in
             BarChartDataEntry(x:index.double() , y: item["bprice"].double())
        }
        let set = BarChartDataSet(entries: barsets)
        return BarChartData(dataSets: [set])
    }
    
    
    
}

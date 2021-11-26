//
//  SchemeHistoryCell.swift
//  Cow
//
//  Created by admin on 2021/11/24.
//

import UIKit
import UIKit
class SchemeHistory:NSObject{
    var schemeId = 1
    var selectDate:String = Date().toString("yyyyMMdd")
    
    
    var valueChange:(()->())? = nil
    var datas:[[String:Any]] = []
    var error:Any? = nil
    func loadData(){
        
        let sql = """
        SELECT * FROM
                    (
                    select t1.date date,t2.date sdate,t1.code code,t1.price buyPrice,t2.price sellPrice, (t2.price-t1.price)/t1.price yied
                    from back_trade t1
                    LEFT JOIN
                        (
                        select * from back_trade
                        WHERE dir =1  and scheme_id='1'
                        ) t2 ON t2.sid=t1.id
                    WHERE t1.dir=0 and t1.scheme_id='1'
                    ) as t
        """
        self.datas = sm.select(sql)
       
    }
}
class SchemeHistoryCell: UICollectionViewCell {

    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var codeLab: UILabel!
    @IBOutlet weak var buydateLab: UILabel!
    @IBOutlet weak var buyPriceLab: UILabel!
    
    @IBOutlet weak var yiedLab: UILabel!
    @IBOutlet weak var sellPriceLab: UILabel!
    @IBOutlet weak var sellDateLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

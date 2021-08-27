//
//  SoreSimpleView.swift
//  Cow
//
//  Created by admin on 2021/8/18.
//

import UIKit

@IBDesignable
class SoreSimpleView: UIView {
    
    

    var data:[String:Any]?{
        didSet{
            updateUI()
        }
    }
    
    @IBOutlet weak var nowPriceLab: UILabel!
    @IBOutlet weak var difLab: UILabel!
    @IBOutlet weak var difvLab: UILabel!
    @IBOutlet weak var highLab: UILabel!
    @IBOutlet weak var openLab: UILabel!
    @IBOutlet weak var lowLab: UILabel!
    @IBOutlet weak var closeLab: UILabel!
    @IBOutlet weak var volLab: UILabel!
    @IBOutlet weak var amiuntLab: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    
 

   
    
    func updateUI()  {
        guard let vdata  = data else {
            return
        }
        
        nowPriceLab.text = vdata["close"].price()
        difLab.text = (vdata["close"].double()-vdata["open"].double()).price()
        difvLab.text = ((vdata["close"].double()-vdata["open"].double())/vdata["open"].double()).price("%0.2f%%")
        
        highLab.text = vdata["high"].price()
        openLab.text = vdata["open"].price()
        lowLab.text = vdata["low"].price()
        closeLab.text = vdata["close"].price()
        volLab.text = vdata["vol"].price()
        amiuntLab.text = vdata["amount"].price()
        dateLab.text = vdata["date"].string().toDate("yyyyMMdd")?.toString("yyyy/MM/dd")
        let bgcolor:UIColor = (vdata["close"].double()-vdata["open"].double())>0 ? .systemRed : .systemGreen
        backgroundColor = bgcolor
    }
    
    

}

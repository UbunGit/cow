//
//  SchemeDesRecommendCell.swift
//  Cow
//
//  Created by admin on 2021/11/5.
//

import UIKit
import Alamofire

class SchemeDesRecommendData{
    
    var valueChange:(()->())? = nil
    var schemeId = 1
    var selectDate:String? = nil
    var datas:[[String:Any]] = []{
        didSet{
            
        }
    }
    var state:Int = 0 // 0初始化 1成功 2架载中 3失败
    
    var error:Any? = nil //错误描述
    
    func loadData(){
        self.state = 2
        getLastDate()
    }
    func getLastDate(){
        if selectDate == nil{
            AF.scheme_lastDate(self.schemeId)
                .responseModel([[String:Any]].self) { result in
                    switch result{
                    case .success(let value):
                        if let datedic = value.first{
                            self.selectDate = datedic["date"].string()
                            self.getrecommends()
                        }else{
                            self.state = 3
                            self.error = BaseError(code: -1, msg: "为获取到最后交易日期")
                        }
                        
                        break
                    case .failure(let err):
                        self.state = 3
                        self.error = err
                        break
                    }
                }
            
        }else{
            self.getrecommends()
        }
      
    }
    // 获取推荐股票列表
    func getrecommends(){
        guard let date = selectDate else{
            return
        }
        let req =  AF.scheme_rec(id: self.schemeId, date: date)
        req.responseModel([[String:Any]].self) { resule in
            switch resule{
            case .success(let value):
                self.error = nil
                self.datas = value
                self.state = 1
            case .failure(let err):
                self.state = 3
                self.error = err
            }
            
            self.valueChange?()
            self.loadName()
         
        }
    }
    
    func loadName(){
        AF.code_info(datas.map{ $0["code"].string() })
            .responseModel([[String:Any]].self) { resule in
                switch resule{
                case .success(let value):
                    self.datas = self.datas.map{
                        let code = $0["code"].string()
                        var data = $0
                        if let eq = value.first(where: { $0["code"].string() == code }){
                            data["name"] = eq["name"].string()
                        }
                        return data
                    }
                case .failure(_):
                    break
                }
                self.valueChange?()
                
            }
    }
}

class SchemeDesRecommendCell: UICollectionViewCell {
    
   
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var priceLab: UILabel!
    @IBOutlet weak var dirLab: UILabel!
    @IBOutlet weak var codeLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
   
   
   

}

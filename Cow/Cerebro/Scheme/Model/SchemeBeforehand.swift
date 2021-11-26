//
//  SchemeBeforehand.swift
//  Cow
//
//  Created by admin on 2021/11/25.
//

import UIKit
import Alamofire

class SchemeBeforehand: SchemeStateObject {

    var datas:[[String:Any]] = []{
        didSet{
            datahash = "\(Date())"
            valueChange?()
        }
    }
    var selectDate:String? = nil
    var schemeId:Int!
    
    func loadDate(){
        guard let date = selectDate else{
            return
        }
        loading = true
        AF.scheme_beforeOrder(schemeId, date: date)
            .responseModel([[String:Any]].self) { result in
                self.loading = false
                switch result{
                case .success(let value):
                    self.datas = value
                
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            }
    }
    
}

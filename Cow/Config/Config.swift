//
//  Config.swift
//  Cow
//
//  Created by admin on 2021/8/9.
//

import Foundation
import Alamofire
import Magicbox
import YYKit
import HandyJSON
var baseurl:String{
    UserDefaults.standard.string(forKey: "baseurl") ?? "http://10.10.11.143:5000"
}

class  APIData<T:Codable>:HandyJSON,Codable{
    var code:Int = -1
    var message:String = ""
    var data:T?
    required init() {
        
    }

}


extension DataRequest{
    
    open func responseModel<T>(_ type: T.Type, callback:@escaping (Result<T, APIError>) ->  ()) where T : Codable{

        self.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                
                
                guard  let apidata = APIData<T>.deserialize(from: value as? [String:Any]) else{
                    callback(.failure(APIError(code: -1, msg: "json error")))
                    return
                }
                
                if apidata.code == 0 {
                    callback(.success(apidata.data!))
                }else{
                    callback(.failure(APIError(code: apidata.code, msg: apidata.message )))
                }
                
                
            case .failure(let error):
                print("🐬 \(error)")
                callback(.failure(APIError(code: -200, msg: "http error")))
            }
        }
    }
    

}


extension JSONDecoder{
    
    open func decode<T>(_ type: T.Type, from any: Any) throws -> T where T : Decodable{
        let jsonData = try JSONSerialization.data(withJSONObject: any, options: [])
        return try JSONDecoder().decode(type, from: jsonData)
    }
}

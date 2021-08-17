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




extension DataRequest{
    
    struct APIData<T>:HandyJSON{
        var code:Int = -1
        var message:String = ""
        var data:T?
      
    }
    
    func debugLog(_ json:AFDataResponse<Any>) {
        #if DEBUG
        
        guard let request = performedRequests.last ?? lastRequest,
              let url = request.url,
              let method = request.httpMethod,
              let headers = request.allHTTPHeaderFields
        else {
            return debugPrint("DM No request created yet.")
        }
//        let body = String(data: request.httpBody ?? Data(), encoding: .utf8)
        let body =  request.httpBody.map { String(decoding: $0, as: UTF8.self) }
        let requestDescription = "\(method) \(url.absoluteString)"
        let state  =  response.map { "\(requestDescription) (\($0.statusCode))" } ?? requestDescription
        let result = json.description
        let icon = (response?.statusCode == 200) ? "🧘‍♂️" : " 🧱"
        debugPrint(
           
            """
            *****************\(icon)******************
            url:\(state)
            header:\(headers)
            body:\(body ?? "")
            result:\(result)
            ******************************************
            """
        )

        #endif
        
    }
    

    open func responseModel<T>(_ type: T.Type, callback:@escaping (Result<T, APIError>)  ->  ()) {
        
        self.responseJSON { (response) in
            self.debugLog(response)
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

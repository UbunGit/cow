//
//  NewWork.swift
//  PlayGround
//
//  Created by admin on 2021/9/13.
//

import Foundation
import Alamofire
import HandyJSON
import Magicbox

var baseurl:String{
    get{
        UserDefaults.standard.string(forKey: "baseurl") ?? "http://47.107.38.1"
    }
    set{
        UserDefaults.standard.set(newValue, forKey: "baseurl")
    }
    
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
            return log("DM No request created yet.")
        }
        var body = ""
        
        if let instream:String = String(data: try! Data.init(reading: request.httpBodyStream), encoding: .utf8){
            body = instream.removingPercentEncoding ?? "--"
            body = body.split(separator: "&").map{$0}.joined(separator: "\n\t")
        }
        
        let requestDescription = "\(method) \(url.absoluteString)"
        let state  =  response.map { "\(requestDescription) (\($0.statusCode))" } ?? requestDescription
        let result = json.description
        let icon = (response?.statusCode == 200) ? "🧘‍♂️" : " 🧱"
        
        log(
            
            """
            *****************\(icon)******************
            url:\(state)
            header:\(headers)
            body:\(body)
            result:\(result)
            ******************************************
            """
        )
#endif
        
    }
    
    
    open func responseModel<T>(_ type: T.Type, callback:@escaping (Result<T,BaseError>)  ->  ()) {
        
        self.responseJSON {[weak self] (response) in
            self?.debugLog(response)
            switch response.result {
            case .success(let value):
                guard  let apidata = APIData<T>.deserialize(from: value as? [String:Any]) else{
                    callback(.failure(BaseError(code: -1, msg: "json error")))
                    return
                }
                
                if apidata.code == 0 {
                    callback(.success(apidata.data!))
                }else{
                    callback(.failure(BaseError(code: apidata.code, msg: apidata.message )))
                }
                
                
            case .failure(let error):
                self?.log("🐬 \(error)")
                callback(.failure(BaseError(code: -200, msg: "http error")))
                
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

extension Data {
    
    init(reading input: InputStream?) throws {
        
        
        self.init()
        guard let stream = input else {
            return
        }
        stream.open()
        defer {
            stream.close()
        }
        
        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer {
            buffer.deallocate()
        }
        while stream.hasBytesAvailable {
            let read = stream.read(buffer, maxLength: bufferSize)
            if read < 0 {
                //Stream error occured
                throw stream.streamError!
            } else if read == 0 {
                //EOF
                break
            }
            self.append(buffer, count: read)
        }
    }
}


extension Session {
    
    func af_select(_ sql:String, callback:@escaping (Result<[[String:Any]],BaseError>)  ->  ())  {
        let url = "\(baseurl)/select"
        let param = ["sql":sql]
        log("🐶："+sql)
        self.request(url, method: .post,
                     parameters: param,
                     encoder: JSONParameterEncoder.default,
                     requestModifier: { urlRequest in
            urlRequest.timeoutInterval = 15
        }
        )
            .responseModel([[String:Any]].self, callback: callback)
    }
    
    func af_update(_ sql:String, callback:@escaping (Result<[String:Any], BaseError>)  ->  ())  {
        log("🐒："+sql)
        let url = "\(baseurl)/update"
        let param = ["sql":sql]
        self.request(url,
                     method: .post,
                     parameters: param,
                     encoder: JSONParameterEncoder.default,
                     requestModifier: { urlRequest in
            urlRequest.timeoutInterval = 15
        }
        )
            .responseModel([String:Any].self, callback: callback)
    }
    
    func select(_ sql:String) -> DataRequest  {
        let url = "\(baseurl)/select"
        let param = ["sql":sql]
        log("🐶："+sql)
        return self.request(url, method: .post,
                            parameters: param,
                            encoder: JSONParameterEncoder.default,
                            requestModifier: { urlRequest in
            urlRequest.timeoutInterval = 15
        }
        )
        
    }
    
    func update(_ sql:String) -> DataRequest  {
        log("🐒："+sql)
        let url = "\(baseurl)/update"
        let param = ["sql":sql]
        return  self.request(url,
                             method: .post,
                             parameters: param,
                             encoder: JSONParameterEncoder.default,
                             requestModifier: { urlRequest in
            urlRequest.timeoutInterval = 15
        }
        )
        
    }
}


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
    UserDefaults.standard.string(forKey: "baseurl") ?? "http://47.107.38.1"
}

typealias ResultClosure<T> = (Result<T, APIError>)  ->  ()




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
        var body = ""
        if let instream:String = String(data: try! Data.init(reading: request.httpBodyStream!), encoding: .utf8){
            body = instream.removingPercentEncoding ?? "--"
            body = body.split(separator: "&").map{$0}.joined(separator: "\n\t")
        }

        let requestDescription = "\(method) \(url.absoluteString)"
        let state  =  response.map { "\(requestDescription) (\($0.statusCode))" } ?? requestDescription
        let result = json.description
        let icon = (response?.statusCode == 200) ? "🧘‍♂️" : " 🧱"
        let arr =
        print(
           
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
    

    open func responseModel<T>(_ type: T.Type, callback:@escaping (Result<T, Error>)  ->  ()) {
        
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

extension Data {
    init(reading input: InputStream) throws {
        self.init()
        input.open()
        defer {
            input.close()
        }

        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer {
            buffer.deallocate()
        }
        while input.hasBytesAvailable {
            let read = input.read(buffer, maxLength: bufferSize)
            if read < 0 {
                //Stream error occured
                throw input.streamError!
            } else if read == 0 {
                //EOF
                break
            }
            self.append(buffer, count: read)
        }
    }
}

import UIKit
import Foundation
import Combine
import Alamofire
import PlaygroundSupport


PlaygroundPage.currentPage.needsIndefiniteExecution = true
var greeting = "Hello, playground"

let sql = """
    SELECT t1.name,t1.code,t2.status,t2.followFROM  stockbasic t1
    LEFT JOIN  (select * from etffollow e where e.userId=1)  t2 ON t1.code=t2.code
    ORDER BY follow,name DESC
    LIMIT 20 OFFSET 0
    """

let url = "\(baseurl)/select"
let param = ["sql":sql]
AF.request(url, method: .post, parameters: param, encoder: JSONParameterEncoder.default)
    .responseString { str in
        print(str)
        PlaygroundPage.current.finishExecution()
    }









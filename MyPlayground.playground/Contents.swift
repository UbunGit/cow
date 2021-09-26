import UIKit
import Foundation
import Combine
import Alamofire
import PlaygroundSupport


PlaygroundPage.currentPage.needsIndefiniteExecution = true
var greeting = "Hello, playground"

let sql = """
    INSERT INTO scheme_template (id,name,des)
    VALUES (1,'Kirogi','根据排行榜推荐')
    """

let url = "\(baseurl)/update"
let param = ["sql":sql]
AF.request(url, method: .post, parameters: param, encoder: JSONParameterEncoder.default)
    .responseString { str in
        print(str)
        PlaygroundPage.current.finishExecution()
    }









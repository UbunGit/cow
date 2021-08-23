//
//  lib.swift
//  Cow
//
//  Created by admin on 2021/8/20.
//

import Foundation
/*:
 ma
 */
func lib_ma(_ ma:Int, closes:[Double]) -> [Double]  {
    
    closes.enumerated().map { (index,item) in
        let idx = index+1
        let begin = (idx-ma >= 0) ? idx-ma : 0
        let c = (idx-begin).double()
        
        return closes[begin..<idx].reduce(0.0) {
            $0.double() + $1.double()
        }/c
    }
}

public extension Array where Element == [String:Any] {
    
    
    func lib_muma( _ mas:[Int] = [5,10,20,30,60], cloume:String) ->[[String:Any]] {
        
        return self.enumerated().map { (index, item)->[String:Any] in
            var result:[String:Any] = [:]
            result["code"] = item["code"]
            result["date"] = item["date"]
            for ma in mas{
                let idx = index+1
                let begin = (idx-ma >= 0) ? idx-ma : 0
                let c = (idx-begin).double()
                let value = self[begin..<idx].reduce(0.0) {
                    let double1 = $0
                    let double2 = $1[cloume].double()
                    return double1 + double2
                }/c
                result["ma\(ma)"] = value
            }
            return result
        }
        
    }
}


/*:
 归一化 0~1
 */
func lib_scaler(_ x: [Double]) -> [Double]  {
    
    func scaler(max:Double,min:Double, num:Double) -> Double{
        let c = num-min
        let v = max-min
        return c/v
    }
    
    let max = x.max()!.double()
    let min = x.min()!.double()
    
    let r =  x.map {
        scaler(max: max, min:min, num: $0.double()) }
    return r
}

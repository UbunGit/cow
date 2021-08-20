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

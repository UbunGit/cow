import UIKit
import SQLite

var greeting = "Hello, playground"

var mirror = Mirror(reflecting: StockBasic())

print("对象类型：\(mirror.subjectType)")
print("对象属性个数：\(mirror.children.count)")
print("对象的属性及属性值")
for child in mirror.children {
    print("\(child.label!)---\(child.value)")
}







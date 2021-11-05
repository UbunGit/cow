//
//  ConfigDor.swift
//  Cow
//
//  Created by admin on 2021/9/29.
//

import Foundation
import DoraemonKit
extension AppDelegate{
    func configDor(){
        DoraemonManager.shareInstance().install(withPid: "db4146378948b4a04e74c1172ce45590")
        DoraemonManager.shareInstance().addPlugin(withTitle: "IP地址设置", icon: "doraemon_ui", desc: "IP地址设置", pluginName: "IP地址设置", atModule: "自定义") { _ in
            let vc = IPURLConfigVC()
            DoraemonHomeWindow.openPlugin(vc)
            
        }
        
    }
}

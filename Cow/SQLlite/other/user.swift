//
//  user.swift
//  Cow
//
//  Created by admin on 2021/8/28.
//

import Foundation
extension SqlliteManage{
    func sql_register(userName:String,passWord:String) ->String{
        """
        INSERT  INTO 'user' (name,psw) VALUES ('\(userName)','\(passWord)')
        """
    }
    func sql_login(userName:String,passWord:String) ->String{
        """
        select * from user where name='\(userName)' and psw='\(passWord)'
        """
    }
    
}

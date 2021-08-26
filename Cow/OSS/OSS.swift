//
//  OSS.swift
//  Cow
//
//  Created by admin on 2021/8/25.
//

import Foundation
import Alamofire
import Magicbox

class OSS{
    private var downurl:String? = nil
    private var downloadRequest:DownloadRequest!
    
    let fileManager = FileManager.default
    var cachefile:String{
        guard let md5 = downurl?.md5() else {
            return "\(KDocumnetPath)/cachefile"
        }
        return "\(KDocumnetPath)/" + md5
    }
    var savefile:String = "\(KDocumnetPath)/sqlite/sqlite.db"
    var downfile = "\(KDocumnetPath)/down"
    
    var cacheData: Data? {
        let data =  try? Data(contentsOf:URL(fileURLWithPath:cachefile))
        return data
    }
   
    
    //指定下载路径
    let destination:DownloadRequest.Destination = {( _, response) in
        let downfile = URL(fileURLWithPath: "\(KDocumnetPath)/down")
        return (downfile,[.removePreviousFile,.createIntermediateDirectories])
    }
    func downloadProgress(progress:Progress){
        print("当前进度:\(progress.fractionCompleted*100)%")
    }
    
    func downloadResponse(response:AFDownloadResponse<Data>){
        switch response.result {
        case .success( _):
            print("下载完成")
            do{
                if fileManager.fileExists(atPath: savefile) {
                    try self.fileManager.removeItem(at: URL(fileURLWithPath:savefile))
                }
                try self.fileManager.moveItem(at: URL(fileURLWithPath:downfile), to:URL(fileURLWithPath:savefile) )
                if fileManager.fileExists(atPath: cachefile) {
                    try self.fileManager.removeItem(at: URL(fileURLWithPath:cachefile))
                }
            }catch{
                print("\(error)")
            }
            

        case .failure(_):
            guard let cdata = response.resumeData else {
                return
            }
            do {
                try cdata.write(to: URL(fileURLWithPath:cachefile))
            } catch  {
                print("\(error)")
            }
            break
        }
       
    }
    
     func downloadSql(url:String="https://ubungit.oss-cn-shenzhen.aliyuncs.com/sqlite.db"){
        downurl = url
        if let cancelledData = self.cacheData{
            downloadRequest = AF.download(resumingWith: cancelledData,to: destination)
            downloadRequest.downloadProgress(closure: downloadProgress)
            downloadRequest.responseData(completionHandler: self.downloadResponse(response:))
        }else{
            //开始下载
            downloadRequest = AF.download(url, to: self.destination)
            downloadRequest.downloadProgress(closure: downloadProgress)
            downloadRequest.responseData(completionHandler: downloadResponse)
        }
        
    }
}

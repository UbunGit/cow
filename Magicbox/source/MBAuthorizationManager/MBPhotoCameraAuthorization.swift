//
//  CYYAuthorizationManage.swift
//  CYYComponent
//
//  Created by admin on 2021/8/3.
//

import Foundation
import Photos
import UIKit

public protocol MBPhotoCameraAuthorization:UIViewController{
    // 相册异常提示vc
    var exPhotoClosure:(PHAuthorizationStatus)->(){get}
    
    // 拍照异常提示vc
    var exCameraClosure:(AVAuthorizationStatus)->(){get}
    
    /**
     相册权限获取 允许状态调用闭包
     */
    func mb_photosAuthorization(_ closure:@escaping ()->())
    
    /**
     相机权限获取 允许状态调用闭包
     */
    func mb_cameraAuthorization(_ closure:@escaping ()->())

}

public extension MBPhotoCameraAuthorization{

    var exPhotoClosure:(PHAuthorizationStatus)->(){
        {state in
            DispatchQueue.main.async {
                let defualPhotosVC = PhotosAuthorZationVC()
                self.present(defualPhotosVC, animated: true, completion: nil)
            }
            
        }
    }
    var exCameraClosure:(AVAuthorizationStatus)->(){
        {state in
            DispatchQueue.main.async {
                let defualCameraVC = CameraAuthorZationVC()
                self.present(defualCameraVC, animated: true, completion: nil)
            }
         
        }
    }
    
    
    var excameravc:UIViewController?{
        return CameraAuthorZationVC()
    }
    
    /**
     选择图片
     */
    func mb_choseImage(_ closure:@escaping (UIImagePickerController.SourceType)->()){
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction.init(title: "拍照", style: .default) { action in
            
            self.mb_cameraAuthorization {
                closure(.camera)
            }
        }
        let photo = UIAlertAction.init(title: "从手机相册选取", style: .default) { action in
            self.mb_photosAuthorization {
                closure(.photoLibrary)
            }
        }
        let cancel = UIAlertAction.init(title: "取消", style: .cancel) { action in
            
        }
        alert.addAction(photo)
        alert.addAction(camera)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)

    }
    
    /**
     相册权限获取 允许状态调用闭包
     */
    func mb_photosAuthorization(_ closure:@escaping ()->()){
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    self.mb_photosAuthorization(closure)
                }
                break
            case .restricted:
                // 无权更改此应用程序状态
                self.exPhotoClosure(status)
                break
            case .denied: //用户明确拒绝相册权限
                self.exPhotoClosure(status)
                break
            case .authorized://已获取相册权限
                closure()
                break
            case .limited:// iOS 14新推出的的权限 允许用户所选
                closure()
                break
                
            default: break
                
            }
        }else{
            UIView.error("当前设备不支持打开相册")
        }
    }
    
    /**
     相机权限获取 允许状态调用闭包
     */
    func mb_cameraAuthorization(_ closure:@escaping ()->()){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status {
            case .notDetermined:
                //用户还未作出选择，主动弹框询问
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    self.mb_cameraAuthorization(closure)
                }
                break
            case .restricted:
                // 无权更改此应用程序状态
                self.exCameraClosure(status)
                break
            case .denied:
                // 用户明确拒绝相册权限
                self.exCameraClosure(status)
                break
            case .authorized:
                //已获取相机权限
                closure()
            default:
                self.exCameraClosure(status)
            }
        }else{
            UIView.error("当前设备不支持打开相机")
        }
    }

    
   
}

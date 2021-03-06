//
//  AppDelegate.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import StoreKit
import RxSwift

@UIApplicationMain
class HCAppDelegate: UIResponder, UIApplicationDelegate {

     var window: UIWindow?

    public var deviceToken: String = ""
    
    public var isAuthorizedPush: Bool = false
    
    public var allowRotation: Bool = false
    
    private var disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        TYFileManager.share
        
        HCHelper.setupHelper()
        
        DbManager.dbSetup()
        
//        setupUM(launchOptions: launchOptions)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.checkVersion()
        }

        window?.backgroundColor = .white
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
                
//        if userDefault.lanuchStatue != vLaunch { AppLaunchView().show() }
        return true
    }
}

import Alamofire
extension HCAppDelegate {
    
    private func checkVersion() {
        _ = HCProvider.request(.version)
            .map(model: AppVersionModel.self)
            .subscribe(onSuccess: { res in
                
                if Bundle.main.isNewest(version: res.versionName) == false
                {
                    NoticesCenter.alert(title: "有最新版本可以升级", message: "", cancleTitle: "取消", okTitle: "去更新", callBackOK: {
                        let storeProductVC = SKStoreProductViewController()
                        storeProductVC.delegate = self
                        storeProductVC.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: "1241588748"],
                                                   completionBlock:
                            { (flag, error) in
                                if flag
                                {
                                    NSObject().visibleViewController?.present(storeProductVC, animated: true, completion: nil)
                                }
                        })
                    })
                }
            }) { error in
                print("--- \(error) -- 已是最新版本")
            }
    }
}

extension HCAppDelegate: SKStoreProductViewControllerDelegate {
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}


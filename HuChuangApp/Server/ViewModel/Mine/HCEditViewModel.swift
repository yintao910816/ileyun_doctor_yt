//
//  EditViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2019/2/14.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCEditUserIconViewModel: BaseViewModel {
    
    let userIcon = PublishSubject<String?>()
    let finishEdit = PublishSubject<UIImage?>()

    override init() {
        super.init()

        finishEdit
            .filter({ [unowned self] image -> Bool in
                if image == nil {
                    self.hud.failureHidden("请选择头像")
                    return false
                }
                return true
            })
            ._doNext(forNotice: hud)
            .flatMap({ [unowned self] image -> Observable<HCUserModel> in
                return self.requestEditIcon(icon: image!).concatMap{ self.requestUpdateInfo(iconPath: $0.filePath) }
            })
            .subscribe(onNext: { [weak self] user in
                HCHelper.saveLogin(user: user)
                self?.hud.noticeHidden()
                self?.popSubject.onNext(Void())
                }, onError: { [weak self] error in
                    self?.hud.failureHidden(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)

        reloadSubject.subscribe(onNext: { [weak self] _ in
            self?.userIcon.onNext(HCHelper.share.userInfoModel?.headPath)
        })
            .disposed(by: disposeBag)
    }

    private func requestEditIcon(icon: UIImage) ->Observable<HCFileUploadModel>{
        return HCProvider.request(.uploadFile(data: icon.jpegData(compressionQuality: 0.5) ?? Data(), fileType: .image))
            .map(model: HCFileUploadModel.self)
            .asObservable()
    }
    
    private func requestUpdateInfo(iconPath: String) ->Observable<HCUserModel> {
        guard let user = HCHelper.share.userInfoModel else {
            hud.failureHidden("用户信息获取失败，请重新登录") {
                HCHelper.presentLogin()
            }
            return Observable.empty()
        }

        if var params = user.toJSON() {
            params["headPath"] = iconPath
            return HCProvider.request(.updateExtInfo(params: params))
                .map(model: HCUserModel.self)
                .asObservable()
        }
        
        return Observable.empty()
    }
    
}

class HCEditNickNameViewModel: BaseViewModel {
    
    let nickName = PublishSubject<String?>()
    let finishEdit = PublishSubject<String>()
    
    override init() {
        super.init()
        
        finishEdit
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [weak self] nickName in
                self?.requestUpdateUserInfo(nickName: nickName)
            })
            .disposed(by: disposeBag)
        
        reloadSubject.subscribe(onNext: { [weak self] _ in
            self?.nickName.onNext(HCHelper.share.userInfoModel?.name)
        })
            .disposed(by: disposeBag)
    }
    
    private func requestUpdateUserInfo(nickName: String) {
        guard let user = HCHelper.share.userInfoModel else {
            hud.failureHidden("用户信息获取失败，请重新登录") {
                HCHelper.presentLogin()
            }
            return
        }
        let params: [String: String] = ["patientId": user.id,
                                        "name": nickName,
                                        "sex": "\(user.sex)",
                                        "headPath": user.headPath,
                                        "synopsis": user.departmentName,
                                        "birthday": user.birthday,
                                        "areaCode": user.areaCode]

        HCProvider.request(.updateInfo(param: params))
            .map(model: HCUserModel.self)
            .subscribe(onSuccess: { [weak self] user in
                HCHelper.saveLogin(user: user)
                self?.hud.noticeHidden()
                self?.popSubject.onNext(Void())
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
            }
            .disposed(by: disposeBag)
    }
}

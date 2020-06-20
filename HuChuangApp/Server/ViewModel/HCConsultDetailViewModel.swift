//
//  HCConsultDetailViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/23.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift

class HCConsultDetailViewModel: RefreshVM<SectionModel<HCConsultDetailItemModel, HCConsultDetailConsultListModel>> {
    
    private var memberId: String = ""
    private var id: String = ""

    private var hasStartTimer: Bool = false
    private var timer: CountdownTimer!

    public let timeObser = Variable("30:00")
    public let questionObser = Variable("1/1")
    /// 是否已结束回复
    public let isEndReplyObser = Variable(true)

    /// 图片回复
    public let sendImageSubject = PublishSubject<UIImage>()
    /// 语音回复
    public let sendAudioSubject = PublishSubject<(Data, UInt)>()
    /// 文字回复
    public let sendTextSubject = PublishSubject<String>()
    
    public func customDeinit() {
        timer.timerRemove()
        timer = nil
    }
    
    init(memberId: String, id: String) {
        super.init()
        
        self.memberId = memberId
        self.id = id
        
        sendImageSubject
            ._doNext(forNotice: hud)
            .flatMap { [unowned self] image -> Observable<HCFileUploadModel> in
            if let data = image.jpegData(compressionQuality: 0.5) {
                return self.uploadFile(data: data, type: .image)
            }
            return Observable.just(HCFileUploadModel())
        }
        .concatMap { [weak self] file -> Observable<ResponseModel> in
            guard let strongSelf = self else { return Observable.just(ResponseModel()) }
            return strongSelf.submitReply(content: "", filePath: file.filePath, bak: "")
        }
        .subscribe(onNext: { [weak self] res in
            PrintLog("图片回复结果：\(res.message)")
            if RequestCode(rawValue: res.code) == RequestCode.success {
                if self?.timer.isStart == false {
                    self?.timer.timerStar()
                }
                self?.requestData(true)
            }else {
                self?.hud.failureHidden(res.message)
            }
        })
            .disposed(by: disposeBag)
        
        sendAudioSubject
            ._doNext(forNotice: hud)
            .flatMap { [unowned self] data -> Observable<(HCFileUploadModel, UInt)> in
                return self.uploadFile(data: data.0, type: .audio)
                    .map{ ($0, data.1) }
        }
        .concatMap { [weak self] data -> Observable<ResponseModel> in
            guard let strongSelf = self else { return Observable.just(ResponseModel()) }
            return strongSelf.submitReply(content: "", filePath: data.0.filePath, bak: "\(data.1)")
        }
        .subscribe(onNext: { [weak self] res in
            PrintLog("语音回复结果：\(res.message)")
            if RequestCode(rawValue: res.code) == RequestCode.success {
                if self?.timer.isStart == false {
                    self?.timer.timerStar()
                }
                self?.requestData(true)
            }else {
                self?.hud.failureHidden(res.message)
            }
        })
            .disposed(by: disposeBag)
    
        sendTextSubject
            ._doNext(forNotice: hud)
            .flatMap{ [unowned self] in self.submitReply(content: $0, filePath: "", bak: "") }
            .subscribe(onNext: { [weak self] res in
                PrintLog("文字回复结果：\(res.message)")
                if RequestCode(rawValue: res.code) == RequestCode.success {
                    if self?.timer.isStart == false {
                        self?.timer.timerStar()
                    }
                    self?.requestData(true)
                }else {
                    self?.hud.failureHidden(res.message)
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        HCProvider.request(.getConsultDetail(memberId: memberId, id: id))
            .map(model: HCConsultDetailModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.dealRequestData(refresh:refresh, data: $0)
            }) { [weak self] in
                self?.revertCurrentPageAndRefreshStatus()
                self?.hud.failureHidden(self?.errorMessage($0))
        }
            .disposed(by: disposeBag)
    }

    private func dealRequestData(refresh: Bool, data: HCConsultDetailModel) {
        var sectionDatas: [SectionModel<HCConsultDetailItemModel, HCConsultDetailConsultListModel>] = []
        
        var isEndReply: Bool = false
        var startDate: String = ""
        // 进入单聊界面，records只可能有一条数据
        if let dataList = data.records.first {
            var consultsList: [HCConsultDetailConsultListModel] = []
            consultsList.append(contentsOf: dataList.consultList)
            
            if dataList.content == dataList.consultList.first?.content {
                consultsList.remove(at: 0)
            }

            if dataList.startDate.count > 0 {
                startDate = dataList.startDate
                let starDateModel = HCConsultDetailConsultListModel()
                starDateModel.cellIdentifier = HCConsultDetailTimeCell_identifier
                starDateModel.timeString = "开始回复 \(dataList.startDate)"
                consultsList.insert(starDateModel, at: 0)
            }
            
            if dataList.endDate.count > 0 {
                let endDateModel = HCConsultDetailConsultListModel()
                endDateModel.cellIdentifier = HCConsultDetailTimeCell_identifier
                endDateModel.timeString = "结束回复 \(dataList.endDate)"
                consultsList.append(endDateModel)
                
                isEndReply = true
            }
            
            sectionDatas.append(SectionModel.init(model: dataList, items: consultsList))

        }
        
        questionObser.value = data.records.last?.question ?? "1/1"

        if !hasStartTimer {
            dealReplyTime(startTime: startDate, isEndReply: isEndReply)
        }
        
        updateRefresh(refresh, sectionDatas, data.pages)
        hud.noticeHidden()
    }
    
    private func dealReplyTime(startTime: String, isEndReply: Bool) {
        
        isEndReplyObser.value = isEndReply
        
        if isEndReply {
           timeObser.value = "已结束"
        }else {
            if timer != nil {
                timer.timerRemove()
            }
            
            var count: Int = 0
            var starTimerNow: Bool = false
            let totleTimer: Int = 30 * 60
            if startTime.count > 0 {
                count = totleTimer - TYDateCalculate.seconds(of: startTime)
                timeObser.value = TYDateCalculate.getHHMMSSFormSS(seconds: count)
                starTimerNow = true
            }else {
                count = 30 * 60
                timeObser.value = "30:00"
            }
            if count > 0 {
                timer = CountdownTimer.init(totleCount: count)
                timer.showText.asDriver()
                    .skip(1)
                    .drive(onNext: { [weak self] second in
                        if second == 0 {
                            self?.timeObser.value = "已结束"
                            self?.isEndReplyObser.value = true
                        }else {
                            self?.timeObser.value = TYDateCalculate.getHHMMSSFormSS(seconds: second)
                        }
                    })
                    .disposed(by: disposeBag)
                if starTimerNow {
                    timer.timerStar()
                }
            }else {
                timeObser.value = "已结束"
            }
        }
        
        hasStartTimer = true
    }
}

//MARK: - 回复相关
extension HCConsultDetailViewModel {
    
    private func uploadFile(data: Data, type: HCFileUploadType) ->Observable<HCFileUploadModel> {
        return HCProvider.request(.uploadFile(data: data, fileType: type))
            .map(model: HCFileUploadModel.self)
            .asObservable()
    }

    private func submitReply(content: String, filePath: String, bak: String) ->Observable<ResponseModel> {
        return HCProvider.request(.replyConsult(content: content, filePath: filePath, bak: bak, consultId: id))
            .mapResponse()
            .asObservable()
    }
}

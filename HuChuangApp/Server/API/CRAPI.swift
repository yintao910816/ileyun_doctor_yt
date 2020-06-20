//
//  SRUserAPI.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/11/25.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import Foundation
import Moya

/// 文章栏目编码
enum HCWebCmsType: String {
    /// 首页-好孕课堂
    case webCms001 = "webCms001"
}

enum HCMergeProOpType: String {
    /// 标记月经
    case menstruationDate = "menstruationDate"
    /// 添加同房记录
    case knewRecord = "knewRecord"
    /// 添加排卵日
    case ovulation = "ovulation"
    /// 添加体温记录
    case temperature = "temperature"
}

enum H5Type: String {
    /// 好孕消息
    case goodNews = "goodnews"
    /// 消息中心
    case notification = "notification"
    /// 公告
    case announce = "announce"
    /// 认证
    case bindHos = "bindHos"
    /// 绑定成功
    case succBind = "succBind"
    /// 问诊记录
    case consultRecord = "consultRecord"
    /// 我的预约
    case memberSubscribe = "memberSubscribe"
    /// 我的收藏
    case memberCollect = "memberCollect"
    /// 用户反馈
    case memberFeedback = "memberFeedback"
    /// cms功能：readNumber=阅读量,modifyDate=发布时间，hrefUrl=调整地址
    case hrefUrl = "hrefUrl"
    /// 医生咨询
    case doctorConsult = "doctorConsult"
    /// 患者咨询
    case patientConsult = "patientConsult"
    /// 开发中
    case underDev = "underDev"
    /// 咨询医生信息
    case doctorHome = "doctorHome"
    /// 快速问诊
    case doctorCs = "DoctorCs"
    /// 问诊记录
    case doctorComments = "doctorComments"
    /// 我的关注
    case myFocused = "myFocused"
    /// 我的搜藏
    case myCollection = "myCollection"
    /// 我的卡卷
    case voucherCenter = "myCoupon"
    /// 经期设置
    case menstrualSetting = "MenstrualSetting"
    /// 个人中心健康档案
    case healthRecordsUser = "healthRecords"
    /// 用户反馈
    case feedback = "feedback"
    /// 帮助中心
    case helpCenter = "NounParsing"
    /// 通知中心
    case noticeAndMessage = "noticeAndMessage"
    /// 订单
    case csRecord = "CsRecord"
    /// 我的医生
    case myDoctor = "myDoctor"
    /// 分享app给好友
    case share = "share"
        
    func getLocalUrl(needToken: Bool = true) ->String {
        if needToken {
            return "\(APIAssistance.baseH5Host)#/\(rawValue)?token=\(userDefault.token)"
        }
        return "\(APIAssistance.baseH5Host)#/\(rawValue)"
//        switch self {
//        case .healthRecordsUser:
//            return "\(APIAssistance.baseH5Host)#/HealthRecords"
//        case .doctorHome:
//            return "\(APIAssistance.baseH5Host)#/doctorHome"
////        case .csRecord:
////            return "\(APIAssistance.baseH5Host)#/csRecord?token=\(userDefault.token)"
//        case .doctorCs:
//            return "\(APIAssistance.baseH5Host)#/DoctorCs?token=\(userDefault.token)"
//        default:
//            return ""
//        }
    }
}

/// 搜索的内容类型
/**
 1，searchModule = doctor 为 医生模块，
 2，searchModule = course 为课程，
 3，searchModule = article 为文章）
 4，searchModule 等于 空 为 全部
 */
enum HCsearchModule: String {
    case doctor = "doctor"
    case course = "course"
    case article = "article"
    case all = ""
}

/// 文件类型
enum HCFileUploadType: String {
    case image = "image/jpeg"
    case audio = "audio/mp3"
    
    public var getSuffix: String {
        switch self {
        case .image:
            return ".jpg"
        case .audio:
            return ".mp3"
        }
    }
}

//MARK:
//MARK: 接口定义
enum API{
    /// 验证码登录
    case login(mobile: String, smsCode: String)
    /// 账号密码登录
    case loginTwo(account: String, psd: String)
    /// 获取用户信息
    case selectInfo
    /// 首页banner
    case selectBanner
    /// 咨询列表 sort - 0顺序1倒叙
    case consultList(sort: Int, pageNum: Int, pageSize: Int)
    /// 咨询详情
    case getConsultDetail(memberId: String, id: String)
    /// 咨询回复 - filePath：图片或录音文件地址  bak：录音时长
    case replyConsult(content: String, filePath: String, bak: String, consultId: String)
    /// 咨询退回
    case withdrawConsult(orderSn: String)
    
    /// 患者管理-分组
    case groupTagMemberList
    /// 添加标签
    case addUserTag(tagName: String, clinicId: String)
    /// 获取已有标签
    case getUserTagList(memberId: String)
    /// 设置患者标签
    case addUserMemberTags(memberId: String, tagName: String, id: String)
    /// 删除患者标签
    case removeUserTag(memberId: String, id: String)

    /// 编辑患者备注
    case updateConsultBlack(memberId: String, userId: String, bak: String, black: Bool)
    
    /// 患者搜索
    case searchData(searchWords: String)
    /// 患者健康档案
    case getHealthArchives(memberId: String)
    /// 周期档案
    case getPatientCoupleInfo(memberId: String)
    /// 个人账单-某月
    case getMonthBillInfo(year: Int, month: Int, pageNum: Int, pageSize: Int)
    
    /// 向app服务器注册友盟token
    case UMAdd(deviceToken: String)

    /// 获取验证码
    case validateCode(mobile: String)
    /// 绑定微信
    case bindAuthMember(userInfo: UMSocialUserInfoResponse, mobile: String, smsCode: String)
    /// 修改用户信息
    case updateInfo(param: [String: String])
    /// 首页功能列表
    case functionList
    /// 好消息
    case goodNews
    /// 首页通知消息
    case noticeList(type: String, pageNum: Int, pageSize: Int)
    /// 获取未读消息
    case messageUnreadCount
    case article(id: String)
    /// 今日知识点击更新阅读量
    case increReading(id: String)
        
    /// 获取h5地址
    case unitSetting(type: H5Type)
    
    /// 检查版本更新
    case version
    
    /// 文件上传
    case uploadFile(data: Data, fileType: HCFileUploadType)
}

//MARK:
//MARK: TargetType 协议
extension API: TargetType{
    
    var path: String{
        switch self {
        case .login(_):
            return "api/login/login"
        case .loginTwo(_):
            return "api/login/loginTwo"
        case .selectInfo:
            return "api/user/selectInfo"
        case .selectBanner:
            return "index/bannerList"
        case .consultList(_):
            return "api/patientConsult/getConsultList"
        case .getConsultDetail(_):
            return "api/patientConsult/getConsultDetailWx"
        case .replyConsult(_, _, _, _):
            return "api/patientConsult/replyConsult"
        case .withdrawConsult(_):
            return "api/patientConsult/withdrawConsult"
        case .getMonthBillInfo(_):
            return "patientConsult/getMonthBillInfo"
        case .getHealthArchives:
            return "api/patientConsult/getHealthArchives"
        case .getPatientCoupleInfo(_):
            return "api/patientConsult/getPatientCoupleInfo"
            
        case .addUserTag(_, _):
            return "api/patientConsult/addUserTag"
        case .getUserTagList(_):
            return "api/patientConsult/getUserTagList"
        case .addUserMemberTags(_):
            return "api/patientConsult/addUserMemberTags"
        case .removeUserTag(_, _):
            return "api/patientConsult/removeUserTag"
        case .groupTagMemberList:
            return "api/patientInfo/groupTagMemberList"
            
        case .updateConsultBlack(_, _, _, _):
            return "api/patientConsult/updateConsultBlackWx"
            
        case .searchData(_):
            return "api/search/searchData"
            
        case .uploadFile(_):
            return "api/upload/fileSingle"
            
        case .UMAdd(_):
            return "api/umeng/add"
        case .validateCode(_):
            return "api/login/validateCode"
        case .bindAuthMember(_):
            return "api/login/bindAuthMember"
        case .updateInfo(_):
            return "api/member/updateInfo"
        case .functionList:
            return "api/index/select"
        case .noticeList(_):
            return "api/index/noticeList"
        case .messageUnreadCount:
            return "api/messageCenter/unread"
        case .goodNews:
            return "api/index/goodNews"
        case .article(_):
            return "api/index/article"
        case .increReading(_):
            return "api/index/increReading"
        case .unitSetting(_):
            return "api/index/unitSetting"
        case .version:
            return "api/apk/version"
            
        }
    }
    
    var baseURL: URL{ return APIAssistance.baseURL(API: self) }
    
    var task: Task {
        switch self {
        case .uploadFile(let data, let fileType):
            //根据当前时间设置图片上传时候的名字
            let timeInterval: TimeInterval = Date().timeIntervalSince1970
            let dateStr = "\(Int(timeInterval))\(fileType.getSuffix)"
            let formData = MultipartFormData(provider: .data(data), name: "file", fileName: dateStr, mimeType: fileType.rawValue)
            return .uploadMultipart([formData])
        case .version:
            return .requestParameters(parameters: ["type": "ios", "packageName": "com.huchuang.guangsanuser"],
                                      encoding: URLEncoding.default)
        default:
            if let _parameters = parameters {
                guard let jsonData = try? JSONSerialization.data(withJSONObject: _parameters, options: []) else {
                    return .requestPlain
                }
                return method == .get ? .requestParameters(parameters: _parameters, encoding: URLEncoding.default) : .requestCompositeData(bodyData: jsonData, urlParameters: [:])
            }else {
                return .requestPlain
            }
        }
    }
    
    var method: Moya.Method { return APIAssistance.mothed(API: self) }
    
    var sampleData: Data{ return Data() }
    
    var validate: Bool { return false }
    
    var headers: [String : String]? {
        var contentType: String = "application/json; charset=utf-8"
        switch self {
        case .uploadFile(_, let fileType):
            contentType = fileType.rawValue
        default:
            break
        }

        let userAgent: String = "\(Bundle.main.bundleIdentifier),\(Bundle.main.version),\(UIDevice.iosVersion),\(UIDevice.modelName)"


        let customHeaders: [String: String] = ["token": userDefault.token,
                                               "User-Agent": userAgent,
                                               "unitId": userDefault.unitId,
                                               "Content-Type": contentType,
                                               "Accept": "application/json"]
        PrintLog("request headers -- \(customHeaders)")
        return customHeaders
    }
    
}

//MARK:
//MARK: 请求参数配置
extension API {
    
    private var parameters: [String: Any]? {
        var params = [String: Any]()
        switch self {
        case .login(let mobile, let smsCode):
            params["mobile"] = mobile
            params["smsCode"] = smsCode
        case .loginTwo(let account, let psd):
            params["account"] = account
            params["psd"] = psd
        case .consultList(let sort, let pageNum, let pageSize):
            params["sort"] = sort
            params["pageNum"] = pageNum
            params["pageSize"] = pageSize
        case .getConsultDetail(let memberId, let id):
            params["memberId"] = memberId
            params["id"] = id
        case .replyConsult(let content, let filePath, let bak, let consultId):
            params["content"] = content
            params["filePath"] = filePath
            params["bak"] = bak
            params["consultId"] = consultId
        case .withdrawConsult(let orderSn):
            params["orderSn"] = orderSn

        case .addUserTag(let tagName, let clinicId):
            params["tagName"] = tagName
            params["clinicId"] = clinicId
        case .getUserTagList(let memberId):
            params["memberId"] = memberId
        case .addUserMemberTags(let memberId, let tagName, let id):
            params["memberId"] = memberId
            params["tagName"] = tagName
            params["id"] = id
        case .removeUserTag(let memberId, let id):
            params["memberId"] = memberId
            params["id"] = id

        case .updateConsultBlack(let memberId, let userId, let bak, let black):
            params["memberId"] = memberId
            params["userId"] = userId
            params["bak"] = bak
            params["black"] = black

        case .getMonthBillInfo(let year, let month, let pageNum, let pageSize):
            params["year"] = year
            params["month"] = month
            params["pageNum"] = pageNum
            params["pageSize"] = pageSize
        case .searchData(let searchWords):
            params["searchWords"] = searchWords
        case .getHealthArchives(let memberId):
            params["memberId"] = memberId
        case .getPatientCoupleInfo(let memberId):
            params["memberId"] = memberId
        default:
            break
        }
        return params
    }
}


//func stubbedResponse(_ filename: String) -> Data! {
//    @objc class TestClass: NSObject { }
//
//    let bundle = Bundle(for: TestClass.self)
//    let path = bundle.path(forResource: filename, ofType: "json")
//    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
//}

//MARK:
//MARK: API server
let HCProvider = MoyaProvider<API>(plugins: [MoyaPlugins.MyNetworkActivityPlugin,
                                             RequestLoadingPlugin()]).rx

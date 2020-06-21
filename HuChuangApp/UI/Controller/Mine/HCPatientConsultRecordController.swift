//
//  HCPatientConsultRecordController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/15.
//  Copyright © 2020 sw. All rights reserved.
//  咨询记录

import UIKit

class HCPatientConsultRecordController: HCSlideItemController {

    private var datasource: [HCConsultDetailItemModel] = []
    private var currentReplyId: String = ""
    
    private var tableView: UITableView!
    private var inputMaskView: HCConsultKeyboardMaskView!
    private var keyboardManager = KeyboardManager()
    
    public var gotoChatConsultRoomCallBack: ((HCConsultDetailItemModel)->())?
    public var operationCallBack:(((HCPatientConsultRecordFooterOperation, HCConsultDetailItemModel))->())?
    
    public var sendImageCallBack:(((UIImage, String))->())?
    public var sendAudioCallBack:(((Data, UInt, String))->())?
    public var sendTextCallBack:(((String, String))->())?
    /// 退回
    public var sendBackCallBack:((String)->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        inputMaskView = HCConsultKeyboardMaskView()
        inputMaskView.isHidden = true
        
        inputMaskView.mediaClickedCallBack = { [unowned self] _ in self.systemPic() }
        
        inputMaskView.sendAudioCallBack = { [unowned self] in
            self.sendAudioCallBack?(($0.0, $0.1, self.currentReplyId))
        }
        inputMaskView.sendTextCallBack = { [unowned self] in
            self.sendTextCallBack?(($0, self.currentReplyId))
        }
        
        tableView = UITableView.init(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        view.addSubview(tableView)
        
        view.addSubview(inputMaskView)
        
        tableView.register(HCConsultDetailTimeCell.self, forCellReuseIdentifier: HCConsultDetailTimeCell_identifier)
        tableView.register(HCConsultDetalCell.self, forCellReuseIdentifier: HCConsultDetalCell_identifier)
        tableView.register(HCConsultDetailTextPhotoCell.self, forCellReuseIdentifier: HCConsultDetailTextPhotoCell_identifier)
        tableView.register(HCConsultDetailPhotoCell.self, forCellReuseIdentifier: HCConsultDetailPhotoCell_identifier)
        tableView.register(HCConsultDetailAudioCell.self, forCellReuseIdentifier: HCConsultDetailAudioCell_identifier)

        tableView.register(HCPatientConsultRecordHeader.self, forHeaderFooterViewReuseIdentifier: HCPatientConsultRecordHeader_identifier)
        tableView.register(HCPatientConsultRecordFooter.self, forHeaderFooterViewReuseIdentifier: HCPatientConsultRecordFooter_identifier)
        
        keyboardManager.registerNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        keyboardManager.registerNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        keyboardManager.removeNotification()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
        inputMaskView.frame = view.bounds
        
        keyboardManager.move(coverView: inputMaskView.coverView, moveView: inputMaskView.coverView)
    }
    
    override func reloadData(data: Any?) {
        if let model = data as? [HCConsultDetailItemModel] {
            datasource = model
            tableView.reloadData()
        }
    }

      override func bind<T>(viewModel: RefreshVM<T>, canRefresh: Bool, canLoadMore: Bool, isAddNoMoreContent: Bool) {
    
      }

}

extension HCPatientConsultRecordController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].consultList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = datasource[indexPath.section].consultList[indexPath.row]
        return model.getCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = datasource[indexPath.section].consultList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: model.cellIdentifier) as! HCBaseConsultCell
        cell.model = model
        cell.contentBgTagCallBack = {
            AudioPlayHelper.share.prepare(with: $0.fileList.first ?? "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 33
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HCPatientConsultRecordHeader_identifier) as! HCPatientConsultRecordHeader
        header.model = datasource[section]
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return datasource[section].footerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: HCPatientConsultRecordFooter_identifier) as! HCPatientConsultRecordFooter
        footer.model = datasource[section]
        footer.operationCallBack = { [weak self] data in
            if data.0 == .back {
                NoticesCenter.alert(title: "退回", message: "退回之后不能再回复此条消息", cancleTitle: "取消", okTitle: "确定") {
                    self?.sendBackCallBack?(data.1.code)
                }
            }else if data.1.isChatConsult {
                self?.gotoChatConsultRoomCallBack?(data.1)
            }else if data.0 == .reply || data.0 == .supplementReply {
                self?.currentReplyId = data.1.id
                self?.inputMaskView.beginEdit()
            }
        }
        return footer
    }
}

//MARK: - 选择图片
extension HCPatientConsultRecordController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func systemPic(){
        let systemPicVC = UIImagePickerController()
        systemPicVC.sourceType = UIImagePickerController.SourceType.photoLibrary
        systemPicVC.delegate = self
        systemPicVC.allowsEditing = true
        UIApplication.shared.keyWindow?.rootViewController?.present(systemPicVC, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            sendImageCallBack?((img, currentReplyId))
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

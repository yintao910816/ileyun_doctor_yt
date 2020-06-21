//
//  HCTemperaturePickerController.swift
//  HuChuangApp
//
//  Created by sw on 2019/12/20.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCPickerController: HCPicker {

    private var selectedComponent: Int = 0
    private var selectedRow: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        modalPresentationStyle = .fullScreen
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        let containViewHeight = pickerHeight + 44
        containerView.frame = .init(x: 0, y: view.height - containViewHeight, width: view.width, height: containViewHeight)

        picker.frame = .init(x: 0, y: 44, width: containerView.width, height: pickerHeight)

        containerView.addSubview(picker)
        
        containerView.transform = .init(translationX: 0, y: pickerHeight + 44)

        show(animotion: true)
    }

    override func doneAction() {
        var selectedModels: [HCPickerData] = []
        for idx in 0..<sectionModel.count {
            selectedModels.append(sectionModel[idx][picker.selectedRow(inComponent: idx)])
        }
        finishSelectedModel?((HCPickerAction.ok, selectedModels))
        cancelAction()
    }
    
    public var sectionModel: [[HCPickerData]]! {
        didSet {
            picker.reloadAllComponents()
        }
    }
    
    //MARK: - lazy
    private lazy var picker: UIPickerView = {
        let p = UIPickerView()
        p.backgroundColor = .white
        p.delegate = self
        p.dataSource = self
        return p
    }()

//    override var pickerHeight: CGFloat {
//        didSet {
//            var frame = picker.frame
//            frame.size.height = pickerHeight
//            picker.frame = frame
//            
//            frame = containerView.frame
//            frame.size.height = pickerHeight + 44
//            frame.origin.y = view.width - (frame.size.height)
//            containerView.frame = frame
//            
//            containerView.transform = .init(translationX: 0, y: pickerHeight + 44)
//        }
//    }

}

extension HCPickerController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return sectionModel.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sectionModel[component].count
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
      
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel? = view as? UILabel
        if label == nil {
            label = UILabel()
            label?.textAlignment = .center
            label?.textColor = RGB(53, 53, 53)
            label?.font = .font(fontSize: 18)
        }
        label?.text = sectionModel[component][row].title
        return label!
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return sectionModel[component][row].title
//    }

}

//
//  FirstVC.swift
//  DevPractical
//
//  Created by Jalpesh Patel on 05/01/24.
//

import UIKit

class FirstVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet var txtDefficulty : UITextField!
    //MARK: - Variable
    private var aryOfDefficulty = Defficulty.allCases
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setInitialView()
    }
    
    //MARK: - Initial Setup
    func setInitialView(){
        self.showPicker()
    }
    
    //MARK: - Button Action
    @IBAction func btnTapStart(_ sender: UIButton) {
        if !Constant.selectedDefficulty.isEmpty {
            
            let vc : QuizVC = QuizVC.instantiate(appStoryboard: .main)
            self.navigationController?.pushViewController(vc,animated:true)
            
        }else{
            
            self.showTost(msg: Constant.validationMsg.emptyDiffi)
        }
        
    }
    
    //MARK: - Function
    func showPicker() {
            
            let picker: UIPickerView
            picker = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 220))
            picker.backgroundColor = .white
            picker.setValue(appColor.skyColor, forKeyPath: "textColor")

            picker.delegate = self
            picker.dataSource = self

            let toolBar = UIToolbar()
            toolBar.barStyle = UIBarStyle.default
            toolBar.isTranslucent = true
            toolBar.tintColor = appColor.blueColor
            toolBar.barTintColor = UIColor.white
            toolBar.sizeToFit()

            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonTapped))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelButtonTapped))

            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true

            DispatchQueue.main.async {
                self.txtDefficulty.inputView = picker
                self.txtDefficulty.inputAccessoryView = toolBar
            }
       }

        @objc func doneButtonTapped() {
           self.view.endEditing(true)
       }
        @objc func cancelButtonTapped() {
            self.view.endEditing(true)
        }
}

//MARK: - PICKER DELEGATE
extension FirstVC : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.aryOfDefficulty.count
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.aryOfDefficulty[row].rawValue
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(self.aryOfDefficulty[row].rawValue)
        let diffi = self.aryOfDefficulty[row].rawValue
        self.txtDefficulty.text = diffi
        Constant.selectedDefficulty = diffi
    }
}

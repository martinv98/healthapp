//
//  AddDataView.swift
//  HealthAppTest
//
//  Created by Martin Varga on 14/03/2022.
//

import Foundation
import UIKit

extension AddController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return healthTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return healthTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedType = healthTypes[row] as String
        print(selectedType)
    }
}

extension AddController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let isNumber = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
        let withDecimal = (
            string == NumberFormatter().decimalSeparator &&
            textField.text?.contains(string) == false
        )
        return isNumber || withDecimal
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputText.resignFirstResponder()
        return true
    }
    
    /*func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == dateStart {
                 return false
        }
        return true
    }*/
    

}

class AddController: UIViewController{
    
    let healthTypes = ["Water","Steps","Distance Ran","Distance Cycled","Distance Swam","Distance in wheelchair","Calories"]
    @IBOutlet weak var elementPicker: UIPickerView!
    @IBOutlet weak var dateStart1: UITextField!
    @IBOutlet weak var dateStartTime1: UITextField!
    @IBOutlet weak var dateEnd1: UITextField!
    @IBOutlet weak var dateEndTime1: UITextField!
    @IBOutlet weak var inputText: UITextField!
    //@IBOutlet weak var shownValue: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    let datePickerStart1 = UIDatePicker()
    let datePickerStartTime1 = UIDatePicker()
    let datePickerEnd1 = UIDatePicker()
    let datePickerEndTime1 = UIDatePicker()
    //var picker = UIPickerView()
    var selectedType = "Water"
    
    @IBOutlet weak var startDateStack: UIStackView!
    @IBOutlet weak var endDateStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = hexStringToUIColor(hex: "#15132D")
        addButton.setTitle("Add Value", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.backgroundColor = hexStringToUIColor(hex: "#4FD3C4")
        addButton.layer.cornerRadius = 25
        //addButton.clipsToBounds = true
        addButton.titleLabel?.font = UIFont(name: "GillSans", size: 40)
        addButton.titleLabel?.minimumScaleFactor = 0.2
        addButton.titleLabel?.numberOfLines = 1
        addButton.titleLabel?.adjustsFontSizeToFitWidth = true
        addButton.titleLabel?.textAlignment = .center
        //addButton.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        
        inputText.backgroundColor = hexStringToUIColor(hex: "#BCB6FF")
        inputText.layer.cornerRadius = 15
        inputText.layer.masksToBounds = true
        inputText.textColor = UIColor.black
        inputText.attributedPlaceholder = NSAttributedString(
            string: "Value to be added",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        
        /*shownValue.backgroundColor = hexStringToUIColor(hex: "#4A306D")
        shownValue.layer.cornerRadius = 25
        shownValue.layer.masksToBounds = true
        shownValue.attributedPlaceholder = NSAttributedString(
            string: "Summary",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )*/
        
        //date
        dateStart1.backgroundColor = hexStringToUIColor(hex: "#BCB6FF")
        dateStart1.textColor = UIColor.black
        dateStart1.layer.cornerRadius = 10
        dateStart1.layer.masksToBounds = true
        
        dateStartTime1.backgroundColor = hexStringToUIColor(hex: "#BCB6FF")
        dateStartTime1.textColor = UIColor.black
        dateStartTime1.layer.cornerRadius = 10
        dateStartTime1.layer.masksToBounds = true
        
        dateEnd1.backgroundColor = hexStringToUIColor(hex: "#BCB6FF")
        dateEnd1.textColor = UIColor.black
        dateEnd1.layer.cornerRadius = 10
        dateEnd1.layer.masksToBounds = true
        
        dateEndTime1.backgroundColor = hexStringToUIColor(hex: "#BCB6FF")
        dateEndTime1.textColor = UIColor.black
        dateEndTime1.layer.cornerRadius = 10
        dateEndTime1.layer.masksToBounds = true
        //date
        startDateStack.layer.cornerRadius = 15
        endDateStack.layer.cornerRadius = 15
        
        if dateStart1.text!.isEmpty{
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.dateFormat = "d MMM yyyy"
            dateStart1.text = formatter.string(from: Date())
        }
        if dateStartTime1.text!.isEmpty{
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateFormat = "HH:mm"
            dateStartTime1.text = formatter.string(from: Date())
        }
        if dateEnd1.text!.isEmpty{
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.dateFormat = "d MMM yyyy"
            dateEnd1.text = formatter.string(from: Date())
        }
        if dateEndTime1.text!.isEmpty{
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateFormat = "HH:mm"
            dateEndTime1.text = formatter.string(from: Date())
        }
        
        elementPicker.delegate = self
        elementPicker.dataSource = self
        elementPicker.selectRow(1, inComponent: 0, animated: true)
        
        selectedType = healthTypes[elementPicker.selectedRow(inComponent: 0)]
        
        inputText.delegate = self
        
        createDatePickerStart()
        createDatePickerStartTime()
        createDatePickerEnd()
        createDatePickerEndTime()
        
    }
    
    func createDatePickerStart(){
        let toolbarStart1 = UIToolbar()
        toolbarStart1.sizeToFit()
        toolbarStart1.barStyle = .default
        toolbarStart1.barTintColor = UIColor.black
        toolbarStart1.isTranslucent = false
        //toolbarStart.autoresizingMask = .flexibleHeight
        //toolbarStart.backgroundColor = UIColor.white
        //toolbarStart.tintColor = UIColor.orange
        
        
        let doneBtnStart1 = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedStart1))
        toolbarStart1.setItems([doneBtnStart1], animated: true)
        toolbarStart1.isUserInteractionEnabled = true
        
        dateStart1.inputAccessoryView = toolbarStart1
        datePickerStart1.preferredDatePickerStyle = .inline
        datePickerStart1.sizeToFit()
        datePickerStart1.datePickerMode = .date
        dateStart1.inputView = datePickerStart1
        //datePickerStart.setValue(UIColor.orange, forKeyPath: "textColor")
        //datePickerStart.setValue(UIColor.brown, forKey: "textColor")
        //datePickerStart.translatesAutoresizingMaskIntoConstraints = true
        //datePickerStart.backgroundColor = UIColor.black
        //datePickerStart.tintColor = UIColor.systemBlue
    }
    func createDatePickerStartTime(){
        let toolbarStartTime1 = UIToolbar()
        toolbarStartTime1.sizeToFit()
        toolbarStartTime1.barStyle = .default
        toolbarStartTime1.barTintColor = UIColor.black
        toolbarStartTime1.isTranslucent = false
        
        let doneBtnStartTime1 = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedStartTime1))
        toolbarStartTime1.setItems([doneBtnStartTime1], animated: true)
        toolbarStartTime1.isUserInteractionEnabled = true
        
        dateStartTime1.inputAccessoryView = toolbarStartTime1
        datePickerStartTime1.preferredDatePickerStyle = .wheels
        datePickerStartTime1.sizeToFit()
        datePickerStartTime1.datePickerMode = .time
        dateStartTime1.inputView = datePickerStartTime1
    }
    
    func createDatePickerEnd(){
        let toolbarEnd1 = UIToolbar()
        toolbarEnd1.sizeToFit()
        toolbarEnd1.barStyle = .default
        toolbarEnd1.barTintColor = UIColor.black
        toolbarEnd1.isTranslucent = false
        
        let doneBtnEnd1 = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedEnd1))
        toolbarEnd1.setItems([doneBtnEnd1], animated: true)
        toolbarEnd1.isUserInteractionEnabled = true
        
        dateEnd1.inputAccessoryView = toolbarEnd1
        datePickerEnd1.preferredDatePickerStyle = .inline
        datePickerEnd1.sizeToFit()
        datePickerEnd1.datePickerMode = .date
        dateEnd1.inputView = datePickerEnd1
    }
    func createDatePickerEndTime(){
        let toolbarEndTime1 = UIToolbar()
        toolbarEndTime1.sizeToFit()
        toolbarEndTime1.barStyle = .default
        toolbarEndTime1.barTintColor = UIColor.black
        toolbarEndTime1.isTranslucent = false
        
        let doneBtnEndTime1 = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedEndTime1))
        toolbarEndTime1.setItems([doneBtnEndTime1], animated: true)
        toolbarEndTime1.isUserInteractionEnabled = true
        
        dateEndTime1.inputAccessoryView = toolbarEndTime1
        datePickerEndTime1.preferredDatePickerStyle = .wheels
        datePickerEndTime1.sizeToFit()
        datePickerEndTime1.datePickerMode = .time
        dateEndTime1.inputView = datePickerEndTime1
    }
    
    @objc func donePressedStart1(){
        let formatterStart1 = DateFormatter()
        formatterStart1.dateStyle = .medium
        formatterStart1.dateFormat = "d MMM yyyy"
        
        /*formatterStart.dateFormat = "d MMMM yyyy"
        var realDate = formatterStart.string(from: datePickerStart.date)
        formatterStart.dateFormat = "h:mma"
        var realHourAndMin = formatterStart.string(from: datePickerStart.date)
        dateStart.text = "\(realDate)\n\(realHourAndMin)"*/
        
        dateStart1.text = formatterStart1.string(from: datePickerStart1.date)
        self.view.endEditing(true)
    }
    
    @objc func donePressedStartTime1(){
        let formatterStartTime1 = DateFormatter()
        formatterStartTime1.timeStyle = .short
        formatterStartTime1.dateFormat = "HH:mm"
        dateStartTime1.text = formatterStartTime1.string(from: datePickerStartTime1.date)
        self.view.endEditing(true)
    }
    
    @objc func donePressedEnd1(){
        let formatterEnd1 = DateFormatter()
        formatterEnd1.dateStyle = .medium
        formatterEnd1.dateFormat = "d MMM yyyy"
        dateEnd1.text = formatterEnd1.string(from: datePickerEnd1.date)
        self.view.endEditing(true)
    }
    @objc func donePressedEndTime1(){
        let formatterEndTime1 = DateFormatter()
        formatterEndTime1.timeStyle = .short
        formatterEndTime1.dateFormat = "HH:mm"
        dateEndTime1.text = formatterEndTime1.string(from: datePickerEndTime1.date)
        self.view.endEditing(true)
    }
    
    @IBAction func addClicked(_ sender: UIButton) {
        
        
        //let start = DispatchTime.now() // <<<<<<<<<< Start time
        
        
        var currentDate1 = "Dec 15, 1998"
        let formatterCurrentDate1 = DateFormatter()
        formatterCurrentDate1.dateStyle = .medium
        formatterCurrentDate1.dateFormat = "d MMM yyyy"
        currentDate1 = formatterCurrentDate1.string(from: Date())
        
        var currentTime1 = "11:00 PM"
        let formatterCurrentTime1 = DateFormatter()
        formatterCurrentTime1.timeStyle = .short
        formatterCurrentTime1.dateFormat = "HH:mm"
        currentTime1 = formatterCurrentTime1.string(from: Date())
        
        
        let dateFormatterCombine1 = DateFormatter()
        //dateFormatterCombine1.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterCombine1.dateFormat = "d MMM yyyy 'at' HH:mm"
        let startDateTemp1 = (dateStart1.text ?? currentDate1) + " at " + (dateStartTime1.text ?? currentTime1)
        let startDateFinal1 = dateFormatterCombine1.date(from: startDateTemp1)
        //print(startDateFinal?.description(with: .current) ?? "")
        
        let dateFormatterCombine11 = DateFormatter()
        //dateFormatterCombine11.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterCombine11.dateFormat = "d MMM yyyy 'at' HH:mm"
        let endDateTemp1 = (dateEnd1.text ?? currentDate1) + " at " + (dateEndTime1.text ?? currentTime1)
        let endDateFinal1 = dateFormatterCombine11.date(from: endDateTemp1)
        //print(endDateFinal?.description(with: .current) ?? "")
        
        
        var popUpWindow: PopUpWindow!
        
        switch selectedType {
        case healthTypes[0]:
            HealthStore.shared.writeWater(waterConsumed: (inputText.text! as NSString).doubleValue, dateStart: startDateFinal1!, dateEnd: endDateFinal1!){success in
                if success{
                    DispatchQueue.main.async {
                        popUpWindow = PopUpWindow(title: "Success", text: self.inputText.text! + " ml of water successfully added.", buttontext: "OK")
                        self.present(popUpWindow, animated: true, completion: nil)
                    }
                    /*let end = DispatchTime.now()   // <<<<<<<<<<   end time

                    let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
                    let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests

                    print("Time to evaluate problem: " + String(timeInterval))
                    print("TimeNano: " + String(nanoTime))*/
                    print("Water saved successfully")
                }else{
                    DispatchQueue.main.async {
                        popUpWindow = PopUpWindow(title: "Error", text: "Water was not added.", buttontext: "OK")
                        self.present(popUpWindow, animated: true, completion: nil)
                    }
                    print("Water was not saved successfully")
                }
            }
        case healthTypes[1]:
            HealthStore.shared.writeSteps(stepCountValue: (inputText.text! as NSString).doubleValue, dateStart: startDateFinal1!, dateEnd: endDateFinal1!){success in
                if success{
                    DispatchQueue.main.async {
                        popUpWindow = PopUpWindow(title: "Success", text: self.inputText.text! + " steps were successfully added.", buttontext: "OK")
                        self.present(popUpWindow, animated: true, completion: nil)
                    }
                    print("Steps saved successfully")
                }else{
                    DispatchQueue.main.async {
                        popUpWindow = PopUpWindow(title: "Error", text: "Steps were not added.", buttontext: "OK")
                        self.present(popUpWindow, animated: true, completion: nil)
                    }
                    print("Steps were not saved successfully")
                }
            }
        case healthTypes[2]:
            HealthStore.shared.writeDistanceRunning(distanceRunningValue: (inputText.text! as NSString).doubleValue, dateStart: startDateFinal1!, dateEnd: endDateFinal1!){success in
                if success{
                    DispatchQueue.main.async {
                        popUpWindow = PopUpWindow(title: "Success", text: self.inputText.text! + " meters of running distance were successfully added.", buttontext: "OK")
                        self.present(popUpWindow, animated: true, completion: nil)
                    }
                    print("Distance ran saved successfully")
                }else{
                    DispatchQueue.main.async {
                        popUpWindow = PopUpWindow(title: "Error", text: "Running distance was not added.", buttontext: "OK")
                        self.present(popUpWindow, animated: true, completion: nil)
                    }
                    print("Distance ran was not saved successfully")
                }
            }
        case healthTypes[3]:
            HealthStore.shared.writeDistanceCycling(distanceCyclingValue: (inputText.text! as NSString).doubleValue, dateStart: startDateFinal1!, dateEnd: endDateFinal1!){success in
                if success{
                    DispatchQueue.main.async {
                        popUpWindow = PopUpWindow(title: "Success", text: self.inputText.text! + " meters of cycling distance were successfully added.", buttontext: "OK")
                        self.present(popUpWindow, animated: true, completion: nil)
                    }
                    print("Distance cycled saved successfully")
                }else{
                    DispatchQueue.main.async {
                        popUpWindow = PopUpWindow(title: "Error", text: "Cycling distance was not added.", buttontext: "OK")
                        self.present(popUpWindow, animated: true, completion: nil)
                    }
                    print("Distance cycled was not saved successfully")
                }
            }
        case healthTypes[4]:
            HealthStore.shared.writeDistanceSwimming(distanceSwimmingValue: (inputText.text! as NSString).doubleValue, dateStart: startDateFinal1!, dateEnd: endDateFinal1!){success in
                if success{
                    DispatchQueue.main.async {
                        popUpWindow = PopUpWindow(title: "Success", text: self.inputText.text! + " meters of swimming distance were successfully added.", buttontext: "OK")
                        self.present(popUpWindow, animated: true, completion: nil)
                    }
                    print("Distance swimmed saved successfully")
                }else{
                    DispatchQueue.main.async {
                        popUpWindow = PopUpWindow(title: "Error", text: "Swimming distance was not added.", buttontext: "OK")
                        self.present(popUpWindow, animated: true, completion: nil)
                    }
                    print("Distance swimmed was not saved successfully")
                }
            }
        case healthTypes[5]:
            HealthStore.shared.writeDistanceWheelchair(distanceWheelchairValue: (inputText.text! as NSString).doubleValue, dateStart: startDateFinal1!, dateEnd: endDateFinal1!){success in
                if success{
                    DispatchQueue.main.async {
                        popUpWindow = PopUpWindow(title: "Success", text: self.inputText.text! + " meters of distance while in wheelchair were successfully added.", buttontext: "OK")
                        self.present(popUpWindow, animated: true, completion: nil)
                    }
                    print("Distance while in wheelchair saved successfully")
                }else{
                    DispatchQueue.main.async {
                        popUpWindow = PopUpWindow(title: "Error", text: "Wheelchair distance was not added.", buttontext: "OK")
                        self.present(popUpWindow, animated: true, completion: nil)
                    }
                    print("Distance while in wheelchair not saved successfully")
                }
            }
        case healthTypes[6]:
            HealthStore.shared.writeCalories(caloriesValue: (inputText.text! as NSString).doubleValue, dateStart: startDateFinal1!, dateEnd: endDateFinal1!){success in
                if success{
                    DispatchQueue.main.async {
                        popUpWindow = PopUpWindow(title: "Success", text: self.inputText.text! + " kilocalories were successfully added.", buttontext: "OK")
                        self.present(popUpWindow, animated: true, completion: nil)
                    }
                    print("Calories saved successfully")
                }else{
                    DispatchQueue.main.async {
                        popUpWindow = PopUpWindow(title: "Error", text: "Calories were not added.", buttontext: "OK")
                        self.present(popUpWindow, animated: true, completion: nil)
                    }
                    print("Calories not saved successfully")
                }
            }
        default:
            print("Error")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputText.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    
}

extension UIPickerView {
    @IBInspectable var pickerTextColor:UIColor? {
        get {
            return self.pickerTextColor
        }
        set {
            self.setValue(newValue, forKeyPath: "textColor")
        }
    }
}

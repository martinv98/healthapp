//
//  ShowDataView.swift
//  HealthAppTest
//
//  Created by Martin Varga on 14/03/2022.
//

import Foundation
import UIKit

extension ShowController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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

class ShowController: UIViewController{
    let healthTypes = ["Water","Steps","Distance Ran","Distance Cycled","Distance Swam","Distance in wheelchair","Avg Heart Rate","Calories"]
    @IBOutlet weak var elementPicker: UIPickerView!
    @IBOutlet weak var dateStart: UITextField!
    @IBOutlet weak var dateStartTime: UITextField!
    @IBOutlet weak var dateEnd: UITextField!
    @IBOutlet weak var dateEndTime: UITextField!
    @IBOutlet weak var shownValue: UITextField!
    @IBOutlet weak var showButton: UIButton!
    
    let datePickerStart = UIDatePicker()
    let datePickerStartTime = UIDatePicker()
    let datePickerEnd = UIDatePicker()
    let datePickerEndTime = UIDatePicker()
    //var picker = UIPickerView()
    var selectedType = "Water"
    
    @IBOutlet weak var startDateStack: UIStackView!
    @IBOutlet weak var endDateStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = hexStringToUIColor(hex: "#15132D")
        showButton.setTitle("Show Value", for: .normal)
        showButton.setTitleColor(.black, for: .normal)
        showButton.backgroundColor = hexStringToUIColor(hex: "#4FD3C4")
        showButton.layer.cornerRadius = 25
        //addButton.clipsToBounds = true
        showButton.titleLabel?.font = UIFont(name: "GillSans", size: 40)
        showButton.titleLabel?.minimumScaleFactor = 0.2
        showButton.titleLabel?.numberOfLines = 1
        showButton.titleLabel?.adjustsFontSizeToFitWidth = true
        showButton.titleLabel?.textAlignment = .center
        //addButton.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        
        shownValue.backgroundColor = hexStringToUIColor(hex: "#4A306D")
        shownValue.layer.cornerRadius = 25
        shownValue.layer.masksToBounds = true
        shownValue.attributedPlaceholder = NSAttributedString(
            string: "Summary",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        startDateStack.layer.cornerRadius = 15
        endDateStack.layer.cornerRadius = 15
        
        //date
        dateStart.backgroundColor = hexStringToUIColor(hex: "#BCB6FF")
        dateStart.textColor = UIColor.black
        dateStart.layer.cornerRadius = 10
        dateStart.layer.masksToBounds = true
        
        dateStartTime.backgroundColor = hexStringToUIColor(hex: "#BCB6FF")
        dateStartTime.textColor = UIColor.black
        dateStartTime.layer.cornerRadius = 10
        dateStartTime.layer.masksToBounds = true
        
        dateEnd.backgroundColor = hexStringToUIColor(hex: "#BCB6FF")
        dateEnd.textColor = UIColor.black
        dateEnd.layer.cornerRadius = 10
        dateEnd.layer.masksToBounds = true
        
        dateEndTime.backgroundColor = hexStringToUIColor(hex: "#BCB6FF")
        dateEndTime.textColor = UIColor.black
        dateEndTime.layer.cornerRadius = 10
        dateEndTime.layer.masksToBounds = true
        //date
        
        if dateStart.text!.isEmpty{
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.dateFormat = "d MMM yyyy"
            dateStart.text = formatter.string(from: Date())
        }
        if dateStartTime.text!.isEmpty{
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateFormat = "HH:mm"
            dateStartTime.text = formatter.string(from: Date())
        }
        if dateEnd.text!.isEmpty{
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.dateFormat = "d MMM yyyy"
            dateEnd.text = formatter.string(from: Date())
        }
        if dateEndTime.text!.isEmpty{
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateFormat = "HH:mm"
            dateEndTime.text = formatter.string(from: Date())
        }
        
        elementPicker.delegate = self
        elementPicker.dataSource = self
        elementPicker.selectRow(1, inComponent: 0, animated: true)
        
        selectedType = healthTypes[elementPicker.selectedRow(inComponent: 0)]
        
        
        createDatePickerStart()
        createDatePickerStartTime()
        createDatePickerEnd()
        createDatePickerEndTime()
        
    }
    
    func createDatePickerStart(){
        let toolbarStart = UIToolbar()
        toolbarStart.sizeToFit()
        toolbarStart.barStyle = .default
        toolbarStart.barTintColor = UIColor.black
        toolbarStart.isTranslucent = false
        
        let doneBtnStart = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedStart))
        toolbarStart.setItems([doneBtnStart], animated: true)
        toolbarStart.isUserInteractionEnabled = true
        
        dateStart.inputAccessoryView = toolbarStart
        datePickerStart.preferredDatePickerStyle = .inline
        datePickerStart.sizeToFit()
        datePickerStart.datePickerMode = .date
        dateStart.inputView = datePickerStart
    }
    func createDatePickerStartTime(){
        let toolbarStartTime = UIToolbar()
        toolbarStartTime.sizeToFit()
        toolbarStartTime.barStyle = .default
        toolbarStartTime.barTintColor = UIColor.black
        toolbarStartTime.isTranslucent = false
        
        let doneBtnStartTime = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedStartTime))
        toolbarStartTime.setItems([doneBtnStartTime], animated: true)
        toolbarStartTime.isUserInteractionEnabled = true
        
        dateStartTime.inputAccessoryView = toolbarStartTime
        datePickerStartTime.preferredDatePickerStyle = .wheels
        datePickerStartTime.sizeToFit()
        datePickerStartTime.datePickerMode = .time
        dateStartTime.inputView = datePickerStartTime
    }
    
    func createDatePickerEnd(){
        let toolbarEnd = UIToolbar()
        toolbarEnd.sizeToFit()
        toolbarEnd.barStyle = .default
        toolbarEnd.barTintColor = UIColor.black
        toolbarEnd.isTranslucent = false
        
        let doneBtnEnd = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedEnd))
        toolbarEnd.setItems([doneBtnEnd], animated: true)
        toolbarEnd.isUserInteractionEnabled = true
        
        dateEnd.inputAccessoryView = toolbarEnd
        datePickerEnd.preferredDatePickerStyle = .inline
        datePickerEnd.sizeToFit()
        datePickerEnd.datePickerMode = .date
        dateEnd.inputView = datePickerEnd
    }
    func createDatePickerEndTime(){
        let toolbarEndTime = UIToolbar()
        toolbarEndTime.sizeToFit()
        toolbarEndTime.barStyle = .default
        toolbarEndTime.barTintColor = UIColor.black
        toolbarEndTime.isTranslucent = false
        
        let doneBtnEndTime = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedEndTime))
        toolbarEndTime.setItems([doneBtnEndTime], animated: true)
        toolbarEndTime.isUserInteractionEnabled = true
        
        dateEndTime.inputAccessoryView = toolbarEndTime
        datePickerEndTime.preferredDatePickerStyle = .wheels
        datePickerEndTime.sizeToFit()
        datePickerEndTime.datePickerMode = .time
        dateEndTime.inputView = datePickerEndTime
    }
    
    @objc func donePressedStart(){
        let formatterStart = DateFormatter()
        formatterStart.dateStyle = .medium
        formatterStart.dateFormat = "d MMM yyyy"
        dateStart.text = formatterStart.string(from: datePickerStart.date)
        self.view.endEditing(true)
    }
    
    @objc func donePressedStartTime(){
        let formatterStartTime = DateFormatter()
        formatterStartTime.timeStyle = .short
        formatterStartTime.dateFormat = "HH:mm"
        dateStartTime.text = formatterStartTime.string(from: datePickerStartTime.date)
        self.view.endEditing(true)
    }
    
    @objc func donePressedEnd(){
        let formatterEnd = DateFormatter()
        formatterEnd.dateStyle = .medium
        formatterEnd.dateFormat = "d MMM yyyy"
        dateEnd.text = formatterEnd.string(from: datePickerEnd.date)
        self.view.endEditing(true)
    }
    @objc func donePressedEndTime(){
        let formatterEndTime = DateFormatter()
        formatterEndTime.timeStyle = .short
        formatterEndTime.dateFormat = "HH:mm"
        dateEndTime.text = formatterEndTime.string(from: datePickerEndTime.date)
        self.view.endEditing(true)
    }
    
    @IBAction func showValue(_ sender: UIButton) {
        
        //let start = DispatchTime.now() // <<<<<<<<<< Start time
        
        var currentDate = "15 Dec 1998"
        let formatterCurrentDate = DateFormatter()
        formatterCurrentDate.dateStyle = .medium
        formatterCurrentDate.dateFormat = "d MMM yyyy"
        currentDate = formatterCurrentDate.string(from: Date())
        
        var currentTime = "11:00"
        let formatterCurrentTime = DateFormatter()
        formatterCurrentTime.timeStyle = .short
        formatterCurrentTime.dateFormat = "HH:mm"
        currentTime = formatterCurrentTime.string(from: Date())
        
        
        let dateFormatterCombine = DateFormatter()
        //dateFormatterCombine.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterCombine.dateFormat = "d MMM yyyy 'at' HH:mm"
        let startDateTemp = (dateStart.text ?? currentDate) + " at " + (dateStartTime.text ?? currentTime)
        let startDateFinal = dateFormatterCombine.date(from: startDateTemp)
        //print(startDateTemp)
        //print(startDateFinal?.description(with: .current) ?? "chyba")
        
        
        let dateFormatterCombine2 = DateFormatter()
        //dateFormatterCombine2.locale = Locale(identifier: "en_US_POSIX")
        //dateFormatterCombine2.dateFormat = "MMMM dd, yyyy 'at' h:mm a"
        dateFormatterCombine2.dateFormat = "d MMM yyyy 'at' HH:mm"
        let endDateTemp = (dateEnd.text ?? currentDate) + " at " + (dateEndTime.text ?? currentTime)
        let endDateFinal = dateFormatterCombine.date(from: endDateTemp)
        //print(endDateFinal?.description(with: .current) ?? "")

        
        
        switch selectedType {
        case healthTypes[0]:
            HealthStore.shared.readWater(dateStart: startDateFinal!, dateEnd: endDateFinal!){success in
                if success{
                    DispatchQueue.main.async {
                        self.shownValue?.text = HealthStore.shared.waterLabel
                    }
                }else{
                    DispatchQueue.main.async {
                        self.shownValue?.text = HealthStore.shared.waterLabel
                    }
                    print("daco nedobre zase")
                }
            }
            /*HealthStore.shared.readWaterForDB(dateStart: startDateFinal!, dateEnd: endDateFinal!){success in
                if success{
                    print("nice")
                }else{
                    print("not nice")
                }
            }*/
        case healthTypes[1]:
            HealthStore.shared.readSteps(dateStart: startDateFinal!, dateEnd: endDateFinal!){success in
                if success{
                    DispatchQueue.main.async {
                        self.shownValue?.text = HealthStore.shared.stepLabel
                    }
                    /*let end = DispatchTime.now()   // <<<<<<<<<<   end time

                    let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
                    let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests

                    print("Time to evaluate problem: " + String(timeInterval))
                    print("TimeNano: " + String(nanoTime))*/
                }else{
                    DispatchQueue.main.async {
                        self.shownValue?.text = HealthStore.shared.stepLabel
                    }
                    print("daco nedobre zase")
                }
            }
            /*HealthStore.shared.readStepsForDB(dateStart: startDateFinal!, dateEnd: endDateFinal!){success in
                if success{
                    print("nice")
                    
                }else{
                    print("not nice")
                }
            }*/
        case healthTypes[2]:
            HealthStore.shared.readDistanceRunning(dateStart: startDateFinal!, dateEnd: endDateFinal!){success in
                if success{
                    DispatchQueue.main.async {
                        self.shownValue?.text = HealthStore.shared.distanceRunningLabel
                    }
                }else{
                    DispatchQueue.main.async {
                        self.shownValue?.text = HealthStore.shared.distanceRunningLabel
                    }
                    print("daco nedobre zase")
                }
            }
        case healthTypes[3]:
            HealthStore.shared.readDistanceCycling(dateStart: startDateFinal!, dateEnd: endDateFinal!){success in
                if success{
                    DispatchQueue.main.async {
                        self.shownValue?.text = HealthStore.shared.distanceCycledLabel
                    }
                }else{
                    DispatchQueue.main.async {
                        self.shownValue?.text = HealthStore.shared.distanceCycledLabel
                    }
                    print("daco nedobre zase")
                }
            }
        case healthTypes[4]:
            HealthStore.shared.readDistanceSwimming(dateStart: startDateFinal!, dateEnd: endDateFinal!){success in
                if success{
                    DispatchQueue.main.async {
                        self.shownValue?.text = HealthStore.shared.distanceSwimmingLabel
                    }
                }else{
                    DispatchQueue.main.async {
                        self.shownValue?.text = HealthStore.shared.distanceSwimmingLabel
                    }
                    print("daco nedobre zase")
                }
            }
        case healthTypes[5]:
            HealthStore.shared.readDistanceWheelchair(dateStart: startDateFinal!, dateEnd: endDateFinal!){success in
                if success{
                    DispatchQueue.main.async {
                        self.shownValue?.text = HealthStore.shared.distanceWheelchairLabel
                    }
                }else{
                    DispatchQueue.main.async {
                        self.shownValue?.text = HealthStore.shared.distanceWheelchairLabel
                    }
                    print("daco nedobre zase")
                }
            }
        case healthTypes[6]:
            HealthStore.shared.readHeartRate(dateStart: startDateFinal!, dateEnd: endDateFinal!){success in
                if success{
                    DispatchQueue.main.async {
                        self.shownValue?.text = HealthStore.shared.heartRateLabel
                    }
                }else{
                    DispatchQueue.main.async {
                        self.shownValue?.text = HealthStore.shared.heartRateLabel
                    }
                    print("daco nedobre zase")
                }
            }
        case healthTypes[7]:
            HealthStore.shared.readCalories(dateStart: startDateFinal!, dateEnd: endDateFinal!){success in
                if success{
                    DispatchQueue.main.async {
                        self.shownValue?.text = HealthStore.shared.caloriesLabel
                    }
                }else{
                    DispatchQueue.main.async {
                        self.shownValue?.text = HealthStore.shared.caloriesLabel
                    }
                    print("daco nedobre zase")
                }
            }
        default:
            print("nwm")
        }
        

        
    }
    
}

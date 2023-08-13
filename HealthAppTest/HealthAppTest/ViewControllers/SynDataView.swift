//
//  SynDataView.swift
//  HealthAppTest
//
//  Created by Martin Varga on 12/02/2022.
//

import UIKit
import SwiftUI

extension SynController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return databases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return databases[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        databaseSelected = databases[row]
        selectedRow = row
        //UserDefaults.standard.set(row, forKey: "databasePickerSelected")
        //UserDefaults.standard.synchronize()
        //self.setLabelsForChoice(_choice: row)
        //print(databaseSelected)
    }
}




class SynController: UIViewController {
    
    let databases = ["Database1","Database2","Database3"]
    @IBOutlet weak var databasePicker: UIPickerView!
    var databaseSelected = "Database1"
    
    //var selectedElements: Set<Selectable>
    @IBOutlet weak var dateStart: UITextField!
    @IBOutlet weak var dateStartTime: UITextField!
    @IBOutlet weak var dateEnd: UITextField!
    @IBOutlet weak var dateEndTime: UITextField!
    
    @IBOutlet weak var startDateStack: UIStackView!
    @IBOutlet weak var endDateStack: UIStackView!
    
    let datePickerStart = UIDatePicker()
    let datePickerStartTime = UIDatePicker()
    let datePickerEnd = UIDatePicker()
    let datePickerEndTime = UIDatePicker()
    
    @IBOutlet weak var synchronizeButton: UIButton!
    
    var selectedRow = 0
    
    @IBOutlet weak var theContainer : UIView!

    let db = databaseHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = hexStringToUIColor(hex: "#15132D")
        synchronizeButton.setTitle("Synchronize", for: .normal)
        synchronizeButton.setTitleColor(.black, for: .normal)
        synchronizeButton.backgroundColor = hexStringToUIColor(hex: "#4FD3C4")
        synchronizeButton.layer.cornerRadius = 25
        //synchronizeButton.clipsToBounds = true
        synchronizeButton.titleLabel?.font = UIFont(name: "GillSans", size: 40)
        synchronizeButton.titleLabel?.minimumScaleFactor = 0.2
        synchronizeButton.titleLabel?.numberOfLines = 1
        synchronizeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        synchronizeButton.titleLabel?.textAlignment = .center
        //synchronizeButton.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        
        let childView = UIHostingController(rootView: TaskEditView())
        addChild(childView)
        childView.view.frame = theContainer.bounds
        theContainer.addSubview(childView.view)
        
        let userDefault = UserDefaults.standard
        databaseSelected = ((userDefault.value(forKey: "databaseSelected") as? String ?? "Database1"))
        selectedRow = (userDefault.value(forKey: "selectedRow") as? Int ?? 0)
        UserDefaults.standard.synchronize()
        
        databasePicker.delegate = self
        databasePicker.dataSource = self
        databasePicker.selectRow(selectedRow, inComponent: 0, animated: true)
        
        databaseSelected = databases[databasePicker.selectedRow(inComponent: 0)]
        
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
        startDateStack.layer.cornerRadius = 15
        endDateStack.layer.cornerRadius = 15
        
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
        
        createDatePickerStart()
        createDatePickerStartTime()
        createDatePickerEnd()
        createDatePickerEndTime()
        
        

        
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        let userDefault = UserDefaults.standard
        userDefault.set(databaseSelected, forKey: "databaseSelected")
        userDefault.set(selectedRow, forKey: "selectedRow")
        UserDefaults.standard.synchronize()

    }
    
    func createDatePickerStart(){
        let toolbarStart = UIToolbar()
        toolbarStart.sizeToFit()
        toolbarStart.barStyle = .default
        toolbarStart.barTintColor = UIColor.black
        toolbarStart.isTranslucent = false
        //toolbarStart.autoresizingMask = .flexibleHeight
        //toolbarStart.backgroundColor = UIColor.white
        //toolbarStart.tintColor = UIColor.orange
        
        
        let doneBtnStart = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedStart))
        toolbarStart.setItems([doneBtnStart], animated: true)
        toolbarStart.isUserInteractionEnabled = true
        
        dateStart.inputAccessoryView = toolbarStart
        datePickerStart.preferredDatePickerStyle = .inline
        datePickerStart.sizeToFit()
        datePickerStart.datePickerMode = .date
        dateStart.inputView = datePickerStart
        //datePickerStart.setValue(UIColor.orange, forKeyPath: "textColor")
        //datePickerStart.setValue(UIColor.brown, forKey: "textColor")
        //datePickerStart.translatesAutoresizingMaskIntoConstraints = true
        //datePickerStart.backgroundColor = UIColor.black
        //datePickerStart.tintColor = UIColor.systemBlue
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
        
        /*formatterStart.dateFormat = "d MMMM yyyy"
        var realDate = formatterStart.string(from: datePickerStart.date)
        formatterStart.dateFormat = "h:mma"
        var realHourAndMin = formatterStart.string(from: datePickerStart.date)
        dateStart.text = "\(realDate)\n\(realHourAndMin)"*/
        
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
    
    @IBAction func synchronize(_ sender: UIButton) {
        
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
        
        print(databaseSelected)
        print(selectedRow)
        print(SynData.shared.selectedGoals)
        
        let group = DispatchGroup()
        //var listOfHealthData = [healthModelSample]()
        //var listOfHealthDataToBeSynced = [healthModelSample]()
        var insertOrNot = true
        if(SynData.shared.selectedGoals.contains(Goal(name: "Water"))){
            group.enter()
            HealthStore.shared.readWaterForDB(dateStart: startDateFinal!, dateEnd: endDateFinal!){success in
                if success{
                    DispatchQueue.main.async {
                        self.db.listOfHealthData.removeAll()
                        self.db.listOfHealthData = self.db.read()
                        for healthSample in HealthStore.shared.samplesToSyncWater{
                            print(healthSample.sampleValue)
                            insertOrNot = true
                            for healthEntry in self.db.listOfHealthData{
                                if(healthSample.uuid == healthEntry.uuid){
                                    insertOrNot = false
                                }
                                //print(healthSample.sampleValue)
                            }
                            if(insertOrNot){
                                self.db.insert(uuid: healthSample.uuid, sampleType: healthSample.sampleType, sampleValue: healthSample.sampleValue, startDate: healthSample.startDate, endDate: healthSample.endDate)
                            }
                        }
                        print("Synchronized Water")
                        group.leave()
                        //print("ReadFromDB1: " + String(self.db.listOfHealthData.count))
                    }
                }else{
                    DispatchQueue.main.async {
                        print("Big Sync Error Water")
                        group.leave()
                    }
                }
            }
        }

        if(SynData.shared.selectedGoals.contains(Goal(name: "Steps"))){
            group.enter()
            HealthStore.shared.readStepsForDB(dateStart: startDateFinal!, dateEnd: endDateFinal!){success in
                if success{
                    DispatchQueue.main.async {
                        self.db.listOfHealthData.removeAll()
                        self.db.listOfHealthData = self.db.read()
                        for healthSample in HealthStore.shared.samplesToSyncSteps{
                            print(healthSample.sampleValue)
                            insertOrNot = true
                            for healthEntry in self.db.listOfHealthData{
                                if(healthSample.uuid == healthEntry.uuid){
                                    insertOrNot = false
                                }
                            }
                            if(insertOrNot){
                                self.db.insert(uuid: healthSample.uuid, sampleType: healthSample.sampleType, sampleValue: healthSample.sampleValue, startDate: healthSample.startDate, endDate: healthSample.endDate)
                            }
                        }
                        print("Synchronized Steps")
                        group.leave()
                        //print("SamplesToSyncWater: " + String(HealthStore.shared.samplesToSyncWater.count))
                        //print("SamplesToSyncSteps: " + String(HealthStore.shared.samplesToSyncSteps.count))
                        //print("ReadFromDB2: " + String(self.db.listOfHealthData.count))
                        
                        /*let end = DispatchTime.now()   // <<<<<<<<<<   end time

                        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
                        let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests

                        print("Time to evaluate problem: " + String(timeInterval))
                        print("TimeNano: " + String(nanoTime))*/
                        //if stepsFinished && waterFinished{
                        //}
                    }
                }else{
                    DispatchQueue.main.async {
                        print("Big Sync Error Steps")
                        group.leave()
                    }
                }
            }
        }
        
        if(SynData.shared.selectedGoals.contains(Goal(name: "Distance Running"))){
            group.enter()
            HealthStore.shared.readDistanceRunningForDB(dateStart: startDateFinal!, dateEnd: endDateFinal!){success in
                if success{
                    DispatchQueue.main.async {
                        self.db.listOfHealthData.removeAll()
                        self.db.listOfHealthData = self.db.read()
                        for healthSample in HealthStore.shared.samplesToSyncDistanceRunning{
                            print(healthSample.sampleValue)
                            insertOrNot = true
                            for healthEntry in self.db.listOfHealthData{
                                if(healthSample.uuid == healthEntry.uuid){
                                    insertOrNot = false
                                }
                            }
                            if(insertOrNot){
                                self.db.insert(uuid: healthSample.uuid, sampleType: healthSample.sampleType, sampleValue: healthSample.sampleValue, startDate: healthSample.startDate, endDate: healthSample.endDate)
                            }
                        }
                        print("Synchronized Distance Running")
                        group.leave()
                    }
                }else{
                    DispatchQueue.main.async {
                        print("Big Sync Error Distance Running")
                        group.leave()
                    }
                }
            }
        }
        
        if(SynData.shared.selectedGoals.contains(Goal(name: "Distance Swimming"))){
            group.enter()
            HealthStore.shared.readDistanceSwimmingForDB(dateStart: startDateFinal!, dateEnd: endDateFinal!){success in
                if success{
                    DispatchQueue.main.async {
                        self.db.listOfHealthData.removeAll()
                        self.db.listOfHealthData = self.db.read()
                        for healthSample in HealthStore.shared.samplesToSyncDistanceSwimming{
                            print(healthSample.sampleValue)
                            insertOrNot = true
                            for healthEntry in self.db.listOfHealthData{
                                if(healthSample.uuid == healthEntry.uuid){
                                    insertOrNot = false
                                }
                            }
                            if(insertOrNot){
                                self.db.insert(uuid: healthSample.uuid, sampleType: healthSample.sampleType, sampleValue: healthSample.sampleValue, startDate: healthSample.startDate, endDate: healthSample.endDate)
                            }
                        }
                        print("Synchronized Distance Swimming")
                        group.leave()
                    }
                }else{
                    DispatchQueue.main.async {
                        print("Big Sync Error Distance Swimming")
                        group.leave()
                    }
                }
            }
        }
        
        if(SynData.shared.selectedGoals.contains(Goal(name: "Distance in wheelchair"))){
            group.enter()
            HealthStore.shared.readDistanceWheelchairForDB(dateStart: startDateFinal!, dateEnd: endDateFinal!){success in
                if success{
                    DispatchQueue.main.async {
                        self.db.listOfHealthData.removeAll()
                        self.db.listOfHealthData = self.db.read()
                        for healthSample in HealthStore.shared.samplesToSyncDistanceWheelchair{
                            print(healthSample.sampleValue)
                            insertOrNot = true
                            for healthEntry in self.db.listOfHealthData{
                                if(healthSample.uuid == healthEntry.uuid){
                                    insertOrNot = false
                                }
                            }
                            if(insertOrNot){
                                self.db.insert(uuid: healthSample.uuid, sampleType: healthSample.sampleType, sampleValue: healthSample.sampleValue, startDate: healthSample.startDate, endDate: healthSample.endDate)
                            }
                        }
                        print("Synchronized Distance Wheelchair")
                        group.leave()
                    }
                }else{
                    DispatchQueue.main.async {
                        print("Big Sync Error Distance Wheelchair")
                        group.leave()
                    }
                }
            }
        }
        
        if(SynData.shared.selectedGoals.contains(Goal(name: "Distance Cycling"))){
            group.enter()
            HealthStore.shared.readCyclingDistanceForDB(dateStart: startDateFinal!, dateEnd: endDateFinal!){success in
                if success{
                    DispatchQueue.main.async {
                        self.db.listOfHealthData.removeAll()
                        self.db.listOfHealthData = self.db.read()
                        for healthSample in HealthStore.shared.samplesToSyncDistanceCycling{
                            print(healthSample.sampleValue)
                            insertOrNot = true
                            for healthEntry in self.db.listOfHealthData{
                                if(healthSample.uuid == healthEntry.uuid){
                                    insertOrNot = false
                                }
                            }
                            if(insertOrNot){
                                self.db.insert(uuid: healthSample.uuid, sampleType: healthSample.sampleType, sampleValue: healthSample.sampleValue, startDate: healthSample.startDate, endDate: healthSample.endDate)
                            }
                        }
                        print("Synchronized Distance Cycling")
                        group.leave()
                    }
                }else{
                    DispatchQueue.main.async {
                        print("Big Sync Error Distance Cycling")
                        group.leave()
                    }
                }
            }
        }
        
        if(SynData.shared.selectedGoals.contains(Goal(name: "Heart Rate"))){
            group.enter()
            HealthStore.shared.readHeartRateForDB(dateStart: startDateFinal!, dateEnd: endDateFinal!){success in
                if success{
                    DispatchQueue.main.async {
                        self.db.listOfHealthData.removeAll()
                        self.db.listOfHealthData = self.db.read()
                        for healthSample in HealthStore.shared.samplesToSyncHeartRate{
                            print(healthSample.sampleValue)
                            insertOrNot = true
                            for healthEntry in self.db.listOfHealthData{
                                if(healthSample.uuid == healthEntry.uuid){
                                    insertOrNot = false
                                }
                            }
                            if(insertOrNot){
                                self.db.insert(uuid: healthSample.uuid, sampleType: healthSample.sampleType, sampleValue: healthSample.sampleValue, startDate: healthSample.startDate, endDate: healthSample.endDate)
                            }
                        }
                        print("Synchronized Heart Rate")
                        group.leave()
                    }
                }else{
                    DispatchQueue.main.async {
                        print("Big Sync Error Heart Rate")
                        group.leave()
                    }
                }
            }
        }
        
        if(SynData.shared.selectedGoals.contains(Goal(name: "Calories"))){
            group.enter()
            HealthStore.shared.readCaloriesForDB(dateStart: startDateFinal!, dateEnd: endDateFinal!){success in
                if success{
                    DispatchQueue.main.async {
                        self.db.listOfHealthData.removeAll()
                        self.db.listOfHealthData = self.db.read()
                        for healthSample in HealthStore.shared.samplesToSyncCalories{
                            print(healthSample.sampleValue)
                            insertOrNot = true
                            for healthEntry in self.db.listOfHealthData{
                                if(healthSample.uuid == healthEntry.uuid){
                                    insertOrNot = false
                                }
                            }
                            if(insertOrNot){
                                self.db.insert(uuid: healthSample.uuid, sampleType: healthSample.sampleType, sampleValue: healthSample.sampleValue, startDate: healthSample.startDate, endDate: healthSample.endDate)
                            }
                        }
                        print("Synchronized Calories")
                        group.leave()
                    }
                }else{
                    DispatchQueue.main.async {
                        print("Big Sync Error Calories")
                        group.leave()
                    }
                }
            }
        }
            
        
        group.notify(queue: .main) {
            HealthStore.shared.samplesToSyncSteps.removeAll()
            HealthStore.shared.samplesToSyncWater.removeAll()
            HealthStore.shared.samplesToSyncDistanceRunning.removeAll()
            HealthStore.shared.samplesToSyncDistanceSwimming.removeAll()
            HealthStore.shared.samplesToSyncDistanceWheelchair.removeAll()
            HealthStore.shared.samplesToSyncDistanceCycling.removeAll()
            HealthStore.shared.samplesToSyncHeartRate.removeAll()
            HealthStore.shared.samplesToSyncCalories.removeAll()
            self.db.listOfHealthData.removeAll()

                var popUpWindow: PopUpWindow!
                var stringSuccessSyn = ""
                if SynData.shared.selectedGoals.count == 1 && SynData.shared.selectedGoals.first!.name != "None"{
                    print(SynData.shared.selectedGoals.first!.name)
                    stringSuccessSyn = SynData.shared.selectedGoals.first!.name
                    popUpWindow = PopUpWindow(title: "Success", text: stringSuccessSyn + " were successfully synchronized with " + self.databaseSelected + ".", buttontext: "OK")
                    self.present(popUpWindow, animated: true, completion: nil)
                }else if SynData.shared.selectedGoals.count == 1 && SynData.shared.selectedGoals.first!.name == "None"{
                    popUpWindow = PopUpWindow(title: "Error", text: "There were no elements chosen to be synchronized.", buttontext: "OK")
                    self.present(popUpWindow, animated: true, completion: nil)
                }else{
                    var isFirst = true
                    for goal in SynData.shared.selectedGoals{
                        if isFirst{
                            stringSuccessSyn = goal.name
                            isFirst = false
                            continue
                        }
                        stringSuccessSyn = stringSuccessSyn + ", " + goal.name
                    }
                    popUpWindow = PopUpWindow(title: "Success", text: stringSuccessSyn + " were successfully synchronized with " + self.databaseSelected + ".", buttontext: "OK")
                    self.present(popUpWindow, animated: true, completion: nil)
                }
        }
                /*HealthStore.shared.readStepsForDB(dateStart: startDateFinal!, dateEnd: endDateFinal!){success in
                    if success{
                        DispatchQueue.main.async {

                            HealthStore.shared.samplesToSyncSteps.removeAll()
                            HealthStore.shared.samplesToSyncWater.removeAll()
                            self.db.listOfHealthData.removeAll()

                                var popUpWindow: PopUpWindow!
                                var stringSuccessSyn = ""
                                if SynData.shared.selectedGoals.count == 1 && SynData.shared.selectedGoals.first!.name != "None"{
                                    print(SynData.shared.selectedGoals.first!.name)
                                    stringSuccessSyn = SynData.shared.selectedGoals.first!.name
                                    popUpWindow = PopUpWindow(title: "Success", text: stringSuccessSyn + " were successfully synchronized with " + self.databaseSelected + ".", buttontext: "OK")
                                    self.present(popUpWindow, animated: true, completion: nil)
                                }else if SynData.shared.selectedGoals.count == 1 && SynData.shared.selectedGoals.first!.name == "None"{
                                    popUpWindow = PopUpWindow(title: "Error", text: "There were no elements chosen to be synchronized.", buttontext: "OK")
                                    self.present(popUpWindow, animated: true, completion: nil)
                                }else{
                                    var isFirst = true
                                    for goal in SynData.shared.selectedGoals{
                                        if isFirst{
                                            stringSuccessSyn = goal.name
                                            isFirst = false
                                            continue
                                        }
                                        stringSuccessSyn = stringSuccessSyn + ", " + goal.name
                                    }
                                    popUpWindow = PopUpWindow(title: "Success", text: stringSuccessSyn + " were successfully synchronized " + self.databaseSelected + ".", buttontext: "OK")
                                    self.present(popUpWindow, animated: true, completion: nil)
                                }
                            }
                        //}
                    }else{
                        DispatchQueue.main.async {
                            print("Big Sync Error PopUp and Garbage Collection")
                        }
                    }
        }*/


        
        
        
        //db.insert(uuid: "pokus 8", sampleType: "nevie3", sampleValue: 12.5, startDate: startDateFinal!, endDate: endDateFinal!)
        //db.read()
    }

    /*override func viewWillAppear(_ animated: Bool) {
       
        let userDefault = UserDefaults.standard
        databaseSelected.text = (userDefault.value(forKey: "databaseSelected") as? String)
        selectedRow = (userDefault.value(forKey: "selectedRow") as? Int ?? 0)
        
        /*if let previousSelection:Int = UserDefaults.standard.integer(forKey: "databasePickerSelected") as? Int{
            self.setLabelsForChoice(_choice: previousSelection)
        }*/
        
        UserDefaults.standard.synchronize()
        
    }*/
    

    /*@IBAction func checkBoxWater(_ sender: UIButton) {
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
    }
    
    
    @IBAction func checkBoxSteps(_ sender: UIButton) {
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
    }*/
    
    /*@IBAction func helpPrint(_ sender: UIButton) {
        print(TaskEditView)
    }*/
    
    /*@IBAction func testOnClick(_ sender: UIButton) {
        self.db.insert(name: "Martin", randomNum: 15)
        self.db.read(randomNum: 4)
    }*/
}

struct healthModelSample{
    var uuid : String
    var sampleType : String
    var sampleValue : Double
    var startDate : Date
    var endDate : Date
}

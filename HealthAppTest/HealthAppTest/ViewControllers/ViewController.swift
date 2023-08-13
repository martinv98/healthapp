//
//  ViewController.swift
//  HealthAppTest
//
//  Created by Martin Varga on 13/12/2021.
//

import UIKit

/*extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        typeSelected.text = healthTypes[row]
    }
}

extension ViewController: UITextFieldDelegate{
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
}*/

class ViewController: UIViewController{
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var synButton: UIButton!
    
    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HealthStore.shared.requestAuthorization{success in
            if success{
                print("Authorization successful")
            }else{
                print("Authorization unsuccessful")
            }
        // Do any additional setup after loading the view.
        }
        //logo.contentMode = .scaleAspectFill
        
        
        view.backgroundColor = hexStringToUIColor(hex: "#0D051B")
        
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
        
        showButton.setTitle("Show Value", for: .normal)
        showButton.setTitleColor(.black, for: .normal)
        showButton.backgroundColor = hexStringToUIColor(hex: "#4FD3C4")
        showButton.layer.cornerRadius = 25
        //showButton.clipsToBounds = true
        showButton.titleLabel?.font = UIFont(name: "GillSans", size: 40)
        showButton.titleLabel?.minimumScaleFactor = 0.2
        showButton.titleLabel?.numberOfLines = 1
        showButton.titleLabel?.adjustsFontSizeToFitWidth = true
        showButton.titleLabel?.textAlignment = .center
        //showButton.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        
        synButton.setTitle("Synchronize", for: .normal)
        synButton.setTitleColor(.black, for: .normal)
        synButton.backgroundColor = hexStringToUIColor(hex: "#4FD3C4")
        synButton.layer.cornerRadius = 25
        //synButton.clipsToBounds = true
        synButton.titleLabel?.font = UIFont(name: "GillSans", size: 40)
        synButton.titleLabel?.minimumScaleFactor = 0.2
        synButton.titleLabel?.numberOfLines = 2
        synButton.titleLabel?.adjustsFontSizeToFitWidth = true
        synButton.titleLabel?.textAlignment = .center
        //synButton.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    /*let healthTypes = ["Water","Steps"]
    @IBOutlet weak var shownValue: UITextField?
    @IBOutlet weak var typeSelected: UITextField!
    @IBOutlet weak var waterLabel: UITextField?
    @IBOutlet weak var stepLabel: UITextField?
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var updateButton: UIButton?
    @IBOutlet weak var writeButton: UIButton?
    //var picker = UIPickerView()
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var dateStart: UITextField!
    @IBOutlet weak var dateEnd: UITextField!
    
    let datePickerStart = UIDatePicker()
    let datePickerEnd = UIDatePicker()
    //let dateTest = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        HealthStore.shared.requestAuthorization{success in
            if success{
                print("Authorization successful")
            }else{
                print("Authorization unsuccessful")
            }
        }
        if dateStart.text!.isEmpty{
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            
            dateStart.text = formatter.string(from: Date())
        }
        if dateEnd.text!.isEmpty{
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            
            dateEnd.text = formatter.string(from: Date())
        }
        
        picker.delegate = self
        picker.dataSource = self
        
        inputText.delegate = self
        
        createDatePickerStart()
        createDatePickerEnd()
        // Do any additional setup after loading the view.
    }
    
    /*@IBAction func nextView(){
        guard let synDataView = storyboard?.instantiateViewController(withIdentifier: "SynDataView") as? SynDataView else{
            return
        }
        present(synDataView, animated: true)
    }*/
    
    func createDatePickerStart(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        dateStart.inputAccessoryView = toolbar
        dateStart.inputView = datePickerStart
        datePickerStart.datePickerMode = .date
    }
    
    func createDatePickerEnd(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedEnd))
        toolbar.setItems([doneBtn], animated: true)
        
        dateEnd.inputAccessoryView = toolbar
        dateEnd.inputView = datePickerEnd
        datePickerEnd.datePickerMode = .date
    }
    
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        dateStart.text = formatter.string(from: datePickerStart.date)
        self.view.endEditing(true)
    }
    
    @objc func donePressedEnd(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        dateEnd.text = formatter.string(from: datePickerEnd.date)
        self.view.endEditing(true)
    }
    
    @IBAction func updateShownValue(_ sender: UIButton) {
        switch typeSelected.text {
        case healthTypes[0]:
            HealthStore.shared.readWater(dateStart: datePickerStart.date, dateEnd: datePickerEnd.date){success in
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
        case healthTypes[1]:
            HealthStore.shared.readSteps(dateStart: datePickerStart.date, dateEnd: datePickerEnd.date){success in
                if success{
                    DispatchQueue.main.async {
                        self.shownValue?.text = HealthStore.shared.stepLabel
                    }
                }else{
                    DispatchQueue.main.async {
                        self.shownValue?.text = HealthStore.shared.stepLabel
                    }
                    print("daco nedobre zase")
                }
            }
        default:
            print("nwm")
        }
    }
    
    @IBAction func writeClicked(_ sender: UIButton) {
        switch typeSelected.text {
        case healthTypes[0]:
            HealthStore.shared.writeWater(waterConsumed: (inputText.text! as NSString).doubleValue, dateStart: datePickerStart.date, dateEnd: datePickerEnd.date){success in
                if success{
                    print("voda sa uspesne ulozila")
                }else{
                    print("voda sa neulozila")
                }
            }
        case healthTypes[1]:
            HealthStore.shared.writeSteps(stepCountValue: (inputText.text! as NSString).doubleValue, dateStart: datePickerStart.date, dateEnd: datePickerEnd.date){success in
                if success{
                    print("kroky sa uspesne ulozili")
                }else{
                    print("kroky sa neulozili")
                }
            }
        default:
            print("nwm")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputText.resignFirstResponder()
        self.view.endEditing(true)
    }*/

}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

extension UIStackView {
    func customize(backgroundColor: UIColor = .clear, radiusSize: CGFloat = 0) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = backgroundColor
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)

        subView.layer.cornerRadius = radiusSize
        subView.layer.masksToBounds = true
        subView.clipsToBounds = true
    }
}

extension UIStackView {
     func insertViewIntoStack(background: UIColor, cornerRadius: CGFloat, borderColor: CGColor, borderWidth: CGFloat) {
        let subView = UIView(frame: bounds)
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subView.layer.cornerRadius = cornerRadius
        subView.backgroundColor = background
        subView.layer.borderColor = borderColor
        subView.layer.borderWidth = borderWidth
        insertSubview(subView, at: 0)
    }
}


//
//  SignUpViewController.swift
//  AdidasEvents
//
//  Created by Alberto Velaz Moliner on 16/10/2016.
//  Copyright © 2016 Alberto. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class SignUpViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let emailInput = Utils.inputText(placeholder: NSLocalizedString("prompt_email", comment: ""))
    let firstNameInput = Utils.inputText(placeholder: NSLocalizedString("prompt_firstname", comment: ""))
    let lastNameInput = Utils.inputText(placeholder: NSLocalizedString("prompt_lastname", comment: ""))
    let birthDateInput = Utils.inputText(placeholder: NSLocalizedString("prompt_birthdate", comment: ""))
    let countryInput = Utils.inputText(placeholder: NSLocalizedString("select_country", comment: ""))
    let sendBtn = UIButton(type: .system)
    
    let datePicker = UIDatePicker.init()
    
    let countryPicker = UIPickerView.init()
    let countries = Utils.getCountries()
    let toolBar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false;
        
        self.tableView.allowsSelection = false;
        self.tableView.separatorStyle = .none
        
        emailInput.keyboardType = .emailAddress
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        self.tableView.addGestureRecognizer(tapGesture)
        
        setupToolbar()
        setupDatePicker()
        setupCountryPicker()
        setupSendBtn()
    }
    
    func setupToolbar()  {
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action:  #selector(SignUpViewController.selfEdition))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

    }
    func setupDatePicker() {
        datePicker.date = NSDate.init() as Date
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        birthDateInput.inputView = datePicker
        birthDateInput.inputAccessoryView = toolBar
    }
    
    func dateChanged() {
        birthDateInput.text = Utils.formatDateRegular(date: datePicker.date as NSDate)
    }
    
    func selfEdition() {
        self.view.endEditing(true)
    }
    
    func hideKeyboard() {
        tableView.endEditing(true)
    }
    
    func setupCountryPicker() {
        countryPicker.delegate = self;
        countryPicker.dataSource = self;
        countryInput.inputView = countryPicker
        countryInput.inputAccessoryView = toolBar
    }
    
    func setupSendBtn() {
        let width = self.view.frame.width - 20;
        let rect = CGRect (x: 10, y: 10, width: width, height: 40)
        sendBtn.frame = rect;
        sendBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24.0)
        sendBtn.setTitle(NSLocalizedString("action_sign_up", comment: ""), for: UIControlState.normal)
        sendBtn.addTarget(self, action: #selector(SignUpViewController.checkFields), for: UIControlEvents.touchUpInside)
    }
    
    func checkFields() {
        var cancel = false;
        var message = "";
        
        let userEmail = emailInput.text! as String
        let userFirstName = firstNameInput.text! as String
        let userLastName = lastNameInput.text! as String
        let userBirthdate = birthDateInput.text! as String
        let userCountry = countryInput.text! as String
        
        let validEmail = Utils.isValidEmail(testStr: userEmail)
        if userEmail.isEmpty {
            message += NSLocalizedString("error_email_required", comment: "")
            message += "\n"
            cancel = true
        } else if userEmail.characters.count < 3 {
            message += NSLocalizedString("error_min_chars_email", comment: "")
            message += "\n"
            cancel = true
        } else if !validEmail {
            message += NSLocalizedString("error_invalid_email", comment: "")
            message += "\n"
            cancel = true
        }
        
        if userFirstName.isEmpty {
            message += NSLocalizedString("error_firstName_required", comment: "")
            message += "\n"
            cancel = true
        } else if userFirstName.characters.count < 3 {
            message += NSLocalizedString("error_min_chars_first", comment: "")
            message += "\n"
            cancel = true
        }
        
        if userLastName.isEmpty {
            message += NSLocalizedString("error_lastName_required", comment: "")
            message += "\n"
            cancel = true
        } else if userLastName.characters.count < 3 {
            message += NSLocalizedString("error_min_chars_last", comment: "")
            message += "\n"
            cancel = true
        }
        
        if userBirthdate.isEmpty {
            message += NSLocalizedString("error_birthdate_required", comment: "")
            message += "\n"
            cancel = true
        }
        
        if userCountry.isEmpty {
            message += NSLocalizedString("error_country_required", comment: "")
            cancel = true
        }
        
        if cancel {
            showErrorAlert(message: message)
        } else {
            sendData()
        }
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendData() {
        SVProgressHUD.show()
        let parameters: Parameters = [
            "token" : Constants.TOKEN,
            "email" : emailInput.text,
            "firstName" : firstNameInput.text,
            "lastName" : lastNameInput.text,
            "date" : birthDateInput.text,
            "country" : countryInput.text
        ]
        let url = Constants.API_BASE_URL + "runner"
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            
            SVProgressHUD.dismiss()
            
            let value = response.result.value as? [String: AnyObject]
            if ((value?["error"]) != nil) {
                let errorMessage = value?["error"] as! String
                self.showErrorAlert(message: errorMessage)
            } else {
                let message = value?["message"] as! String
                let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: .default, handler: { (action) in
                    self.clearFields();
                }))
                alert.addAction(UIAlertAction(title: NSLocalizedString("no", comment: ""), style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                    let _ = self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func clearFields() {
        emailInput.text = "";
        firstNameInput.text = "";
        lastNameInput.text = "";
        birthDateInput.text = "";
        countryInput.text = "";
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "input", for: indexPath)
        
        cell.accessoryType = .none
        if indexPath.row == 0 {
            cell.addSubview(emailInput)
        } else if indexPath.row == 1 {
            cell.addSubview(firstNameInput)
        }  else if indexPath.row == 2 {
            cell.addSubview(lastNameInput)
        } else if indexPath.row == 3 {
            cell.addSubview(birthDateInput)
        } else if indexPath.row == 4 {
            cell.addSubview(countryInput)
        } else if indexPath.row == 5 {
            cell.addSubview(sendBtn)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    /*UIPickerView Methods*/
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryInput.text = countries[row] as? String
    }
    
    
    
}

//
//  Utils.swift
//  AdidasEvents
//
//  Created by Alberto Velaz Moliner on 16/10/2016.
//  Copyright © 2016 Alberto. All rights reserved.
//

import UIKit

let dateFormatterRegular = DateFormatter.init()

class Utils: NSObject {

    static func inputText(placeholder: String) -> UITextField {
        let rect = CGRect(origin: CGPoint(x: 10,y :10), size: CGSize(width: 210, height: 32))
        let input = UITextField.init(frame: rect)
        input.placeholder = placeholder.uppercased()
        return input
    }
    
    static func formatDateRegular(date: NSDate) -> String {
        dateFormatterRegular.dateStyle = .short
        dateFormatterRegular.timeStyle = .none
        return dateFormatterRegular.string(from: date as Date)
    }
    
    static func getCountries() -> NSArray {
        var countries: [String] = []
        
        for code in NSLocale.isoCountryCodes as [String] {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countries.append(name)
        }
        
        let sortedCountries = countries.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        
        return sortedCountries as NSArray
    }
    
    static func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "^[\\w!#$%&'*+/=?`{|}~^-]+(?:\\.[\\w!#$%&'*+/=?`{|}~^-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,6}$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

}

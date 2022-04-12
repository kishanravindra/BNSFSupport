//
//  Helper.swift
//  BNSFVVIPSupport
//
//  Created by KishanRavindra on 23/11/21.
//

import UIKit

class Helper: NSObject {
    static let sharedHelper = Helper()
    
    func savePhoneNumbers(lPhoneNumbers: [String]) {
        print(lPhoneNumbers)
        let defaults =  UserDefaults.standard
        defaults.removeObject(forKey: CONSTANTS.USERDEFAULT_KEYS.PHONE_NUMBERS)
        defaults.set(lPhoneNumbers, forKey: CONSTANTS.USERDEFAULT_KEYS.PHONE_NUMBERS)
        defaults.synchronize()
    }
    
    func getPhoneNumbers() -> [String]? {
        if let phoneNumbers =  UserDefaults.standard.object(forKey: CONSTANTS.USERDEFAULT_KEYS.PHONE_NUMBERS) as? [String] {
            return phoneNumbers
        }
        return nil
    }
    
    
    func saveEmails(lEmails: [String]) {
        print(lEmails)
        let defaults =  UserDefaults.standard
        defaults.removeObject(forKey: CONSTANTS.USERDEFAULT_KEYS.EMAILS)
        defaults.set(lEmails, forKey: CONSTANTS.USERDEFAULT_KEYS.EMAILS)
        defaults.synchronize()
    }
    
    func getEmails() -> [String]? {
        if let phoneNumbers =  UserDefaults.standard.object(forKey: CONSTANTS.USERDEFAULT_KEYS.EMAILS) as? [String] {
            return phoneNumbers
        }
        return nil
    }
    
    //MARK:- Default Alert.....
    func showDefaultAlert(controller: UIViewController, title: String?, message: String?, defaultButtonTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: defaultButtonTitle, style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
    func randomNameString(length: Int = 7)->String
    {
        enum s {
            static let c = Array("abcdefghjklmnpqrstuvwxyz12345789")
            static let k = UInt32(c.count)
        }
        var result = [Character](repeating: "-", count: length)
        for i in 0..<length {
            let r = Int(arc4random_uniform(s.k))
            result[i] = s.c[r]
        }
        return String(result)
    }
    
    func checkIfEmailIsValid(email: String) -> Bool {
          let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
          let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
          return emailTest.evaluate(with: email)
      }
}

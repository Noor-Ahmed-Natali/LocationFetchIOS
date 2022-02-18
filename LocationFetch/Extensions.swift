//
//  Extensions.swift
//  LocationFetch
//
//  Created by differenz189 on 18/02/22.
//

import Foundation

extension UserDefaults {
    // To Set Data in UserDefault
    func setData<T: Codable>(_ data: T, _ key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        }
    }
    
    // To get Data from UserDefault
    func getData<T: Codable>(_ key: String, data: T.Type) -> T? {
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            let loadedPerson = try? decoder.decode(data, from: savedPerson)
            return loadedPerson
        } else {
            print("Error")
            return nil
        }
    }
    
    func removeAll() {
        let domain = Bundle.main.bundleIdentifier!
        removePersistentDomain(forName: domain)
        synchronize()
    }
}



struct Validations {
    
    // Check Null
    static func isNull(_ value: Any?) -> Bool {
        
        if value is String {
            if (value as? String == "" || value == nil) { return true }
        }
        if (value == nil) { return true }
        return false
    }
    
    static func isValidValue(_ value:String?,_ regex:String) -> Bool {
        if isNull(value){ return false }
        let data = NSPredicate(format:"SELF MATCHES %@", regex)
        return data.evaluate(with: value)
    }
    
    static func isMobileNumber(withNumber number: String?) -> Bool {
        if self.isNull(number) { return false }
        if !self.isValidValue(number, "^[0-9]{10}$") { return false}
        return true
    }
}

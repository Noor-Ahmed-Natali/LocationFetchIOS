//
//  ViewController.swift
//  LocationFetch
//
//  Created by differenz189 on 18/02/22.
//

let userDefaults = UserDefaults.standard
let udUser = "MyUser"

struct UserModel: Codable {
    var userName: String?
    var mobileNumber: String?
}


import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var txtfldMobileNumber: UITextField!
    @IBOutlet weak var txtfldUserName: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    private var userData: UserModel = UserModel()
    private let alert = UIAlertController(title: "Login", message: "Please Enter Proper Data", preferredStyle: .alert)
    let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        alert.addAction(ok)
    }

    @IBAction func btnClickLogin(_ sender: Any) {
        userData.mobileNumber =  txtfldMobileNumber.text?.trimmingCharacters(in: .whitespaces)
        userData.userName = txtfldUserName.text?.trimmingCharacters(in: .whitespaces)
        if isValid() {
            userDefaults.setData(userData, udUser)
            let myHome = homeVC
            myHome.modalPresentationStyle = .overCurrentContext
            self.present(myHome, animated: false)
        } else {
           
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func isValid() -> Bool {
        if Validations.isNull(userData.userName) { return false }
        if !Validations.isMobileNumber(withNumber: userData.mobileNumber) { return false}
        return true
    }
}




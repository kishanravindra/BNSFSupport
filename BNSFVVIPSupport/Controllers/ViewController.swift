//
//  ViewController.swift
//  BNSFVVIPSupport
//
//  Created by KishanRavindra on 23/11/21.
//

import UIKit
import SCLAlertView
import FirebaseDatabase
import MessageUI
import ProgressHUD

class ViewController: UIViewController,UITextFieldDelegate,MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var accessTextField: RoundedTextField!
    @IBOutlet weak var phoneViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneView: UIView!
    
    @IBOutlet weak var phoneBtn1:UIButton!
    @IBOutlet weak var phoneBtn2:UIButton!
    @IBOutlet weak var phoneBtn3:UIButton!
    @IBOutlet weak var accessBtn:UIButton!
    var ref: DatabaseReference!
    var isFromCall = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpView()
        ProgressHUD.show()
        ref = Database.database().reference()
        self.ref.child("phoneNumbers").observe(.value, with: { snapshot in
            if let numbers = snapshot.value as? NSArray  {
                ProgressHUD.dismiss()
                Helper.sharedHelper.savePhoneNumbers(lPhoneNumbers: numbers as! [String])
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
   
    
    @IBAction func buttonActions(_ sender: UIButton) {
        switch sender.tag {
        case 10:
            self.animatePhoneView(constValue: 220)
        case 20:
            self.isFromCall = false
            self.animatePhoneView(constValue: 220)
        case 30:
            self.performSegue(withIdentifier: "ShowTicketForm", sender: self)
        case 40:
            showAlertWithTextField()

        default:
            self.animatePhoneView(constValue: 0)
        }
    }
    
    @IBAction func CallBtnAction(_ sender: UIButton) {
        guard !isFromCall else {
            if let phoneNumbers = Helper.sharedHelper.getPhoneNumbers() {
                self.makePhoneCall(number: phoneNumbers[sender.tag])
            }
            return
        }
        //send sms
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Message Body"
            if let phoneNumbers = Helper.sharedHelper.getPhoneNumbers() {
                controller.recipients = [phoneNumbers[sender.tag]]
            }
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        
    }
    
    //MARK: Message Delegate
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
      }

    
    //MARK:-TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.accessTextField.resignFirstResponder()
        return true
    }
    
    private func showAlertWithTextField() {
        let alertController = UIAlertController(title: "Dashboard Access", message: "", preferredStyle: .alert)
           alertController.addTextField { (textField : UITextField!) -> Void in
               textField.placeholder = "Enter Access Code"
           }

           let saveAction = UIAlertAction(title: "Submit", style: .default, handler: { alert -> Void in
               if let textField = alertController.textFields?[0] {
                   if let accessCode = textField.text {
                       print("Text :: \(accessCode)")
                       self.validateAccessCodeAndShowDashboard(accessCode)
                   }
               }
           })

           let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
               (action : UIAlertAction!) -> Void in })
           alertController.addAction(cancelAction)
           alertController.addAction(saveAction)
           alertController.preferredAction = saveAction
           self.present(alertController, animated: true, completion: nil)
    }
}

extension ViewController {
    
    private func setUpView() {
        if let phoneNumbers = Helper.sharedHelper.getPhoneNumbers() {
            self.phoneBtn1.setTitle(phoneNumbers[0], for: .normal)
            self.phoneBtn2.setTitle(phoneNumbers[1], for: .normal)
            self.phoneBtn3.setTitle(phoneNumbers[2], for: .normal)
        }
    }
    
    private func animatePhoneView(constValue:CGFloat) {
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseIn, animations: {
            self.phoneViewHeightConstraint.constant = constValue
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func makePhoneCall(number: String) {
        if let url = URL(string: "tel://\(number)"),
           UIApplication.shared.canOpenURL(url) {
              if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
               } else {
                   UIApplication.shared.openURL(url)
               }
           } else {
            Helper.sharedHelper.showDefaultAlert(controller: self, title: "Oops!", message: "Unable to call!", defaultButtonTitle: "Ok")
           }
    }
    
    private func validateAccessCodeAndShowDashboard(_ accessCode: String) {
            if accessCode == CONSTANTS.ACCESS_CODE.CODE {
                print("Access Granted")
                self.performSegue(withIdentifier: "ShowDashboard", sender: self)
            } else {
                Helper.sharedHelper.showDefaultAlert(controller: self, title: "Oops!", message: "Invalid Access Code", defaultButtonTitle: "Ok")
            }
    }
}


extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

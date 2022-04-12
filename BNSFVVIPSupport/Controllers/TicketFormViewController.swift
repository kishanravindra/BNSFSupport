//
//  TicketFormViewController.swift
//  BNSFVVIPSupport
//
//  Created by KishanRavindra on 23/11/21.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import ProgressHUD
import DateTimePicker
import RSSelectionMenu


class TicketFormViewController: UIViewController,UITextViewDelegate,DateTimePickerDelegate, BSDropDownDelegate {
   
    var imagePicker: ImagePicker!
    var ref: DatabaseReference!
    var ticketImageUrl:String?

    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var nameTextField: RoundedTextField!
    @IBOutlet weak var emailTextField: RoundedTextField!
    @IBOutlet weak var dateTextField: RoundedTextField!
    @IBOutlet weak var connectTextField: RoundedTextField!
    @IBOutlet weak var descriptionTextField: RoundedTextView!
    @IBOutlet weak var connectView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        descriptionTextField.delegate = self
        descriptionTextField.text = "Description..."
        descriptionTextField.textColor = UIColor.lightGray
    
    }
    
    @IBAction func showImagePicker(_ sender: UIButton) {
            self.imagePicker.present(from: sender)
    }
    
    
    @IBAction func saveTicketBtnPressed(_ sender: Any) {
        
        
        
        guard let lName = nameTextField.text, !lName.isEmpty, let lEmail = emailTextField.text, !lEmail.isEmpty, let lDate = dateTextField.text, !lDate.isEmpty, let lConnect = connectTextField.text, !lConnect.isEmpty, let imageStr = ticketImageUrl, !imageStr.isEmpty, let lDescp = descriptionTextField.text, lDescp.count > 0 else {
            Helper.sharedHelper.showDefaultAlert(controller: self, title: "Psssst!", message: "Looks like you have not entered enough information.", defaultButtonTitle: "OK")
                return
        }
        
        var ticketDict = [String: Any]()
        if let lName = self.nameTextField.text {
            print(lName.count)
            guard lName.count > 2 else {
                Helper.sharedHelper.showDefaultAlert(controller: self, title: "Warning!" , message: "Name should contain more than 2 characters", defaultButtonTitle: "Ok")
                return
            }
            ticketDict["name"] = lName
        }
        if let lEmail = self.emailTextField.text {
            guard Helper.sharedHelper.checkIfEmailIsValid(email: lEmail) else {
                Helper.sharedHelper.showDefaultAlert(controller: self, title: "Warning!" , message: "Invalid Email!", defaultButtonTitle: "Ok")
                return
            }
            ticketDict["email"] = lEmail
        }
        if let lDate = self.dateTextField.text {
            ticketDict["date"] = lDate
        }
        if let lConnect = self.connectTextField.text {
            ticketDict["connect"] = lConnect
        }
        if let descp = self.descriptionTextField.text {
            ticketDict["descp"] = descp
        }
        if let imageUrl = self.ticketImageUrl {
            ticketDict["ticketImage"] = imageUrl
        }
        ProgressHUD.show("Creating Ticket...")
                
        self.ref.child("tickets").childByAutoId().setValue(ticketDict) { error, ref in
            print(ref)
            ProgressHUD.dismiss()
            self.navigationController?.popViewController(animated: true)
        }

    }
    
    //MARK: TextView Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextField.textColor == UIColor.lightGray {
            descriptionTextField.text = nil
            descriptionTextField.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextField.text.isEmpty{
            descriptionTextField.text = "Description..."
            descriptionTextField.textColor = UIColor.lightGray
        }
    }
    
    //MARK:
    @IBAction func dateBtnPressed(_ sender: Any) {
        let min = Date()
        let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
        let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
        picker.is12HourFormat = true
        picker.dateFormat = "dd MMM YYYY, h:mm aa"
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "DONE"
        picker.doneBackgroundColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.completionHandler = { date in
            print(date)
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM YYYY, h:mm aa"
            self.dateTextField.text = formatter.string(from: date)
        }
        picker.delegate = self
        picker.show()
    }
    
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        print(didSelectDate)
    }
    
    @IBAction func dropDownBtnPressed(_ sender: Any) {
        let dropDown = BSDropDown(width: 120, withHeightForEachRow: 40, originPoint: self.connectView.center, withOptions: CONSTANTS.NUMBERS.CONNECT)
        dropDown?.delegate=self;
        dropDown?.setDropDownBGColor(UIColor(red: 1.0, green: 0.40, blue: 0.10, alpha: 1))
        self.view.addSubview(dropDown!)
    }
    
    func dropDownView(_ ddView: UIView!, at selectedIndex: Int) {
        self.connectTextField.text = CONSTANTS.NUMBERS.CONNECT[selectedIndex]
    }
}

extension TicketFormViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        print(image ?? "")
        self.imageView.image = image
        let imageName = Helper.sharedHelper.randomNameString(length: 6)
        ProgressHUD.show("Uploading...")
        self.uploadMedia(imageName: imageName) { lImageUrl in
            ProgressHUD.dismiss()
            if let imageUrlString = lImageUrl {
                self.ticketImageUrl = imageUrlString
            }
        }
    }
    
    func uploadMedia(imageName: String, completion: @escaping (_ url: String?) -> Void) {
        let storageRef = Storage.storage().reference().child("\(imageName).png")
        if let uploadData = self.imageView.image?.jpegData(compressionQuality: 0.5) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    storageRef.downloadURL(completion: { (url, error) in
                        print(url?.absoluteString ?? "")
                        completion(url?.absoluteString)
                    })
                }
            }
        }
    }
    
}

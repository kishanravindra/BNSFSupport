//
//  TicketDetailsViewController.swift
//  BNSFVVIPSupport
//
//  Created by KishanRavindra on 04/01/22.
//

import UIKit
import Kingfisher
import FirebaseDatabase
import ProgressHUD
import MessageUI

class TicketDetailsViewController: UIViewController,BSDropDownDelegate,MFMailComposeViewControllerDelegate {
    
    var ticket:Tickets?
    var ref: DatabaseReference!

    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var connectLabel: UILabel!
    @IBOutlet weak var descriptionLabel: RoundedTextView!
    @IBOutlet weak var assignBtn:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getSavedEmails()
        print(ticket ?? "No ticket")
        self.title =  "Issue Details"
        if let ticketDetails = ticket {
            self.nameLabel.text = "Name: \(ticketDetails.name)"
            self.emailLabel.text = "Email: \(ticketDetails.email)"
            self.dateLabel.text = "Ticket created date: \(ticketDetails.date)"
            self.connectLabel.text = "Best way to connect : \(ticketDetails.connect)"
            self.descriptionLabel.text = ticketDetails.descp
            self.imageView.kf.setImage(with: URL(string: ticketDetails.ticketImage), placeholder: UIImage(named: "imageThumbnail.png"))
        }
    }

    @IBAction func assignTicketBtnPressed(_ sender: Any) {
        if let emails = Helper.sharedHelper.getEmails() {
            let dropDown = BSDropDown(width:Float(self.assignBtn.frame.size.width), withHeightForEachRow: 40, originPoint: CGPoint(x: self.assignBtn.frame.origin.x, y: self.assignBtn.frame.origin.y + 40), withOptions: emails)
            dropDown?.delegate=self;
            dropDown?.setDropDownBGColor(UIColor(red: 1.0, green: 0.40, blue: 0.10, alpha: 1))
            self.view.addSubview(dropDown!)
        }
    }
    
    func dropDownView(_ ddView: UIView!, at selectedIndex: Int) {
        if let emails = Helper.sharedHelper.getEmails() {
            let selectedEmail = emails[selectedIndex]
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([selectedEmail])
                mail.setSubject("Issue: BNSF Ticket")
                if let ticketDetails = self.ticket {
                    mail.setMessageBody("<html><body><h3>Issue created by: \(ticketDetails.name)</h3> <h4>Customer email: \(ticketDetails.email)</h4><hr /> <p>Issue created on:\(ticketDetails.date)</p><p>Best way to connect customer through:\(ticketDetails.connect)</p> <p>Issue Description: \(ticketDetails.descp)</p><img src=\(ticketDetails.ticketImage) width=200 height=200 alt=\(ticketDetails.name)/></body></html>", isHTML: true)
                }
                
                present(mail, animated: true)
            } else {
                Helper.sharedHelper.showDefaultAlert(controller: self, title: "Failed", message: "Cannot open mail composer", defaultButtonTitle: "Ok")
            }
        }
    }
    
    //MARK: Mail Delegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func getSavedEmails() {
        ProgressHUD.show()
        ref = Database.database().reference()
        self.ref.child("emails").observe(.value, with: { snapshot in
            if let emails = snapshot.value as? NSArray  {
                ProgressHUD.dismiss()
                Helper.sharedHelper.saveEmails(lEmails: emails as! [String])
            }
        })
    }
}

//
//  DashboardViewController.swift
//  BNSFVVIPSupport
//
//  Created by KishanRavindra on 03/01/22.
//

import UIKit
import FirebaseDatabase
import ProgressHUD
import Kingfisher


class DashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var dashboardTableview: UITableView!
    var ref: DatabaseReference!
    var tickets = [Tickets]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHUD.show("Fetching Tickets...")
        ref = Database.database().reference()
        self.ref.child("tickets").observe(.value, with: { snapshot in
            guard let children = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            for child in children {
                let orderID = child.key as String
                self.ref.child("tickets/\(orderID)").observe(.value, with: { snapshot in
                    print(snapshot)
                    let ticket = Tickets(connect:  snapshot.childSnapshot(forPath: "connect").value as! String, date:  snapshot.childSnapshot(forPath: "date").value as! String, descp:  snapshot.childSnapshot(forPath: "descp").value as! String, email:  snapshot.childSnapshot(forPath: "email").value as! String, name:  snapshot.childSnapshot(forPath: "name").value as! String, ticketImage:  snapshot.childSnapshot(forPath: "ticketImage").value as! String)
                    self.tickets.append(ticket)
                    ProgressHUD.dismiss()
                    DispatchQueue.main.async {
                        self.dashboardTableview.reloadData()
                    }
                })
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DashboardTableViewCell
        let ticket = self.tickets[indexPath.row]
        cell.ticketNum.text = "Ticket #\(indexPath.row + 1)"
        cell.dateLabel.text = "Created at: \(ticket.date)"
        cell.ticketDesp.text = ticket.descp
        cell.ticketImage.kf.setImage(with: URL(string: ticket.ticketImage), placeholder: UIImage(named: "imageThumbnail.png"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ticketDetails", sender: self.tickets[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ticketDetails" {
            let detailsTicketVc = segue.destination as? TicketDetailsViewController
            detailsTicketVc?.ticket = sender as? Tickets
        }
    }
    
}

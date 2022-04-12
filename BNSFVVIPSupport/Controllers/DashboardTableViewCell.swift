//
//  DashboardTableViewCell.swift
//  BNSFVVIPSupport
//
//  Created by KishanRavindra on 03/01/22.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {

    @IBOutlet weak var ticketNum: UILabel!
    @IBOutlet weak var ticketDesp: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ticketImage: UIImageView!
    @IBOutlet weak var ticketType: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

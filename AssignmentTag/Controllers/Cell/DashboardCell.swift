//
//  DashboardCell.swift
//  AssignmentTag
//
//  Created by Prasanta Santikari on 08/02/22.
//

import UIKit

class DashboardCell: UITableViewCell {
    
    /// IBOutlet used
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var amountLabel: UILabel?
    @IBOutlet weak var idLabel: UILabel?
    
    /// To set name title.
    var name: String? {
        didSet {
            nameLabel?.isHidden = name == nil ? true : false
            nameLabel?.text = nameLabel?.isHidden ?? false ? "" : name
        }
    }
    
    /// To set amount
    var amount: String? {
        didSet {
            amountLabel?.isHidden = amount == nil ? true : false
            amountLabel?.text = amountLabel?.isHidden ?? false ? "" : amount
        }
    }
    
    /// To change lable font color
    var amountTextColor: Bool = false {
        didSet {
            if amountTextColor { amountLabel?.textColor = UIColor(named: Constants.transactionAmountColor) } else {
                amountLabel?.textColor = .gray
            }
        }
    }
    
    /// To set id
    var transactionId: String? {
        didSet {
            idLabel?.isHidden = transactionId == nil ? true : false
            idLabel?.text = idLabel?.isHidden ?? false ? "" : transactionId
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel?.isHidden = true
        amountLabel?.isHidden = true
        idLabel?.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

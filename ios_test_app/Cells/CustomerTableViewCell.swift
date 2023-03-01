//
//  CostumerTableViewCell.swift
//  ios_test_app
//
//  Created by AveNocturna on 2/27/23.
//

import UIKit

class CustomerTableViewCell: UITableViewCell {
    var customer:CustomerModel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

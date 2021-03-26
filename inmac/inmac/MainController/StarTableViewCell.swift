//
//  StarTableViewCell.swift
//  inmac
//
//  Created by Ria Song on 2021/03/21.
//

import UIKit

protocol MyCellDelegate {
    func btnCloseTapped(cell: UITableViewCell)
}

class StarTableViewCell: UITableViewCell {
    @IBOutlet var lbl_name: UILabel!
    @IBOutlet var lbl_phone: UILabel!
    @IBOutlet var lbl_no: UILabel!
    @IBOutlet var btnMvp: UIButton!
    
    var delegate: MyCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        delegate?.btnCloseTapped(cell: self)
    }

}

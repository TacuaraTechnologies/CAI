//
//  AudienciasTableViewCell.swift
//  
//
//  Created by Javier Rivarola on 27/Jul/15.
//
//

import UIKit

class AudienciasTableViewCell: UITableViewCell {

    @IBOutlet weak var descripcion: UILabel!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var notifySwitch: UISwitch!
    @IBOutlet weak var fecha: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
